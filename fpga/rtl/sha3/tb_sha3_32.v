`timescale 1ns/100ps
`include "sha3_constant.v"

module tb_sha3_32;

    parameter DEBUG = 0;

    parameter CLK_PERIOD        = 10;
    parameter CLK_HALF_PERIOD   = CLK_PERIOD / 2;

    reg     clk;
    
    initial begin
        clk = 1'b1;
    end
    
    always #CLK_HALF_PERIOD clk = ~clk;
    
    initial begin
        $fsdbDumpfile("tb_sha3_32.fsdb");
        $fsdbDumpvars(0, tb_sha3_32);
        #(CLK_PERIOD*1000) $finish;
    end

    reg                 sha3_rst_n;
    reg     [3-1:0]     sha3_SHAmode;
    reg                 sha3_ASmode;
    reg                 sha3_start;
    wire                sha3_ready;
    reg                 sha3_we;
    reg     [6-1:0]     sha3_address;
    reg     [32-1:0]    sha3_data_in;
    wire    [32-1:0]    sha3_data_out;

    reg     [4096-1:0]  digest;
    reg     [12-1:0]    digest_read;
    reg     [4096-1:0]  rev_digest;

    reg [1344-1:0] block0;
    reg [1344-1:0] block1;
    reg [4096-1:0] expected_digest;

    function [4096-1:0] bytereverse(input [4096-1:0] str, input [12-1:0] hash_len);
        integer idx;
        integer hash_bytes;
    begin
        hash_bytes = (hash_len[2:0] == 3'b0) ? hash_len[11:3] : (hash_len[11:3] + 'd1);
        bytereverse = 4096'b0;
        for(idx = 0; idx < hash_bytes; idx = idx + 1) begin
            bytereverse[(hash_bytes-idx)*8-1 -: 8] = str[idx*8 +: 8];
        end
    end
    endfunction // bytereverse

    task reset_sha3(input [3-1:0] SHAmode);
    begin
        sha3_rst_n = 1'b0;

        sha3_SHAmode = SHAmode;
        sha3_ASmode = `ASMODE_ABSORB;
        sha3_start = 1'b0;
        sha3_we = 1'b0;
        sha3_address = 6'd0;
        sha3_data_in = 32'b0;

        #(CLK_PERIOD);

        sha3_rst_n = 1'b1;

        #(CLK_PERIOD);
    end
    endtask // reset_sha3

    task write_word(input [6-1:0]   address,
                    input [32-1:0]  word);
    begin
        sha3_address = address;
        sha3_data_in = word;
        sha3_we = 1'b1;
        #(CLK_PERIOD);
        sha3_we = 1'b0;
    end
    endtask // write_word

    task write_block(input [1344-1:0] block, input [6-1:0] word_count);
        integer idx;
    begin
        for(idx = 0; idx < word_count && idx < 42; idx = idx + 1) begin
            write_word(idx,  block[(idx*32) +: 32]);
        end
    end
    endtask // write_block

    task start_absorb;
    begin
        sha3_ASmode = `ASMODE_ABSORB;
        sha3_start = 1'b1;
        #(CLK_PERIOD);
        sha3_start = 1'b0;
    end
    endtask // start_absorb

    task start_squeeze;
    begin
        sha3_ASmode = `ASMODE_SQUEEZE;
        sha3_start = 1'b1;
        #(CLK_PERIOD);
        sha3_start = 1'b0;
    end
    endtask // start_squeeze

    task wait_ready;
    begin
        while(sha3_ready == 1'b0) begin
            #(CLK_PERIOD);
        end
    end
    endtask // wait_ready

    task read_digest(input [12-1:0] offset,
                                  input [6-1:0] word_count);
        reg [6-1:0] idx;
        reg [13-1:0] current_offset;
    begin
        sha3_ASmode = `ASMODE_SQUEEZE;
        for(idx = 0; idx < word_count; idx = idx + 1) begin
            current_offset = offset + idx * 32;
            if(current_offset <= 4096 - 32) begin
                sha3_address = idx;
                #(CLK_PERIOD);
                digest[current_offset +: 32] = sha3_data_out;
            end
        end
    end
    endtask // read_digest

    task single_block_test(input [1344-1:0] block,
                           input [4096-1:0]  expected,
                           input [3-1:0]    SHAmode,
                           input [6-1:0]    word_count,
                           input [12-1:0]   hash_len);
    begin
        reset_sha3(SHAmode);

        write_block(block, word_count);
        start_absorb;
        #(CLK_PERIOD);
        wait_ready;

        digest_read = 12'd0;
        while(digest_read < hash_len) begin
            read_digest(digest_read, word_count);
            digest_read = digest_read + word_count * 32;
            if(digest_read < hash_len) begin
                start_squeeze;
                #(CLK_PERIOD);
                wait_ready;
            end
        end

        rev_digest = bytereverse(digest, hash_len);

        $display("    Expected: 0x%x", expected);
        $display("    Got:      0x%x", rev_digest);
        if (rev_digest == expected) begin
            $display("    Test OK.");
        end else begin
            $display("    Test Fail.");
        end
    end
    endtask // single_block_test 

    task double_block_test(input [1344-1:0] block0, input [1344-1:0] block1,
                           input [4096-1:0]  expected,
                           input [3-1:0]    SHAmode,
                           input [6-1:0]    word_count,
                           input [12-1:0]   hash_len);
    begin
        reset_sha3(SHAmode);

        write_block(block0, word_count);
        start_absorb;
        #(CLK_PERIOD);
        wait_ready;

        write_block(block1, word_count);
        start_absorb;
        #(CLK_PERIOD);
        wait_ready;

        digest_read = 12'd0;
        while(digest_read < hash_len) begin
            read_digest(digest_read, word_count);
            digest_read = digest_read + word_count * 32;
            if(digest_read < hash_len) begin
                start_squeeze;
                #(CLK_PERIOD);
                wait_ready;
            end
        end

        rev_digest = bytereverse(digest, hash_len);

        $display("    Expected: 0x%x", expected);
        $display("    Got:      0x%x", rev_digest);
        if (rev_digest == expected) begin
            $display("    Test OK.");
        end else begin
            $display("    Test Fail.");
        end
    end
    endtask // double_block_test 

    initial begin
        $display("SHA3 Test:");

        // ****************************** Regular SHA3 Test ******************************
        // Note: MSG || 01 || pad_10*1 to fix length as multiple of block size in SHA3.
        //       In SHA3-512  the block size is multiple of  576 (18 32-bit words).
        //          SHA3-384                                 832  26
        //          SHA3-256                                1088  34
        //          SHA3-224                                1152  36

        $display("  -- Test with message '' for SHA3-256 begin --");
        // Note: MSG || 01 || pad_10*1 to fix length as multiple of block size.
        block0 =
           1088'h8000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000006;
        expected_digest =
            256'ha7ffc6f8bf1ed766_51c14756a061d662_f580ff4de43b49fa_82d80a4b80f8434a;
        single_block_test(block0, expected_digest, `SHAMODE_SHA3_256, 34, 256);

        $display("  -- Test with message 'The quick brown fox jumps over the lazy dog.' for SHA3-256 begin --");
        // Note: MSG || 01 || pad_10*1 to fix length as multiple of block size
        block0 = 
           1088'h8000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_000000062e676f64_20797a616c206568_74207265766f2073_706d756a20786f66_206e776f7262206b_6369757120656854;
        expected_digest =
            256'ha80f839cd4f83f6c_3dafc87feae47004_5e4eb0d366397d5c_6ce34ba1739f734d;
        single_block_test(block0, expected_digest, `SHAMODE_SHA3_256, 34, 256);

        $display("  -- Test with message 'The quick brown fox jumps over the lazy dog. Again, the quick brown fox jumps over the lazy dog. Again, the quick brown fox jumps over the lazy dog.' for SHA3-256 begin --");
        // Note: MSG || 01 || pad_10*1 to fix length as multiple of block size
        block0 = 
           1088'h74207265766f2073_706d756a20786f66_206e776f7262206b_6369757120656874_202c6e6961674120_2e676f6420797a61_6c20656874207265_766f2073706d756a_20786f66206e776f_7262206b63697571_20656874202c6e69_616741202e676f64_20797a616c206568_74207265766f2073_706d756a20786f66_206e776f7262206b_6369757120656854;
        block1 = 
           1088'h8000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_000000062e676f64_20797a616c206568;
        expected_digest =
            256'h4808307481f34cf5_ef52746133d2ff12_a913915529179e16_9eba3c7ccb68f121;
        double_block_test(block0, block1, expected_digest, `SHAMODE_SHA3_256, 34, 256);


        $display("  -- Test with message '' for SHA3-512 begin --");
        // Note: MSG || 01 || pad_10*1 to fix length as multiple of block size.
        block0 =
            576'h8000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000006;
        expected_digest =
            512'hA69F73CCA23A9AC5_C8B567DC185A756E_97C982164FE25859_E0D1DCC1475C80A6_15B2123AF1F5F94C_11E3E9402C3AC558_F500199D95B6D3E3_01758586281DCD26;
        single_block_test(block0, expected_digest, `SHAMODE_SHA3_512, 18, 512);

        $display("  -- Test with message 'The quick brown fox jumps over the lazy dog.' for SHA3-512 begin --");
        // Note: MSG || 01 || pad_10*1 to fix length as multiple of block size
        block0 = 
            576'h8000000000000000_0000000000000000_0000000000000000_000000062e676f64_20797a616c206568_74207265766f2073_706d756a20786f66_206e776f7262206b_6369757120656854;
        expected_digest =
            512'h18f4f4bd419603f9_5538837003d9d254_c26c237655651622_47483f65c5030359_7bc9ce4d289f21d1_c2f1f458828e33dc_442100331b35e7eb_031b5d38ba6460f8;
        single_block_test(block0, expected_digest, `SHAMODE_SHA3_512, 18, 512);

        $display("  -- Test with message 'The quick brown fox jumps over the lazy dog. Again, the quick brown fox jumps over the lazy dog.' for SHA3-512 begin --");
        // Note: MSG || 01 || pad_10*1 to fix length as multiple of block size
        block0 = 
            576'h20786f66206e776f_7262206b63697571_20656874202c6e69_616741202e676f64_20797a616c206568_74207265766f2073_706d756a20786f66_206e776f7262206b_6369757120656854;
        block1 = 
            576'h8000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000006_2e676f6420797a61_6c20656874207265_766f2073706d756a;
        expected_digest =
            512'h6d5af139d336569b_7cb7e0b2577f9e5e_2e3705dbaeee1e24_c2ea1633cca242e5_d03a1c450361ed2e_913f1c6e80a7e554_69a657ed6872f08f_ffc1d41491544174;
        double_block_test(block0, block1, expected_digest, `SHAMODE_SHA3_512, 18, 512);



        // *********************************** SHAKE Test ***********************************
        // Note: MSG || 1111 || pad_10*1 to fix length as multiple of block size in SHAKE.
        //       In SHAKE-256 the block size is multiple of 1088 (34 32-bit words).
        //          SHAKE-128                               1344  42

        $display("  -- Test with message '' for SHAKE-128 begin --");
        // Note: MSG || 1111 || pad_10*1 to fix length as multiple of block size.
        block0 =
           1344'h8000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_000000000000001f;
        expected_digest =
           3000'h7f9c2ba4e88f827d616045507605853ed73b8093f6efbc88eb1a6eacfa66ef263cb1eea988004b93103cfb0aeefd2a686e01fa4a58e8a3639ca8a1e3f9ae57e235b8cc873c23dc62b8d260169afa2f75ab916a58d974918835d25e6a435085b2badfd6dfaac359a5efbb7bcc4b59d538df9a04302e10c8bc1cbf1a0b3a5120ea17cda7cfad765f5623474d368ccca8af0007cd9f5e4c849f167a580b14aabdefaee7eef47cb0fca9767be1fda69419dfb927e9df07348b196691abaeb580b32def58538b8d23f87732ea63b02b4fa0f4873360e2841928cd60dd4cee8cc0d4c922a96188d032675c8ac850933c7aff1533b94c834adbb69c6115bad4692d8619f90b0cdf8a7b9c264029ac185b70b83f2801f2f4b3f70c593ea3aeeb613a7f1b1de33fd75081f592305f2e4526edc09631b10958f464d889f31ba010250fda7f1368ec2967fc84ef2ae9aff268e0b1700affc6820b523a3d917135f2dff2ee06bfe72b3124721d4a26c04e53a75e30e73a7a9c4a95d91c;
        single_block_test(block0, expected_digest, `SHAMODE_SHAKE_128, 42, 3000);

        $display("  -- Test with message 'The quick brown fox jumps over the lazy dog.' for SHAKE-128 begin --");
        // Note: MSG || 1111 || pad_10*1 to fix length as multiple of block size.
        block0 =
           1344'h8000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000001f2e676f64_20797a616c206568_74207265766f2073_706d756a20786f66_206e776f7262206b_6369757120656854;
        expected_digest =
           3000'h634069e6b13c3af64c57f05babf5911b6acf1d309b9624fc92b0c0bd9f27f5386331af1672c94b194ce623030744b31e848b7309ee7182c4319a1f67f8644d2034039832313286eb06af2e3fa8d3caa89c72638f9d1b26151d904ed006bd9ae7688f99f57d4195c5cee9eb51508c49169df4c5ee6588e458a69fdc78782155550ef567e503b355d906417cb85e30e7156e53af8be5b0858955c46e21e6fa777b7e351c8dba47949f33b00deef231afc3b861aaf543a8a3db940f8309d1facd1f684ac021c61432dba58fa4a2a5148fd0edc6e6987d9783850e3f7c517986d87525f6e9856987e669ef38e0b3b7996c8777d657d4aac1885b8f2cfeed70e645c869f32d31945565cb2a7d981958d393f8005dbffb0c00dfccc8f0d6111729f3a64e69d2fd4399de6c11635a6ae46daa3e918d473c4e0b2bb974c1ac393977306759ea3989109a45df35c6783b18702d468e63628d3923758274e0101a9ebf81b36c5554864d5f05d66689991e33258d38b7dc43acb12432;
        single_block_test(block0, expected_digest, `SHAMODE_SHAKE_128, 42, 3000);

        $display("  -- Test with message 'The quick brown fox jumps over the lazy dog. Again, the quick brown fox jumps over the lazy dog. Again, the quick brown fox jumps over the lazy dog. Again, the quick brown fox jumps over the lazy dog.' for SHAKE-128 begin --");
        // Note: MSG || 1111 || pad_10*1 to fix length as multiple of block size
        block0 = 
           1344'h7262206b63697571_20656874202c6e69_616741202e676f64_20797a616c206568_74207265766f2073_706d756a20786f66_206e776f7262206b_6369757120656874_202c6e6961674120_2e676f6420797a61_6c20656874207265_766f2073706d756a_20786f66206e776f_7262206b63697571_20656874202c6e69_616741202e676f64_20797a616c206568_74207265766f2073_706d756a20786f66_206e776f7262206b_6369757120656854;
        block1 = 
           1344'h8000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_000000000000001f_2e676f6420797a61_6c20656874207265_766f2073706d756a_20786f66206e776f;
        expected_digest =
           3000'h860e70adb31ff2d800dc85747182776470f47aa44c81100362bc2be2dcef469b8dcb2a541dcc98893b3aefb0a9c8026ac10848e5589f171d835cbbf1b81c84b0fddb51fb0c5ff9bf936f4360290467a31e893098c8986fe1f5b79b0749099c2b482845ebb9c7a9aa02adfbcc036e3fec9549adb2f56289acf9a9f6b01b1bba08d5b5db6474cc3e1b298aad07a59c0ac01c1757db30571891f46a43ee619f3631a3bbb8f868843f707f26e303abe5efed86eb3310d7e2784c4146e0d0a7faea76eb563c0430da3e996cd92becc742552675b663f0e04bdfc31fbc14032ddfc72f06000d776282d7087dc9af093e6fb4725c0e3c3959775fc81073c6467b57bbabe25b3a3d915c3e792ca5f7d2abaada1216deb2db2216bd5ebfb157bc7577a88c3f44399131c0b882418ffe2db6769ed90d74aa8b78b7a9990af0223622684dce4dd837269110fe088f3ce392ccd2c361049615f100fb1b25ec430a85b227dc56f67a06021a1b730b6fc3ef66ef481b80e1fe58cdd81ac7;
        double_block_test(block0, block1, expected_digest, `SHAMODE_SHAKE_128, 42, 3000);


        $finish;
    end

    sha3_32 sha3_inst (
        .clk(clk),
        .rst_n(sha3_rst_n),
        .SHAmode(sha3_SHAmode),
        .ASmode(sha3_ASmode),
        .start(sha3_start),
        .ready(sha3_ready),
        .we(sha3_we),
        .address(sha3_address),
        .data_in(sha3_data_in),
        .data_out(sha3_data_out)
    ) ;

endmodule
