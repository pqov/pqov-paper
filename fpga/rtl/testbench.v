`include "define.v"
`define CYCLE  10.0
`define HCYCLE (`CYCLE/2)
`define RST_DELAY 10
`define RAND_WAIT \
    #(($urandom%5+2) * `CYCLE)
`define RESET   \
    `RAND_WAIT  \
    rst_n = 1; \
    `RAND_WAIT  \
    rst_n = 0; \
    `RAND_WAIT  \
    rst_n = 1; \
    `RAND_WAIT

module testbench;
    localparam KEYGEN_ADDR = 10'd0; // keygen
    localparam SIGN_ADDR = 10'd134; // sign
    localparam VRFY_ADDR = 10'd165; // vrfy
    localparam TEST_MODE = 2'd0; // test_mode
    localparam AES_ROUND = 10; // aes_round
    localparam KEYGEN_STATE     = 0;
    localparam SIGN_STATE       = 1;
    localparam VRFY_STATE       = 2;
    localparam SEND_INSTRUCTION = 3;
    localparam INST_DEPTH = 1024; // inst_depth
    localparam INST_LEN = 32; // inst_len
    localparam testdata = "test.data";

    integer idx;

    reg clk;
    reg rst_n;
    always # (`HCYCLE) clk = ~clk;

    // input/output signals for uov
    reg                     [2 : 0] states;
    reg  [$clog2(INST_DEPTH)-1 : 0] inst_addr;
    reg     [`GF_BIT*(`V+`O)-1 : 0] signature_in;
    wire                            done;
    wire    [`GF_BIT*(`V+`O)-1 : 0] result_out;
    wire                  [127 : 0] sig_rand_out;
    wire                   [30 : 0] cycles;
    
    reg     [`GF_BIT*(`V+`O)-1 : 0] signature;
    reg                   [127 : 0] signature_rand;
    reg     [`GF_BIT*(`V+`O)-1 : 0] signature2;
    reg                   [127 : 0] signature_rand2;
    
    reg                   [127 : 0] public_key_seed;

    reg                   [127 : 0] rand_in;
    reg                   [255 : 0] message_in;
    reg                   [127 : 0] public_key_seed_in;

    wire    [`GF_BIT*(`V+`O)-1 : 0] rev_result_out;      
    wire                  [127 : 0] rev_sig_rand_out;
    wire                  [127 : 0] rev_public_key_seed;
    genvar i;
    generate
        for (i = 0; i < (`GF_BIT*(`V+`O))/8; i=i+1) begin
            assign rev_result_out[8*i+:8]      = result_out[8*((`GF_BIT*(`V+`O))/8-1-i)+:8];
        end
        for (i = 0; i < 128/8; i=i+1) begin
            assign rev_sig_rand_out[8*i+:8]    = sig_rand_out[8*(128/8-1-i)+:8];
            assign rev_public_key_seed[8*i+:8] = result_out[8*(128/8-1-i)+:8];
        end
    endgenerate
    
    uov #(
        .GF_BIT(`GF_BIT),
        .OP_SIZE(`OP_SIZE),
        .V(`V),
        .O(`O),
        .N(`N),
        .L(`L),
        .K(`K),
        .L_ORI(`L_ORI),
        .V_(`V_),
        .O_(`O_),
        .INST_DEPTH(INST_DEPTH),
        .INST_LEN(INST_LEN),
        .TEST_MODE(TEST_MODE),
        .AES_ROUND(AES_ROUND)
    ) DUT (
        .clk(clk),
        .rst_n(rst_n),
        .input_states(states),
        .inst_addr(inst_addr),
        .signature_in(signature_in),
        .sig_rand_in(rand_in),
        .message_in(message_in),
        .public_key_seed_in(public_key_seed),
        .done(done),
        .result_out(result_out),
        .sig_rand_out(sig_rand_out),
        .cycles(cycles)
    );

    // Instruction memory
    wire           [INST_LEN-1:0] inst_data_in;
    wire [$clog2(INST_DEPTH)-1:0] inst_data_wr_addr;
    wire                          inst_data_wr_en;
    wire           [INST_LEN-1:0] inst_data_out;
    reg  [$clog2(INST_DEPTH)-1:0] inst_data_rd_addr;
    
    mem #(
        .WIDTH(INST_LEN),
        .DEPTH(INST_DEPTH),
        .FILE(testdata)
    ) mem_inst (
        .clock (clk),
        .data (inst_data_in),
        .rdaddress (inst_data_rd_addr),
        .wraddress (inst_data_wr_addr),
        .wren (inst_data_wr_en),
        .q (inst_data_out)
    );

    // Set the current function and the start line of the function
    task set_state(input [$clog2(INST_DEPTH)-1:0] input_addr, 
                   input                    [2:0] input_state);
    begin
        `RAND_WAIT;
        states     = input_state;
        inst_addr  = input_addr;
        `RESET;
    end
    endtask

    // Program the instruction memory
    task write_inst(input [$clog2(INST_DEPTH)-1:0] inst_addr);
    begin
        inst_data_rd_addr = inst_addr;
        message_in[INST_LEN+$clog2(INST_DEPTH)] = 0;
        `RAND_WAIT;
        message_in[INST_LEN-1:0] = inst_data_out;
        message_in[INST_LEN+$clog2(INST_DEPTH)-1:INST_LEN] = inst_addr;
        message_in[INST_LEN+$clog2(INST_DEPTH)] = 1;
        `RAND_WAIT;
    end
    endtask

    initial begin
        // Initialize
        clk        = 1'b1;
        message_in = 0;
        states     = 7;
        
        /*** SendInstruction ***/
        set_state(0, SEND_INSTRUCTION);
        for(idx = 0; idx < INST_DEPTH; idx = idx + 1) begin
            write_inst(idx);
        end
        

        /*** KeyGen ***/
        set_state(KEYGEN_ADDR, KEYGEN_STATE);

        @(posedge done);
        public_key_seed = result_out[127:0];
        $display("Keygen: %0d cycles", cycles);
        $display("pk seed: %x", rev_public_key_seed);


        /*** Sign ***/
        message_in         = 256'h5a45e7a4571d7f3661307efacefce2582e2b34ca59fa4c883b2c8aefd44be966;
        public_key_seed_in = public_key_seed;
        set_state(SIGN_ADDR, SIGN_STATE);

        @(posedge done);
        signature          = result_out;
        signature_rand     = sig_rand_out;
        $display("Sign: %0d cycles", cycles);
        $display("Signature: (%x, %x)", rev_result_out, rev_sig_rand_out);


        /*** Verify ***/
        signature_in       = signature;
        message_in         = 256'h5a45e7a4571d7f3661307efacefce2582e2b34ca59fa4c883b2c8aefd44be966;
        rand_in            = signature_rand;
        public_key_seed_in = public_key_seed;
        set_state(VRFY_ADDR, VRFY_STATE);

        @(posedge done);
        $display("Vrfy: %0d cycles", cycles);
        $display("Result: %x", result_out[0]);

        
        /*** Verify ***/
        signature_in       = signature;
        message_in         = 256'h5a45e7a4571d7f3661307efacefce2582e2b34ca59fa4c883b2c8aefd44be965;
        rand_in            = signature_rand;
        public_key_seed_in = public_key_seed;
        set_state(VRFY_ADDR, VRFY_STATE);

        @(posedge done);
        $display("Vrfy: %0d cycles", cycles);
        $display("Result: %x", result_out[0]);


        $finish;
    end
   
endmodule

