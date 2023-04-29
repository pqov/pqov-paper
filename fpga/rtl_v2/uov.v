`include "sha3_constant.v"
`include "define.v"

module uov #(
    parameter GF_BIT = 4,
    parameter OP_SIZE = 17,
    parameter V = 69,
    parameter O = 46,
    parameter N = 4, 
    parameter L = 8,
    parameter K = 16,
    parameter L_ORI = 8,
    parameter V_ = 3,
    parameter O_ = 2,
    parameter INST_DEPTH = 1024,
    parameter INST_LEN = 34,
    parameter TEST_MODE = 0,
    parameter AES_ROUND = 0
)(
    input wire                            clk,
    input wire                            rst_n,
    input wire [$clog2(INST_DEPTH)-1 : 0] inst_addr,
    input wire                    [2 : 0] input_states,
    input wire       [GF_BIT*(V+O)-1 : 0] signature_in,
    input wire                  [127 : 0] sig_rand_in,
    input wire                  [255 : 0] message_in,
    input wire                  [127 : 0] public_key_seed_in,
    output reg                            done,
    output reg       [GF_BIT*(V+O)-1 : 0] result_out,
    output reg                  [127 : 0] sig_rand_out,
    output reg                   [31 : 0] cycles
);

    integer n, m;
    genvar i, j, k;

    localparam KEYGEN_STATE     = 0;
    localparam SIGN_STATE       = 1;
    localparam VRFY_STATE       = 2;
    localparam SEND_INSTRUCTION = 3;
    localparam Q5   = (TEST_MODE == 0) ? 0 : 0;
    localparam F2   = (TEST_MODE == 0) ? 1 : 1;
    localparam Q2   = (TEST_MODE == 0) ? 2 : 1;
    localparam Q1   = (TEST_MODE == 0) ? 3 : 2;
    localparam RAND_STATE_NUM = 4; // rand_state_num
    localparam IMM_LEN = 18;
    

    
        
    reg [2:0] states;
    reg start_proc;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            states     <= input_states;
            start_proc <= 1;
        end else begin
            states     <= states;
            start_proc <= 0;
        end 
    end

    wire           [$clog2(O_*N+1)-1:0]         on_value = O_*N;
    wire           [$clog2(V_*N+1)-1:0]         vn_value = V_*N;
    wire              [$clog2(O+1)-1:0]          o_value = O;
    wire              [$clog2(V+1)-1:0]          v_value = V;
    wire              [$clog2(N+1)-1:0]          n_value = N;
    wire [$clog2(RAND_STATE_NUM+1)-1:0] rand_state_value = RAND_STATE_NUM;

    localparam RIGHT_DELAY = 2;
    localparam UP_DELAY = 1;
    localparam GAUSS_DATA_DELAY = 2*RIGHT_DELAY + UP_DELAY + 1+1;
    localparam GAUSS_OP_DELAY   = 2*RIGHT_DELAY + 2*UP_DELAY + 1+1+1;
    localparam RA_DELAY         = 2*RIGHT_DELAY + UP_DELAY + 1+1+1;
    localparam STORE_KEYS_DELAY = 2*RIGHT_DELAY + UP_DELAY + 1;
    localparam UNLOAD_DELAY     = 2*UP_DELAY + 2*RIGHT_DELAY + 4;
    localparam BANK = 5;

    /*** Instructions ***/
    localparam ADDI           = 6'b000_000;
    localparam SUBI           = 6'b000_001;
    localparam BNE            = 6'b000_010;
    localparam BEQ            = 6'b000_011;
    localparam BGT            = 6'b000_100;       
    localparam STALL          = 6'b001_000;
    localparam SHA_HASH_V     = 6'b001_001;
    localparam SHA_HASH_M     = 6'b001_010;
    localparam SHA_HASH_SK    = 6'b001_011;
    localparam SHA_SQUEEZE_SK = 6'b001_100;
    localparam SEND           = 6'b001_101;
    localparam STORE_O        = 6'b001_110;
    localparam AES_SET_ROUND  = 6'b010_000;
    localparam AES_SET_CTR    = 6'b010_001;
    localparam AES_UPDATE_CTR = 6'b010_010;        
    localparam AES_INIT_KEY   = 6'b010_011;  
    localparam AES_TO_TOWER   = 6'b010_100;
    localparam TOWER_TO_AES   = 6'b010_101;
    localparam GAUSS_ELIM     = 6'b011_000;
    localparam MUL_L_INV      = 6'b011_001;
    localparam MUL_O          = 6'b011_010;
    localparam LOAD_KEYS      = 6'b011_011;
    localparam STORE_KEYS     = 6'b011_100;
    localparam UNLOAD_CHECK   = 6'b100_000; 
    localparam ADD_TO_SIG_V   = 6'b100_001;
    localparam STORE_SIG_O    = 6'b100_010;
    localparam STORE_L        = 6'b100_011;
    localparam UNLOAD_ADD_Y   = 6'b100_100;
    localparam MUL_KEY_O_PIPE = 6'b101_001;
    localparam MUL_KEY_O      = 6'b101_010;
    localparam EVAL           = 6'b101_011;
    localparam CALC_L         = 6'b101_100;
    localparam MUL_KEY_SIG    = 6'b101_101;       
    localparam FINISH         = 6'b111_111;

    reg    [INST_LEN+$clog2(INST_DEPTH):0] inst_data;
    reg                     [INST_LEN-1:0] inst_data_in;
    reg           [$clog2(INST_DEPTH)-1:0] inst_data_wr_addr;
    reg                                    inst_data_wr_en;
    always @(posedge clk) begin
        inst_data         <= message_in[INST_LEN+$clog2(INST_DEPTH):0];
        inst_data_wr_en   <= (states == SEND_INSTRUCTION && inst_data[INST_LEN+$clog2(INST_DEPTH)]);
        inst_data_in      <= inst_data[INST_LEN-1:0];
        inst_data_wr_addr <= inst_data[INST_LEN+$clog2(INST_DEPTH)-1:INST_LEN];
    end
    wire [INST_LEN-1:0] inst_data_out;
    reg [INST_LEN-1:0] current_inst;
    reg [$clog2(INST_DEPTH)-1:0] inst_data_rd_addr;
    wire [$clog2(INST_DEPTH)-1:0] program_counter;
    
    mem #(
        .WIDTH(INST_LEN),
        .DEPTH(INST_DEPTH)
    ) mem_inst (
        .clock (clk),
        .data (inst_data_in),
        .rdaddress (program_counter),
        .wraddress (inst_data_wr_addr),
        .wren (inst_data_wr_en),
        .q (inst_data_out)
    );

    wire         [5:0]        op  = inst_data_out[5:0];
    wire [IMM_LEN-1:0]        imm = inst_data_out[23:6];
    wire         [3:0]        rs1 = inst_data_out[27:24];
    wire         [3:0]        rs2 = inst_data_out[31:28];
    wire         [3:0]        rs3 = inst_data_out[9:6];
    wire         [3:0]        rs4 = inst_data_out[13:10];
    wire         [2:0] data_addr1 = inst_data_out[16:14];
    wire         [2:0] data_addr2 = inst_data_out[19:17];
    wire        [14:0] imm_mul_key = {inst_data_out[23:17],inst_data_out[13:6]};
    

    // control instructions
    reg op_finish;
    wire should_stall = (op[5:3] == 3'b000) ? 0 : op_finish;
    reg mispredict;
    reg [IMM_LEN-1:0] control_reg   [0:15];
    reg [IMM_LEN-1:0] control_reg_w [0:15];

    
    always @(*) begin
        case(op)
            BNE: mispredict = (control_reg[rs1] != control_reg[rs2]);
            BEQ: mispredict = (control_reg[rs1] == control_reg[rs2]);
            BGT: mispredict = (control_reg[rs1] <  control_reg[rs2]);
            default: mispredict = 0;
        endcase
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
	    cycles <= 0;
	end else begin
	    cycles <= (op == FINISH) ? cycles : cycles + 1;
	end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            inst_data_rd_addr <= inst_addr;
        end else begin
            inst_data_rd_addr <= start_proc ? inst_data_rd_addr : 
                                 should_stall ? inst_data_rd_addr : 
                                 mispredict ? imm[$clog2(INST_DEPTH)-1:0]+1 : inst_data_rd_addr+1;
        end
    end

    wire [$clog2(V_)-1:0] adjusted_control_reg_rs1;
    buffering#(
        .SIZE($clog2(V_)),
        .DELAY(GAUSS_DATA_DELAY+1)
    ) adjusted_rs1 (clk, control_reg[rs1][$clog2(V_)-1:0], adjusted_control_reg_rs1);

    reg [IMM_LEN-1:0] proc_counter;
    reg [IMM_LEN-1:0] proc_counter_w;
    reg [IMM_LEN-1:0] buffered_plaintext;
    always @(posedge clk) begin
        proc_counter       <= proc_counter_w;
        buffered_plaintext <= control_reg[rs1] + imm;
    end

    reg [255:0] message_in_r;
    reg [255:0] sig_rand_in_r;
    always @(posedge clk) begin
        message_in_r  <= message_in;
        sig_rand_in_r <= sig_rand_in;
    end

    /*** Gaussian system control ***/
    reg running_gauss = 1'b0;
    reg [$clog2(K/N + 1) - 1 : 0] phase_counter;

    reg gauss_elim_start;
    reg start_phase = 1'b0;
    reg phase_done;
    reg last_phase;
    reg gauss_done;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            running_gauss <= 0;
        end else begin
            running_gauss <= gauss_elim_start || (running_gauss && !(last_phase && phase_done));
        end
    end
    always @(posedge clk) begin
        last_phase    <= (phase_counter == L/N-1);
        phase_counter <= gauss_elim_start ? 0 : 
                         !running_gauss ? 0 :
                         phase_done ? (last_phase ? 0 : phase_counter + 1) :
                         phase_counter;
        start_phase   <= gauss_elim_start ? 1'b1 :
                         !running_gauss ? 1'b0 :
                         (phase_done && !last_phase); 
        gauss_done    <= last_phase && phase_done;
    end


    /*** phase control ***/
    reg running_phase = 1'b0;
    wire [$clog2(K/N + 1) - 1 : 0] step_counter_comp;
    reg  [$clog2(K/N + 1) - 1 : 0] step_counter;
    reg  [$clog2(K/N + 1) - 1 : 0] col_block;

    reg start_step = 1'b0;
    reg step_done;
    reg last_step;

    reg functionA = 1'b0;

    assign step_counter_comp = start_phase ? phase_counter :
                               !running_phase ? 0 :
                               step_done ? (last_step ? 0 : step_counter + 1) :
                               step_counter;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            running_phase <= 0;
        end else begin
            running_phase <= start_phase || (running_phase && !(last_step && step_done));
        end
    end
    always @(posedge clk) begin
`ifdef USE_INVERSION
        last_step     <= (step_counter == K/N-1);
`else 
        last_step     <= (step_counter == L/N);
`endif
        step_counter  <= step_counter_comp;
        col_block     <= step_counter_comp;
        start_step    <= start_phase    ? 1'b1 :
                         !running_phase ? 1'b0 :
                        (step_done && !last_step);
        functionA     <= start_phase || (functionA && !step_done);
        phase_done    <= last_step && step_done;
    end

    /*** step control ***/
    reg running_step = 1'b0;
    reg [$clog2(L*K/N+2*N + 1) - 1 : 0] start_row   = 0;
    reg [$clog2(L*K/N+2*N + 1) - 1 : 0] end_row     = 0;
    reg [$clog2(L*K/N+2*N + 1) - 1 : 0] end_counter = 0;
    reg [$clog2(L*K/N+2*N + 1) - 1 : 0] row_counter = 0;
    reg [$clog2(L*K/N+2*N + 1) - 1 : 0] col_block_L = 0;
    reg start_data = 1'b0;
    reg start_comp = 1'b0;
    reg have_col_block_L = 1'b0;

    always @(posedge clk) begin
        if (~rst_n) begin
            running_step     <= 0;
        end else begin
            running_step     <= start_data || (running_step && !(row_counter == end_counter));
        end
    end
    always @(posedge clk) begin
        col_block_L      <= start_step ? col_block * L : col_block_L;
        start_row        <= have_col_block_L ? col_block_L           : start_row;
        end_row          <= have_col_block_L ? col_block_L + L - 1   : end_row;
        end_counter      <= have_col_block_L ? col_block_L + L + 2*N : end_counter;  
        have_col_block_L <= start_step;
        start_data       <= have_col_block_L;
        start_comp       <= start_data;          
    end


    localparam T_BRAM_DEPTH  = $clog2((V_*O_)*N);
    localparam TRANS_BRAM_DEPTH = $clog2(2*O_*O_*N);
    localparam KEY_BRAM_SIZE = 1884;
    localparam KEY_BRAM_DEPTH = $clog2(KEY_BRAM_SIZE);

`ifdef USE_INVERSION
    reg store_to_o_en;
    wire adjusted_store_to_o_en;

    buffering#(
        .SIZE(1),
        .DELAY(GAUSS_DATA_DELAY)
    ) adjusted_store_o (clk, store_to_o_en, adjusted_store_to_o_en);
`endif

    reg add_to_v_en;
    wire adjusted_add_to_v_en;

    buffering#(
        .SIZE(1),
        .DELAY(GAUSS_DATA_DELAY)
    ) adjusted_add_to_v (clk, add_to_v_en, adjusted_add_to_v_en);

    wire [IMM_LEN-1:0] adjusted_proc_counter;
    buffering#(
        .SIZE(IMM_LEN),
        .DELAY(GAUSS_DATA_DELAY)
    ) adjusted_proc_cnt (clk, proc_counter, adjusted_proc_counter);

    reg  [GF_BIT*N - 1 : 0] din_data = 0;
    wire [GF_BIT-1:0] shift_out = din_data[GF_BIT-1:0];
    wire [GF_BIT*N - 1 : 0] dout_data;
    wire [GF_BIT*N - 1 : 0] dout_data_trans;

    reg [TRANS_BRAM_DEPTH - 1 : 0] rd_addr_data_gauss;
    reg [TRANS_BRAM_DEPTH - 1 : 0] wr_addr_data_gauss;
    reg rd_en_data_gauss;
    reg wr_en_data_gauss;

    wire [TRANS_BRAM_DEPTH - 1 : 0] adjusted_wr_addr_data;
    wire                            adjusted_wr_en_data;

    reg [TRANS_BRAM_DEPTH - 1 : 0] rd_addr_data_trans;
    reg [TRANS_BRAM_DEPTH - 1 : 0] wr_addr_data;
    reg                            wr_en_data;
    
    reg                           wr_en_data_trans;
    wire                          adjusted_wr_en_data_trans;
    
    buffering#(
        .SIZE(TRANS_BRAM_DEPTH),
        .DELAY(GAUSS_DATA_DELAY)
    ) data_addr_delay (clk, wr_addr_data, adjusted_wr_addr_data);
    buffering#(
        .SIZE(1),
        .DELAY(GAUSS_DATA_DELAY)
    ) data_en_delay (clk, wr_en_data, adjusted_wr_en_data);
    buffering#(
        .SIZE(1),
        .DELAY(GAUSS_DATA_DELAY)
    ) data_en_trans_delay (clk, wr_en_data_trans, adjusted_wr_en_data_trans);

    // T_mem
    wire       [GF_BIT*N - 1 : 0] T_mem_dout;
    reg                           T_mem_en;
    reg        [GF_BIT*N - 1 : 0] T_mem_din;
    reg [$clog2(V_*O_*N) - 1 : 0] T_mem_rd_addr;               
    reg [$clog2(V_*O_*N) - 1 : 0] T_mem_wr_addr; 
    wire [GF_BIT-1:0] T_mem_dout_GF [0:N-1];
    generate
        for (i = 0; i < N; i=i+1) begin
            assign T_mem_dout_GF[i] = T_mem_dout[GF_BIT*i+:GF_BIT];
        end
    endgenerate              
    mem #(
        .WIDTH(GF_BIT*N),
        .DEPTH(V_*O_*N)
    ) t_mem (
        .clock (clk),
        .data (T_mem_din),
        .rdaddress (T_mem_rd_addr),
        .wraddress (T_mem_wr_addr),
        .wren (T_mem_en),
        .q (T_mem_dout)
    );


    ///////////////////////////////////////
    localparam OP_DEPTH_BIT = $clog2(L+2*N + 1);
    reg  [2*N - 1 : 0] din_op;
    wire [2*N - 1 : 0] dout_op;
    reg [OP_DEPTH_BIT - 1 : 0] rd_addr_op;
    reg [OP_DEPTH_BIT - 1 : 0] wr_addr_op;
    reg rd_en_op;
    reg wr_en_op;

    wire [OP_DEPTH_BIT - 1 : 0] adjusted_wr_addr_op;
    wire                        adjusted_wr_en_op;
    buffering#(
        .SIZE(OP_DEPTH_BIT),
        .DELAY(GAUSS_OP_DELAY)
    ) op_addr_delay (clk, wr_addr_op, adjusted_wr_addr_op);
    buffering#(
        .SIZE(1),
        .DELAY(GAUSS_OP_DELAY)
    ) op_en_delay (clk, wr_en_op, adjusted_wr_en_op);

    generate
    if (O == 96) begin
    lutmem #(
        .WIDTH(2*N),
        .DEPTH(L+2*N+1)
    ) mem_op (
        .clock (clk),
        .data (din_op),
        .rdaddress (rd_addr_op),
        .wraddress (adjusted_wr_addr_op),
        .wren (adjusted_wr_en_op),
        .q (dout_op)
    );
    end else begin
    mem #(
        .WIDTH(2*N),
        .DEPTH(L+2*N+1)
    ) mem_op (
        .clock (clk),
        .data (din_op),
        .rdaddress (rd_addr_op),
        .wraddress (adjusted_wr_addr_op),
        .wren (adjusted_wr_en_op),
        .q (dout_op)
    );
    end
    endgenerate

    ///////////////////////////////////////
    reg  [GF_BIT*N - 1 : 0] din_dataB;
    wire [GF_BIT*N - 1 : 0] dout_dataB;
    wire   [GF_BIT - 1 : 0] din_dataB_GF[0:N-1];
    generate
        for (i = 0; i < N; i=i+1) begin
            assign din_dataB_GF[i] = din_dataB[GF_BIT*i+:GF_BIT];
        end
    endgenerate


    // storing dataB
    mem #(
        .WIDTH(GF_BIT*N),
        .DEPTH(L+2*N+1)
    ) mem_dataB (
        .clock (clk),
        .data (din_dataB),
        .rdaddress (rd_addr_op),
        .wraddress (adjusted_wr_addr_op),
        .wren (adjusted_wr_en_op),
        .q (dout_dataB)
    );


    // store Lhat
    reg                     unload_en;
    reg                     unload_en_w;
    reg    [$clog2(O_)-1:0] unload_cnt;
    reg    [$clog2(O_)-1:0] unload_cnt_w;
    reg               [5:0] unload_op;
    reg               [5:0] unload_op_w;
    reg  [$clog2(O_*N)-1:0] unload_control_reg_rs1;
    reg  [$clog2(O_*N)-1:0] unload_control_reg_rs1_w;
    wire                    adjusted_unload_en;
    wire   [$clog2(O_)-1:0] adjusted_unload_cnt;
    wire              [5:0] adjusted_unload_op;
    wire [$clog2(O_*N)-1:0] adjusted_unload_control_reg_rs1;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            unload_en              <= 0;
            unload_cnt             <= 0;
            unload_op              <= 0;
            unload_control_reg_rs1 <= 0;
        end else begin
            unload_en              <= unload_en_w;
            unload_cnt             <= unload_cnt_w;
            unload_op              <= unload_op_w;
            unload_control_reg_rs1 <= unload_control_reg_rs1_w;
        end
    end
    buffering#(
        .SIZE(1),
        .DELAY(UNLOAD_DELAY)
    ) buffer_unload_en (clk, unload_en, adjusted_unload_en);

    buffering#(
        .SIZE($clog2(O_)),
        .DELAY(UNLOAD_DELAY)
    ) buffer_unload_cnt (clk, unload_cnt, adjusted_unload_cnt);

    buffering#(
        .SIZE(6),
        .DELAY(UNLOAD_DELAY)
    ) buffer_unload_op (clk, unload_op, adjusted_unload_op);

    buffering#(
        .SIZE($clog2(O_*N)),
        .DELAY(UNLOAD_DELAY)
    ) buffer_unload_control_reg_rs1 (clk, unload_control_reg_rs1, adjusted_unload_control_reg_rs1);

    // for unload and accumulate along BANK
    reg    [GF_BIT-1:0] unload_accumulator[0:N-1];
    wire [N*GF_BIT-1:0] unload_accumulators;
    reg              unload_set;
    reg              unload_set_w;
    reg [$clog2(BANK)-1:0] unload_set_counter;
    reg   [$clog2(O_)-1:0] unload_set_cnt;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            unload_set_counter <= 0;
            unload_set         <= 0;
            unload_set_cnt     <= 0;
        end else begin
            unload_set_counter <= (unload_set || unload_set_counter>0) ? 
                                  (unload_set_counter == BANK-1 ? 0 : unload_set_counter+1) : 0;
            unload_set_cnt     <= (proc_counter == 0) ? 0 :
                                  (unload_set_counter == BANK-1) ? unload_set_cnt+1 : unload_set_cnt;
            unload_set         <= unload_set_w;
        end
    end   
    wire adjusted_unload_set;
    buffering#(
        .SIZE(1),
        .DELAY(UNLOAD_DELAY)
    ) buffer_unload_set (clk, unload_set, adjusted_unload_set);
    
    wire [N*GF_BIT-1:0] adjusted_din_dataB;
    wire   [GF_BIT-1:0] adjusted_din_dataB_GF[0:N-1];
    buffering#(
        .SIZE(N*GF_BIT),
        .DELAY(1)
    ) buffer_din_dataB (clk, din_dataB, adjusted_din_dataB);
    generate
        for (i = 0; i < N; i=i+1) begin
            assign adjusted_din_dataB_GF[i] = adjusted_din_dataB[i*GF_BIT+:GF_BIT];
            assign unload_accumulators[i*GF_BIT+:GF_BIT] = unload_accumulator[i];
        end
    endgenerate
    always @(posedge clk) begin
        for (n = 0; n < N; n=n+1) begin
            unload_accumulator[n] <= (adjusted_unload_set) ? adjusted_din_dataB_GF[n] : adjusted_din_dataB_GF[n] ^ unload_accumulator[n];
        end
    end 

`ifdef USE_INVERSION
    wire         [GF_BIT*N-1:0] trans_bram_data      = (adjusted_unload_en ? unload_accumulators : din_data); 
    wire [TRANS_BRAM_DEPTH-1:0] trans_bram_wraddress = (adjusted_unload_en ? adjusted_unload_cnt*on_value + adjusted_unload_control_reg_rs1 : adjusted_wr_addr_data); 
    wire                        trans_bram_wren      = ((adjusted_unload_en && adjusted_unload_op == STORE_L) || adjusted_wr_en_data_trans);
    wire [TRANS_BRAM_DEPTH-1:0] trans_bram_rdaddress = rd_addr_data_trans;
`else
    // for transpose
    wire [TRANS_BRAM_DEPTH-1:0] transpose_rdaddress_w;
    wire [TRANS_BRAM_DEPTH-1:0] transpose_wraddress_w;
    wire    [N*GF_BIT-1:0] transpose_data;
    reg [$clog2(O_*N)-1:0] transpose_rdaddress;
    reg [$clog2(O_*N)-1:0] transpose_wraddress;
    reg                    transpose_ren;
    reg                    transpose_wen;
    generate
        reg       [GF_BIT-1:0] transpose_buffer[0:O_*N-1];
        reg [$clog2(O_*N)-1:0] transpose_control_reg_rs1;
        wire start_store_trans = (adjusted_unload_en && adjusted_unload_op == STORE_L && adjusted_unload_cnt[$clog2(O_)-1:0] == O_-1);
        always @(posedge clk) begin
            for (n = 0; n < O_; n=n+1) begin
                for (m = 0; m < N; m=m+1) begin
                    transpose_buffer[n*N+m] <= (adjusted_unload_en && adjusted_unload_op == STORE_L && adjusted_unload_cnt[$clog2(O_)-1:0] == n) ? 
                                               unload_accumulators[m*GF_BIT+:GF_BIT] : transpose_buffer[n*N+m];
                end
            end
        end
        wire[$clog2(N)-1:0] transpose_i_idx   [0:N-1]; 
        for (i = 0; i < N; i=i+1) begin
            assign transpose_i_idx[i] = i;
            assign transpose_data[i*GF_BIT+:GF_BIT] = (transpose_control_reg_rs1[$clog2(N)-1:0] == i) ? 
                                                       transpose_buffer[transpose_wraddress] :
                                                       dout_data_trans[i*GF_BIT+:GF_BIT];
        end
        always @(posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                transpose_ren             <= 0;
                transpose_wen             <= 0;
                transpose_control_reg_rs1 <= 0;
                transpose_rdaddress       <= 0;
                transpose_wraddress       <= 0;
            end else begin
                transpose_ren             <= start_store_trans && !transpose_ren ? 1 :
                                             transpose_rdaddress == O-1 ? 0 : transpose_ren;
                transpose_wen             <= transpose_ren;
                transpose_control_reg_rs1 <= (adjusted_unload_en && adjusted_unload_op == STORE_L) ? adjusted_unload_control_reg_rs1 : transpose_control_reg_rs1;
                transpose_rdaddress       <= (transpose_rdaddress == O-1) ? 0 :
                                             transpose_ren ? transpose_rdaddress + 1 :
                                             transpose_rdaddress;
                transpose_wraddress       <= transpose_rdaddress;
            end
        end
        wire [$clog2(O_):0] which_o_ = (transpose_control_reg_rs1 >> $clog2(N));
        assign transpose_rdaddress_w = transpose_rdaddress + which_o_*on_value;
        assign transpose_wraddress_w = transpose_wraddress + which_o_*on_value;
    endgenerate

    wire         [GF_BIT*N-1:0] trans_bram_data      = (transpose_wen ? transpose_data : din_data); 
    wire [TRANS_BRAM_DEPTH-1:0] trans_bram_wraddress = (transpose_wen ? transpose_wraddress_w : adjusted_wr_addr_data); 
    wire                        trans_bram_wren      = (transpose_wen || adjusted_wr_en_data_trans);
    wire [TRANS_BRAM_DEPTH-1:0] trans_bram_rdaddress = (transpose_ren ? transpose_rdaddress_w : rd_addr_data_trans);
`endif

    localparam TRANS_BRAM_NUM = 2*O_*O_*N;
    // trans bram
    generate
    if (O == 96) begin
    lutmem #(
        .WIDTH(GF_BIT*N),
        .DEPTH(TRANS_BRAM_NUM)
    ) mem_data_trans (
        .clock (clk),
        .data (trans_bram_data),
        .rdaddress (trans_bram_rdaddress),
        .wraddress (trans_bram_wraddress),
        .wren (trans_bram_wren),
        .q (dout_data_trans)
    );
    end else begin
    mem #(
        .WIDTH(GF_BIT*N),
        .DEPTH(TRANS_BRAM_NUM)
    ) mem_data_trans (
        .clock (clk),
        .data (trans_bram_data),
        .rdaddress (trans_bram_rdaddress),
        .wraddress (trans_bram_wraddress),
        .wren (trans_bram_wren),
        .q (dout_data_trans)
    );
    end 
    endgenerate


    
    // SA module
    reg SA_start;
    reg SA_finish;

    wire [GF_BIT*N-1 : 0] SA_dout;
    reg  [2*N-1 : 0] SA_op_in;
    wire [2*N-1 : 0] SA_op_out;
    reg  [GF_BIT*N-1 : 0] SA_dataB_in;
    reg  [GF_BIT*N-1 : 0] dataB_in;
    reg  [GF_BIT*N-1 : 0] dataA_in;
    wire [GF_BIT*N-1 : 0] SA_dataB_out;
    wire SA_r_A_and;

    reg  [GF_BIT*N-1 : 0] SA_din;

    
    reg fail;
    always @(posedge clk) begin
        fail <= (row_counter == (2*N+2*phase_counter*N+RA_DELAY) && functionA) ? ~SA_r_A_and : 0;
    end 
    
    reg [GF_BIT-1:0] sig_temp  [0:O_*N-1];
    

    reg SA_data_en = 1'b0;
    reg SA_op_en   = 1'b0;

    reg [$clog2(L     + 2*N + 1) - 1 : 0] rd_en_op_end;
    reg [$clog2(L*K/N + 2*N + 1) - 1 : 0] wr_en_op_end;
    reg [$clog2(L*K/N + 2*N + 1) - 1 : 0] wr_en_data_start;
    reg [$clog2(L*K/N + 2*N + 1) - 1 : 0] wr_en_data_end;
    reg [$clog2(L*K/N + 2*N + 1) - 1 : 0] SA_finish_end;


    wire          [L/N-1:0] is_diagonal_and_one;
    wire          [L/N-1:0] is_diagonal;
    wire                    is_zeros;
    wire                    row_greater_than_L; // deal with case that N cannot divide L 
    wire                    is_first_block; // for gauss elimination
    wire [$clog2(O_*N)-1:0] gauss_idx;      // for gauss elimination
    generate
        for (i = 0; i < L/N; i=i+1) begin
            assign is_diagonal_and_one[i] = (row_counter == (N*((L/N)*(L/N)+(L/N+1)*i))) && phase_counter == 0;
            assign is_diagonal[i] = ((N*((L/N)*(L/N)+(L/N+1)*i)) < row_counter) &&
                                    ((N*((L/N)*(L/N)+(L/N+1)*i)+N) > row_counter) && phase_counter == 0;
        end
        assign is_zeros = (row_counter >= (N*(L/N)*(L/N))) && phase_counter == 0;
        assign row_greater_than_L = ((N*((L/N)*(L/N)+(L/N+1)*(L/N-1))+N-(L-L_ORI)-1) < row_counter) &&
                                    ((N*((L/N)*(L/N)+(L/N+1)*(L/N-1))+N) > row_counter) && phase_counter == 0; // last case
        assign is_first_block = (row_counter >= (N*((L/N)*(L/N)))) && (row_counter < N*((L/N)*(L/N) + (L/N))) && phase_counter == 0;
        assign gauss_idx = (row_counter-(N*((L/N)*(L/N))));
    endgenerate
    always @(posedge clk) begin
`ifdef USE_INVERSION
        SA_din       <= ((|is_diagonal_and_one) ? 1 :
                         (|is_diagonal && !row_greater_than_L) ? (SA_din << GF_BIT) :
                          !SA_data_en || is_zeros || row_greater_than_L ? 0 : dout_data_trans);
`else 
        SA_din       <= ((is_first_block && !row_greater_than_L) ? sig_temp[gauss_idx] :
                          !SA_data_en || is_zeros || row_greater_than_L ? 0 : dout_data_trans);
`endif
        SA_op_in     <= functionA ? 0 : 
                        SA_op_en  ? dout_op : 0;
    
        SA_dataB_in  <= functionA ? 0 : 
                        SA_op_en  ? dout_dataB : 0;
        din_dataB    <= SA_dataB_out;
    
    
        step_done    <= (row_counter == end_counter) ? running_step : 0;
    
        row_counter  <= start_comp   ? start_row : 
                        running_step ? row_counter + 1 : 0;
    
    
        rd_addr_data_gauss <= start_step ? 0  :
                        start_data   ? start_row :
                        (rd_en_data_gauss) ? rd_addr_data_gauss + 1 : end_row;
        rd_en_data_gauss <= start_data ? 1 : running_step ? rd_addr_data_gauss < end_row : 0;
    
        SA_data_en   <= rd_en_data_gauss;
    
        rd_en_op_end <= start_step ? L+2*N : rd_en_op_end;
    
        rd_addr_op   <= start_data ? 0 :
                        (rd_en_op) ? rd_addr_op + 1 : 0;
        rd_en_op     <= (running_step || start_data) ? rd_addr_op < rd_en_op_end : 0;
    
        SA_op_en     <= rd_en_op;
    
    
        wr_en_op_end <= start_data ? (end_row + 2 +2*N) : wr_en_op_end;
    
        din_op       <= SA_op_out;
        wr_en_op     <= functionA ? (row_counter > start_row) && (row_counter <= wr_en_op_end)
                        : 0;
        wr_addr_op   <= wr_en_op ? wr_addr_op + 1 : 0;
    
        wr_en_data_start <= start_data ? (start_row + 2*N+1) : wr_en_data_start;
        wr_en_data_end   <= start_data ? (end_row + 2 + 2*N) : wr_en_data_end;
    
        din_data      <= SA_dout;
    
        wr_en_data_gauss <= (row_counter >= wr_en_data_start) && (row_counter < wr_en_data_end);
        wr_addr_data_gauss <= wr_en_data_gauss ? wr_addr_data_gauss + 1 : start_row;
    
        SA_start      <= (row_counter == start_row) && SA_data_en;
    
    
        SA_finish_end <= start_data ? end_row + 1 : SA_finish_end;
    
        SA_finish     <= functionA && (row_counter == SA_finish_end);
    end

    

    /*** raindom number generators ***/
    wire    [127:0] TRN;
    
    // wire update = 1;
    // test_rng trng0 ( 
    //     .rst(rst_n), 
    //     .clk(clk), 
    //     .update(update), 
    //     .TRN(TRN) 
    // );
    reg  [128-1:0]  salt;
    always @(posedge clk) begin
        salt <= (states == SIGN_STATE && start_proc) ? 128'hcafebabecafebabecafebabecafebabe : salt; // TODO
    end



    /*** AES for public keys ***/
    reg          aes_init;
    reg          aes_next;
    wire         aes_ready;
    reg  [127:0] aes_key;
    wire [127:0] aes_key_bytereverse;
    reg  [127:0] aes_ptext;
    wire [127:0] aes_ctext_temp;
    wire [127:0] aes_ctext_bytereverse;
    wire [127:0] aes_ctext;
    wire         aes_result_valid;
    reg          current_aes_state; // 0: idle, 1: generating
    reg    [3:0] aes_round;
    reg  [127:0] public_key_seed;

    localparam BUFFER_DEPTH = (O == 96) ? 1024 : 512;   
    localparam BUFFER_MULTIPLIER = (O == 44) ? 21 :
                                   (O == 72) ? 14 :
                                   (O == 96) ? 19 :
                                   24;
    reg   [$clog2(BUFFER_DEPTH)-1:0] pk_cnt_end; // 9-bit because of the buffer depth
    reg   [$clog2(BUFFER_DEPTH)-1:0] pk_cnt;     // 9-bit because of the buffer depth
    reg [127:0] pk_in;
    wire aes_init_key_finish;

    assign aes_init_key_finish = proc_counter > 2 && aes_ready;

    aes_core #(
        .AES_ROUND_NUM(AES_ROUND)
    ) aes_core0 (
        .clk(clk), 
        .reset_n(rst_n), 
        .init(aes_init),
        .next(aes_next),
        .ready(aes_ready),
        .key({aes_key_bytereverse, 128'b0}),         // put in the upper 128-bit
        .keylen(1'b0),                   // 1'b0: 128-bit key mode; 1'b1: 256-bit mode
        .block(aes_ptext),
        .result(aes_ctext_temp),
        .result_valid(aes_result_valid),
        .aes_round(aes_round)
    ); 

    generate
        for (i = 0; i < 16; i=i+1) begin
            assign aes_ctext_bytereverse[8*(15-i)+:8] = aes_ctext_temp[8*i+:8];
	        assign aes_key_bytereverse[8*(15-i)+:8]   = aes_key[8*i+:8];
        end
        
`ifdef USE_TOWER_FIELD
        if (GF_BIT == 4) begin
            for (i = 0; i < 128/GF_BIT; i=i+1) begin
                gfaes_to_gft_16 gfaes_to_gft_16_u(aes_ctext_bytereverse[GF_BIT*i+:GF_BIT], aes_ctext[GF_BIT*i+:GF_BIT]);
            end
        end else if (GF_BIT == 8) begin
            for (i = 0; i < 128/GF_BIT; i=i+1) begin
                gfaes_to_gft_256 gfaes_to_gft_256_u(aes_ctext_bytereverse[GF_BIT*i+:GF_BIT], aes_ctext[GF_BIT*i+:GF_BIT]);
            end
        end
`else
        assign aes_ctext = aes_ctext_bytereverse;
`endif
    endgenerate   

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            pk_cnt_end        <= 0;
            pk_cnt            <= 0;
            current_aes_state <= 0;
        end else begin
            pk_cnt_end       <= (op == AES_UPDATE_CTR && proc_counter[0] == 0) ? imm[$clog2(BUFFER_DEPTH)-1:0] : pk_cnt_end;
            pk_cnt           <= (op == AES_UPDATE_CTR && proc_counter[0] == 0) ? 0 :
`ifdef USE_PIPELINED_AES
                                (pk_cnt != pk_cnt_end && current_aes_state) ? pk_cnt+1 : 
`else
                                (aes_ready && pk_cnt != pk_cnt_end && current_aes_state && !aes_next) ? pk_cnt+1 : 
`endif
                                pk_cnt;
            current_aes_state <= (op == AES_UPDATE_CTR && aes_ready && proc_counter[0] == 1) ? 1 :
`ifdef USE_PIPELINED_AES
                                 (pk_cnt == pk_cnt_end) ? 0 : 
`else
                                 (pk_cnt == pk_cnt_end && aes_ready) ? 0 : 
`endif
                                 current_aes_state;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) aes_round <= 4'ha;
        else aes_round <= (op == AES_SET_ROUND && proc_counter[0] == 0) ? imm[3:0] : aes_round;
    end
    wire [IMM_LEN-1:0] aes_ptext_plus_1 = aes_ptext[IMM_LEN-1:0]+1;
    always @(posedge clk) begin 
        aes_init        <= (op == AES_INIT_KEY && proc_counter == 1) ? 1 : 0;
        aes_key         <= (op == AES_INIT_KEY && imm[0] == 0 && proc_counter == 0) ? 128'hdeadbeefdeadbeefdeadbeefdeadbeef :  // TODO
                           (op == AES_INIT_KEY && imm[0] == 1) ? public_key_seed_in : aes_key;
`ifdef USE_PIPELINED_AES
        aes_next        <= ((op == AES_UPDATE_CTR) && proc_counter[0] == 1) ||
                            (pk_cnt < (pk_cnt_end-1) && current_aes_state) ? 1 : 0;
`else
        aes_next        <= ((op == AES_UPDATE_CTR) && proc_counter[0] == 0) ||
                            (aes_ready && pk_cnt < (pk_cnt_end-1) && current_aes_state && !aes_next) ? 1 : 0;
`endif

        aes_ptext       <= (op == AES_SET_CTR && proc_counter[0] == 1) ? buffered_plaintext :
`ifdef USE_PIPELINED_AES
                           (pk_cnt < pk_cnt_end && current_aes_state) ? {aes_ptext[127:IMM_LEN], aes_ptext_plus_1} :
`else 
                           (aes_ready && pk_cnt < pk_cnt_end && current_aes_state && !aes_next) ? {aes_ptext[127:IMM_LEN], aes_ptext_plus_1} :
`endif
                           aes_ptext;    // pk_cnt = 1 -> update ctr, but not nexting the block
        public_key_seed <= aes_key;
    end

    

    /*** sha3 for others ***/
    reg             sha3_rst_n;
    reg    [3-1:0]  sha3_SHAmode = `SHAMODE_SHAKE_256;
    reg             sha3_ASmode;
    reg             sha3_start;
    wire            sha3_ready;
    reg             sha3_we;
    reg    [5-1:0]  sha3_address;
    reg   [64-1:0]  sha3_data_in;
    wire  [64-1:0]  sha3_data_out;
    wire  [64-1:0]  sha3_data_out_temp;
    reg    [255:0]  secret_key_seed;
    reg      [7:0]  ctr;
    
    localparam msg_word_cnt = (O*GF_BIT/64) + 1;
    reg [$clog2(msg_word_cnt):0] msg_cnt;
    reg [$clog2(msg_word_cnt):0] msg_cnt_temp;
    reg    [64*msg_word_cnt-1:0] msg_buffer;
    reg [$clog2(msg_word_cnt):0] msg_buffer_idx[0:msg_word_cnt-1];
    reg                   [64:0] msg_in;
    localparam sig_word_cnt = (V*GF_BIT/64) + 1; // sig_word_cnt
    reg [$clog2(sig_word_cnt):0] sig_cnt;
    reg [$clog2(sig_word_cnt):0] sig_cnt_temp;
    reg    [64*sig_word_cnt-1:0] sig_buffer;
    reg [$clog2(sig_word_cnt):0] sig_buffer_idx[0:sig_word_cnt-1];
    reg                   [64:0] sig_in;

    reg [$clog2(BUFFER_DEPTH):0] sk_cnt_end;
    reg [$clog2(BUFFER_DEPTH):0] sk_cnt;
    reg [$clog2(BUFFER_DEPTH):0] sk_cnt_temp;
    reg                    [1:0] sha3_state;
    reg                   [63:0] sk_in;

    sha3_64 sha3_inst (
        .clk(clk),
        .rst_n(sha3_rst_n),
        .SHAmode(sha3_SHAmode),
        .ASmode(sha3_ASmode),
        .start(sha3_start),
        .ready(sha3_ready),
        .we(sha3_we),
        .address(sha3_address),
        .data_in(sha3_data_in),
        .data_out(sha3_data_out_temp)
    );

    generate
`ifdef USE_TOWER_FIELD
        if (GF_BIT == 4) begin
            for (i = 0; i < 64/GF_BIT; i=i+1) begin
                gfaes_to_gft_16 gfaes_to_gft_16_u(sha3_data_out_temp[GF_BIT*i+:GF_BIT], sha3_data_out[GF_BIT*i+:GF_BIT]);
            end
        end else if (GF_BIT == 8) begin
            for (i = 0; i < 64/GF_BIT; i=i+1) begin
                gfaes_to_gft_256 gfaes_to_gft_256_u(sha3_data_out_temp[GF_BIT*i+:GF_BIT], sha3_data_out[GF_BIT*i+:GF_BIT]);
            end
        end
`else 
        assign sha3_data_out = sha3_data_out_temp;
`endif
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ctr <= 0;
        end else begin
            ctr <= (fail) ? ctr + 1 : ctr;
        end
    end
    always @(posedge clk) begin
        sha3_rst_n      <= (op == SHA_HASH_M || op == SHA_HASH_V || op == SHA_HASH_SK) && (proc_counter[3:0] == 0) ? 0 : 1;
        sha3_start      <= (op == SHA_HASH_SK && proc_counter[3:0] == 7) || 
                           (op == SHA_HASH_V  && proc_counter[3:0] == 13) || 
                           (op == SHA_HASH_M  && proc_counter[3:0] == 9) ||
                           (op == SHA_SQUEEZE_SK && proc_counter[3:0] == 0) ||
                           (sha3_state == 2 && sha3_ready && sha3_address == 16 && (sk_cnt_temp+17) != sk_cnt_end) ||
                           (sha3_state == 0 && sha3_ready && sha3_address == 16 && (sig_cnt_temp+17) != sig_word_cnt) ||
                           (sha3_state == 0 && sha3_ready && sha3_address == 16 && (msg_cnt_temp+17) != msg_word_cnt);
        sha3_ASmode     <= (op == SHA_HASH_M || op == SHA_HASH_V || op == SHA_HASH_SK) ? `ASMODE_ABSORB : `ASMODE_SQUEEZE;
        sha3_data_in    <= (op == SHA_HASH_SK && proc_counter[3:0] == 1)  ? secret_key_seed[63:0] :
                           (op == SHA_HASH_SK && proc_counter[3:0] == 2)  ? secret_key_seed[127:64] :
                           (op == SHA_HASH_SK && proc_counter[3:0] == 3)  ? secret_key_seed[191:128] :
                           (op == SHA_HASH_SK && proc_counter[3:0] == 4)  ? secret_key_seed[255:192] :
                           (op == SHA_HASH_SK && proc_counter[3:0] == 5)  ? 64'h1f :
                           (op == SHA_HASH_SK && proc_counter[3:0] == 6)  ? 64'h8000000000000000 :
                           (op == SHA_HASH_V  && proc_counter[3:0] == 1)  ? message_in_r[63:0] : 
                           (op == SHA_HASH_V  && proc_counter[3:0] == 2)  ? message_in_r[127:64] : 
                           (op == SHA_HASH_V  && proc_counter[3:0] == 3)  ? message_in_r[191:128] : 
                           (op == SHA_HASH_V  && proc_counter[3:0] == 4)  ? message_in_r[255:192] : 
                           (op == SHA_HASH_V  && proc_counter[3:0] == 5)  ? salt[63:0] :
                           (op == SHA_HASH_V  && proc_counter[3:0] == 6)  ? salt[127:64] :
                           (op == SHA_HASH_V  && proc_counter[3:0] == 7)  ? secret_key_seed[63:0] :
                           (op == SHA_HASH_V  && proc_counter[3:0] == 8)  ? secret_key_seed[127:64] :
                           (op == SHA_HASH_V  && proc_counter[3:0] == 9)  ? secret_key_seed[191:128] :
                           (op == SHA_HASH_V  && proc_counter[3:0] == 10) ? secret_key_seed[255:192] :
                           (op == SHA_HASH_V  && proc_counter[3:0] == 11) ? {56'h1f, ctr} :
                           (op == SHA_HASH_V  && proc_counter[3:0] == 12) ? 64'h8000000000000000 :
                           (op == SHA_HASH_M  && proc_counter[3:0] == 1)  ? message_in_r[63:0] :
                           (op == SHA_HASH_M  && proc_counter[3:0] == 2)  ? message_in_r[127:64] :
                           (op == SHA_HASH_M  && proc_counter[3:0] == 3)  ? message_in_r[191:128] :
                           (op == SHA_HASH_M  && proc_counter[3:0] == 4)  ? message_in_r[255:192] :
                           (op == SHA_HASH_M  && states == SIGN_STATE && proc_counter[3:0] == 5) ? salt[63:0] :
                           (op == SHA_HASH_M  && states == SIGN_STATE && proc_counter[3:0] == 6) ? salt[127:64] :
                           (op == SHA_HASH_M  && states == VRFY_STATE && proc_counter[3:0] == 5) ? sig_rand_in_r[63:0] :
                           (op == SHA_HASH_M  && states == VRFY_STATE && proc_counter[3:0] == 6) ? sig_rand_in_r[127:64] :
                           (op == SHA_HASH_M  && proc_counter[3:0] == 7)  ? 64'h1f :
                           (op == SHA_HASH_M  && proc_counter[3:0] == 8)  ? 64'h8000000000000000 : 0;                      
        sha3_address    <= (op == SHA_HASH_SK) ? (proc_counter[3:0] == 6  ? 16 : proc_counter-1) : 
                           (op == SHA_HASH_V)  ? (proc_counter[3:0] == 12 ? 16 : proc_counter-1) : 
                           (op == SHA_HASH_M)  ? (proc_counter[3:0] == 8  ? 16 : proc_counter-1) : 
                           (sha3_ready && sha3_state < 3) ? (sha3_address == 16 ? 0 : sha3_address + 1) :
                           0;
        sha3_we         <= ((op == SHA_HASH_SK && proc_counter[3:0] >= 1 && proc_counter[3:0] <= 6) ||
                            (op == SHA_HASH_V  && proc_counter[3:0] >= 1 && proc_counter[3:0] <= 12) || 
                            (op == SHA_HASH_M  && proc_counter[3:0] >= 1 && proc_counter[3:0] <= 8));
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sha3_state <= 3;
        end else begin
            sha3_state <= (sha3_ready && sha3_state == 0 && sig_cnt == sig_word_cnt) ? 3 :  // sha_hash_v
                          (sha3_ready && sha3_state == 1 && msg_cnt == msg_word_cnt) ? 3 :  // sha_hash_m
                          (sha3_ready && sha3_state == 2 && sk_cnt == sk_cnt_end) ? 3 :     // sha_hash_sk
                          (op == SHA_HASH_SK && proc_counter[3:0] == 8)  ? 2 :
                          (op == SHA_HASH_V  && proc_counter[3:0] == 14) ? 0 :
                          (op == SHA_HASH_M  && proc_counter[3:0] == 10) ? 1 :
                          (op == SHA_SQUEEZE_SK && proc_counter[3:0] == 1) ? 2 :
                          sha3_state;
        end
    end


    always @(posedge clk) begin
        for (n = 0; n < msg_word_cnt-1; n=n+1) begin
            msg_buffer[64*n+:64] <= (msg_buffer_idx[n] == n+1) ? msg_buffer[64*n+:64] : msg_buffer[64*(n+1)+:64];
            msg_buffer_idx[n]    <= (msg_buffer_idx[n+1] == 0) ? 0 :
                                    (msg_buffer_idx[n] == n+1) ? msg_buffer_idx[n] : msg_buffer_idx[n+1];
        end
        msg_buffer[64*(msg_word_cnt-1)+:64] <= (msg_buffer_idx[msg_word_cnt-1] == msg_word_cnt) ? msg_buffer[64*(msg_word_cnt-1)+:64] : msg_in;
        msg_buffer_idx[msg_word_cnt-1]      <= (msg_cnt == 0) ? 0 :
                                               (msg_buffer_idx[msg_word_cnt-1] == msg_word_cnt) ? msg_buffer_idx[msg_word_cnt-1] : msg_cnt;
        msg_in                              <= sha3_data_out;
        msg_cnt_temp <= (op == SHA_HASH_M) ? 0 : 
                        (sha3_state == 1 && sha3_ready && sha3_address == 16) ? msg_cnt_temp+17 : msg_cnt_temp;
    end
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            msg_cnt <= 0;
        end else begin
            msg_cnt <= (sha3_state == 1 && sha3_ready && !sha3_start) ? msg_cnt_temp+sha3_address+1 : 
                       (op == SHA_HASH_M) ? 0 : 
                       msg_cnt;
        end
    end

    always @(posedge clk) begin
        for (n = 0; n < sig_word_cnt-1; n=n+1) begin
            sig_buffer[64*n+:64] <= (sig_buffer_idx[n] == n+1) ? sig_buffer[64*n+:64] : sig_buffer[64*(n+1)+:64];
            sig_buffer_idx[n]    <= (sig_buffer_idx[n+1] == 0) ? 0 :
                                    (sig_buffer_idx[n] == n+1) ? sig_buffer_idx[n] : sig_buffer_idx[n+1];
        end
        sig_buffer[64*(sig_word_cnt-1)+:64] <= (sig_buffer_idx[sig_word_cnt-1] == sig_word_cnt) ? sig_buffer[64*(sig_word_cnt-1)+:64] : sig_in;
        sig_buffer_idx[sig_word_cnt-1]      <= (sig_cnt == 0) ? 0 :
                                               (sig_buffer_idx[sig_word_cnt-1] == sig_word_cnt) ? sig_buffer_idx[sig_word_cnt-1] : sig_cnt;
        sig_in                              <= sha3_data_out;
        sig_cnt_temp <= (op == SHA_HASH_V) ? 0 : 
                        (sha3_state == 0 && sha3_ready && sha3_address == 16) ? sig_cnt_temp+17 : sig_cnt_temp;
    end
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sig_cnt <= 0;
        end else begin
            sig_cnt <= (sha3_state == 0 && sha3_ready && !sha3_start) ? sig_cnt_temp+sha3_address+1 : 
                       (op == SHA_HASH_V) ? 0 : 
                       sig_cnt;
        end
    end

    always @(posedge clk) begin
        secret_key_seed <= (op == SHA_HASH_SK && proc_counter[3:0] == 0) ? 256'hbaaaaaadbaaaaaadbaaaaaadbaaaaaadbaaaaaadbaaaaaadbaaaaaadbaaaaaad : secret_key_seed; // TODO
        sk_cnt_end      <= (op == SHA_HASH_SK || op == SHA_SQUEEZE_SK) && proc_counter[3:0] == 0 ? imm[$clog2(BUFFER_DEPTH):0] : sk_cnt_end;
        sk_cnt_temp     <= (op == SHA_HASH_SK || op == SHA_SQUEEZE_SK) ? 0 : 
                           (sha3_state == 2 && sha3_ready && sha3_address == 16) ? sk_cnt_temp+17 : sk_cnt_temp;
    end
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sk_cnt <= 0;
        end else begin
            sk_cnt <= (sha3_ready && sha3_state == 2 && sk_cnt == sk_cnt_end) ? 0 :
                      (sha3_state == 2 && sha3_ready) ? sk_cnt_temp+sha3_address+1 : 
                      (op == SHA_HASH_SK) ? 0 : 
                      sk_cnt;
        end
    end


    // signals for mul_key_sig
    reg [$clog2(V):0] mul_key_sig_current_row;
    reg [$clog2(V):0] mul_key_sig_current_col;
    reg [$clog2(V):0] mul_key_sig_end_row;
    reg [$clog2(V):0] mul_key_sig_end_col;
    reg [IMM_LEN-1:0] mul_key_end_proc_counter;
    reg                mul_key_sig_finish;
    reg [$clog2(O_):0] mul_key_sig_wait_cnt;
    
    wire [$clog2(O_):0] mul_key_sig_wait_cnt_delay3;
    buffering#(
        .SIZE($clog2(O_)+1),
        .DELAY(3)
    ) buffer3_mul_key_sig_wait_cnt (clk, mul_key_sig_wait_cnt, mul_key_sig_wait_cnt_delay3);

    wire [$clog2(O_):0] mul_key_sig_wait_cnt_delay4;
    buffering#(
        .SIZE($clog2(O_)+1),
        .DELAY(4)
    ) buffer1_mul_key_sig_wait_cnt (clk, mul_key_sig_wait_cnt, mul_key_sig_wait_cnt_delay4);
    
    wire mul_key_sig_finish_buffer;
    wire [N*GF_BIT-1:0] data_pipe_mul_key_sig;
    wire [N*GF_BIT-1:0] data_pipe;
    generate
    if (TEST_MODE > 0) begin
        buffering#(
            .SIZE(1),
            .DELAY(3)
        ) adjusted_mul_key_sig_finish (clk, mul_key_sig_finish, mul_key_sig_finish_buffer);
        buffering#(
            .SIZE(N*GF_BIT),
            .DELAY(1)
        ) buffer_current_aes_state4_pipe (clk, data_pipe, data_pipe_mul_key_sig);
    end
    endgenerate
    

    wire [$clog2(RAND_STATE_NUM)-1:0] rand_state_mul_key_sig;
    reg [$clog2(RAND_STATE_NUM)-1:0] rand_state;
    
    buffering#(
        .SIZE($clog2(RAND_STATE_NUM)),
        .DELAY(3)
    ) buffer_mul_key_sig_rand_state (clk, rand_state, rand_state_mul_key_sig);

    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_key_sig_wait_cnt     <= 0;
            mul_key_sig_current_row  <= 0;
            mul_key_sig_current_col  <= 0;
            mul_key_sig_end_row      <= 0;
            mul_key_sig_end_col      <= 0;
            mul_key_sig_finish       <= 0; 
            mul_key_end_proc_counter <= 0; 
        end else begin
            mul_key_sig_wait_cnt     <= (op == MUL_KEY_SIG) ? 
                                        (proc_counter >= mul_key_end_proc_counter ? 0 : ((proc_counter == 0) ? 0 : (mul_key_sig_wait_cnt == (O_-1) ? 0 : mul_key_sig_wait_cnt+1))) : 
                                         mul_key_sig_wait_cnt;
            mul_key_sig_end_row      <= V;
            mul_key_sig_end_col      <= (data_addr1 == Q1) ? V : O;
            mul_key_sig_current_row  <= (proc_counter == 0) ? control_reg[rs1] :
                                        (mul_key_sig_wait_cnt == (O_-1) ? ((mul_key_sig_current_col == mul_key_sig_end_col-1) ? mul_key_sig_current_row + 1 : mul_key_sig_current_row) : 
                                         mul_key_sig_current_row);
            mul_key_sig_current_col  <= (proc_counter == 0) ? control_reg[rs2] :
                                        (mul_key_sig_wait_cnt == (O_-1) ? ((mul_key_sig_current_col == mul_key_sig_end_col-1) ? (data_addr1 == Q2 ? 0 : mul_key_sig_current_row + 1) : mul_key_sig_current_col + 1) : 
                                         mul_key_sig_current_col);
            mul_key_sig_finish       <= (proc_counter == 0) ? 0 : (proc_counter == mul_key_end_proc_counter) || ((mul_key_sig_current_row == mul_key_sig_end_row-1) && (mul_key_sig_current_col == mul_key_sig_end_col-1) && (mul_key_sig_wait_cnt == (O_-1)));
            mul_key_end_proc_counter <= (proc_counter == 0) ? (imm_mul_key*O_) : mul_key_end_proc_counter;
        end
    end 


    /*** Asynchronous buffer ***/ 
    wire [$clog2(N)-1:0] o_mod_n = O & (N-1);
    wire [$clog2(N)-1:0] v_mod_n = V & (N-1);
    reg   [$clog2(BUFFER_DEPTH)-1:0] buffer_counter;
    reg                              read_buffer_end; 
    reg   [$clog2(BUFFER_DEPTH)-1:0] buffer_rdaddress_r;
    wire  [$clog2(BUFFER_DEPTH)-1:0] buffer1_rdaddress = buffer_rdaddress_r + buffer_counter;
    reg   [$clog2(BUFFER_DEPTH)-1:0] buffer1_wraddress;
    reg                              buffer1_wren;
    reg                       [63:0] buffer1_data;
    wire                      [63:0] buffer1_q;
    wire  [$clog2(BUFFER_DEPTH)-1:0] buffer2_rdaddress = buffer_rdaddress_r + buffer_counter;
    reg   [$clog2(BUFFER_DEPTH)-1:0] buffer2_wraddress;
    reg                              buffer2_wren;
    reg                       [63:0] buffer2_data;
    wire                      [63:0] buffer2_q;
    reg                      [255:0] buffer_out;
    wire                [GF_BIT-1:0] buffer_out_GF[0:256/GF_BIT-1];
    wire  [$clog2(BUFFER_DEPTH)-1:0] buffer_rdaddress_to_add;
    generate
        if (O == 44) begin
            assign buffer_rdaddress_to_add = (op == STORE_O) ?                 ((rand_state == RAND_STATE_NUM-1) ? V_   : V_-1) :
                                             (op == SEND || op == MUL_KEY_SIG) ? ((rand_state == 0)                ? O_-1 : O_) :
                                             0;
        end else if (O == 64) begin
            assign buffer_rdaddress_to_add = (op == STORE_O) ?                 V_ :
                                             (op == SEND || op == MUL_KEY_SIG) ? O_ :
                                             0;
        end else if (O == 72) begin
            assign buffer_rdaddress_to_add = (op == STORE_O) ?                 V_ :
                                             (op == SEND || op == MUL_KEY_SIG) ? ((rand_state[0] == 0) ? O_-1 : O_) :
                                             0;
        end else if (O == 96) begin
            assign buffer_rdaddress_to_add = (op == STORE_O) ?                 ((rand_state == RAND_STATE_NUM-1) ? V_   : V_-1) :
                                             (op == SEND || op == MUL_KEY_SIG) ? O_ :
                                             0;
        end
    endgenerate


    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            buffer_rdaddress_r <= 0;
            buffer_counter     <= 0;
            read_buffer_end    <= 0;
        end else begin
            buffer_rdaddress_r <= (op == AES_UPDATE_CTR || op == SHA_SQUEEZE_SK || op == SHA_HASH_SK || (op == MUL_KEY_SIG && proc_counter == 0)) ? 0 :
                                  read_buffer_end || (op == MUL_KEY_SIG && mul_key_sig_wait_cnt == (O_-1)) ? buffer_rdaddress_r+buffer_rdaddress_to_add :           
                                  buffer_rdaddress_r;
            buffer_counter     <= (op == AES_UPDATE_CTR || op == SHA_SQUEEZE_SK || op == SHA_HASH_SK || (op == MUL_KEY_SIG && proc_counter == 0)) ? 0 :
                                  read_buffer_end || (op == MUL_KEY_SIG && mul_key_sig_wait_cnt == (O_-1)) ? 0 : 
                                  ((op == STORE_O || op == MUL_KEY_SIG || op == SEND)) ? buffer_counter + 1 : 
                                  buffer_counter;
            read_buffer_end    <= ((op == STORE_O) && buffer_counter == V_+1) ||
                                  ((op == SEND) && buffer_counter == O_+1) ||
                                  ((op == MUL_KEY_SIG) && mul_key_sig_finish);
        end
    end


    mem #(
        .WIDTH(64),
        .DEPTH(BUFFER_DEPTH)
    ) mem_buffer1 (
        .clock (clk),
        .data (buffer1_data),
        .rdaddress (buffer1_rdaddress),
        .wraddress (buffer1_wraddress),
        .wren (buffer1_wren),
        .q (buffer1_q)
    );
    mem #(
        .WIDTH(64),
        .DEPTH(BUFFER_DEPTH)
    ) mem_buffer2 (
        .clock (clk),
        .data (buffer2_data),
        .rdaddress (buffer2_rdaddress),
        .wraddress (buffer2_wraddress),
        .wren (buffer2_wren),
        .q (buffer2_q)
    );

    wire   [$clog2(BUFFER_DEPTH):0] sk_cnt_minus_1 = sk_cnt-1;
    reg        aes_ready_buffer, aes_ready_buffer_tmp;

    wire [$clog2(BUFFER_DEPTH)-1:0] pk_cnt_for_buffer;
    wire current_aes_state_buffer;

`ifdef USE_PIPELINED_AES   
    buffering#(
        .SIZE($clog2(BUFFER_DEPTH)),
        .DELAY(AES_ROUND+3)
    ) buffer_pk_cnt (clk, pk_cnt, pk_cnt_for_buffer);
    
    buffering#(
        .SIZE(1),
        .DELAY(AES_ROUND+3)
    ) buffer_current_aes_state (clk, current_aes_state, current_aes_state_buffer);
`else
    wire [$clog2(BUFFER_DEPTH)-1:0] pk_cnt_for_buffer_10;
    buffering#(
        .SIZE($clog2(BUFFER_DEPTH)),
        .DELAY(10+3)
    ) buffer_pk_cnt10 (clk, pk_cnt, pk_cnt_for_buffer_10);
    
    wire current_aes_state_buffer_10;
    buffering#(
        .SIZE(1),
        .DELAY(10+3)
    ) buffer_current_aes_state10 (clk, current_aes_state, current_aes_state_buffer_10);

    wire [$clog2(BUFFER_DEPTH)-1:0] pk_cnt_for_buffer_4;
    buffering#(
        .SIZE($clog2(BUFFER_DEPTH)),
        .DELAY(4+3)
    ) buffer_pk_cnt4 (clk, pk_cnt, pk_cnt_for_buffer_4);
    
    wire current_aes_state_buffer_4;
    buffering#(
        .SIZE(1),
        .DELAY(4+3)
    ) buffer_current_aes_state4 (clk, current_aes_state, current_aes_state_buffer_4);
    assign pk_cnt_for_buffer        = (aes_round == 4) ? pk_cnt_for_buffer_4        : pk_cnt_for_buffer_10;
    assign current_aes_state_buffer = (aes_round == 4) ? current_aes_state_buffer_4 : current_aes_state_buffer_10;
`endif

    
    always @(posedge clk) begin
`ifdef USE_PIPELINED_AES
        aes_ready_buffer    <= aes_result_valid;
`else
        aes_ready_buffer_tmp <= aes_ready;
        aes_ready_buffer     <= aes_ready_buffer_tmp;
`endif
        pk_in               <= aes_ctext;
        sk_in               <= sha3_data_out;
        rand_state          <= (op == SHA_HASH_SK || op == SHA_SQUEEZE_SK) ? 0 :
                               (op == AES_UPDATE_CTR) ? imm[$clog2(RAND_STATE_NUM)-1+16:16] :
                               (op == MUL_KEY_SIG && mul_key_sig_wait_cnt == (O_-1)) ? rand_state + 1 :
                               (read_buffer_end) ? rand_state + 1 : rand_state;
        buffer1_wren        <= (current_aes_state_buffer && aes_ready_buffer) || (sk_cnt > 0 && !sk_cnt_minus_1[0]);
        buffer2_wren        <= (current_aes_state_buffer && aes_ready_buffer) || (sk_cnt > 0 && sk_cnt_minus_1[0]);
        buffer1_data        <= (current_aes_state_buffer) ? pk_in[63:0] : sk_in;
        buffer2_data        <= (current_aes_state_buffer) ? pk_in[127:64] : sk_in;
        buffer1_wraddress   <= (current_aes_state_buffer) ? pk_cnt_for_buffer : sk_cnt_minus_1[$clog2(BUFFER_DEPTH):1];
        buffer2_wraddress   <= (current_aes_state_buffer) ? pk_cnt_for_buffer : sk_cnt_minus_1[$clog2(BUFFER_DEPTH):1];
        buffer_out[255:128] <= {buffer2_q, buffer1_q};
        buffer_out[127:0]   <= buffer_out[255:128];
    end
    generate
        for (i = 0; i < 256/GF_BIT; i=i+1) begin
            assign buffer_out_GF[i] = buffer_out[i*GF_BIT+:GF_BIT];
        end
    endgenerate

    wire [$clog2(N)-1:0] which_buffer = (op == MUL_KEY_SIG) ? (o_mod_n*rand_state_mul_key_sig) :
                                        (op == STORE_O) ? (v_mod_n*rand_state) : (o_mod_n*rand_state);
    wire [N-1:0] is_zero_data_pipe;
    generate
        for (i = 0; i < N; i=i+1) begin
            assign is_zero_data_pipe[i] = (op == STORE_O && (buffer_counter == (V_+2)) && i >= v_mod_n && v_mod_n != 0) ||
                                          (op == SEND && (buffer_counter == (O_+2)) && i >= o_mod_n && o_mod_n != 0) ||
                                          (op == MUL_KEY_SIG && mul_key_sig_wait_cnt_delay3 == (O_-1) && i >= o_mod_n && o_mod_n != 0);
            assign data_pipe[i*GF_BIT+:GF_BIT] = (is_zero_data_pipe[i]) ? 0 : buffer_out_GF[i+which_buffer];
        end
    endgenerate
    

    /*** messages ***/
    wire [GF_BIT-1:0] message [0:O_*N-1];
    generate
        for (i = 0; i < O; i=i+1) begin
            assign message[i] = msg_buffer[GF_BIT*i+:GF_BIT]; 
        end
        for (i = O; i < O_*N; i=i+1) begin
            assign message[i] = 0; 
        end
    endgenerate


    /*** signatures ***/
    reg [GF_BIT-1:0] signature     [0:(V_+O_)*N-1];
    reg [GF_BIT-1:0] signature_w   [0:(V_+O_)*N-1];
    wire[GF_BIT-1:0] sig_transform [0:(V_+O_)*N-1];
    reg  [GF_BIT-1:0] aes_to_tower_in[0:N-1];
    reg  [GF_BIT-1:0] tower_to_aes_in[0:N-1];
    wire [GF_BIT-1:0] aes_to_tower_out[0:N-1];
    wire [GF_BIT-1:0] tower_to_aes_out[0:N-1];
    reg  doing_aes_to_tower;
    reg  doing_tower_to_aes;
    reg  [$clog2(V_+O_)-1:0] which_sig;
    reg                [2:0] sig_proc_cnt;
    generate
`ifdef USE_TOWER_FIELD
        if (GF_BIT == 4) begin
            for (i = 0; i < N; i=i+1) begin
                gfaes_to_gft_16 u_gfaes_to_gft_16(aes_to_tower_in[i], aes_to_tower_out[i]);
                gft_to_gfaes_16 u_gft_to_gfaes_16(tower_to_aes_in[i], tower_to_aes_out[i]);
            end
        end else if (GF_BIT == 8) begin
            for (i = 0; i < N; i=i+1) begin
                gfaes_to_gft_256 u_gfaes_to_gft_256(aes_to_tower_in[i], aes_to_tower_out[i]);
                gft_to_gfaes_256 u_gft_to_gfaes_256(tower_to_aes_in[i], tower_to_aes_out[i]);
            end
        end
        always @(posedge clk) begin
            for (n = 0; n < N; n=n+1) begin
                aes_to_tower_in[n] <= signature[which_sig*N+n];
                tower_to_aes_in[n] <= signature[which_sig*N+n];
            end
        end
        always @(posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                doing_aes_to_tower  <= 0;
                doing_tower_to_aes  <= 0;
                which_sig           <= 0;
                sig_proc_cnt        <= 0;
            end else begin
                doing_aes_to_tower  <= (op == AES_TO_TOWER);
                doing_tower_to_aes  <= (op == TOWER_TO_AES);
                which_sig           <= (op == AES_TO_TOWER || op == TOWER_TO_AES) ? control_reg[rs1][$clog2(V_+O_)-1:0] : 
                                        which_sig;
                sig_proc_cnt        <= proc_counter[2:0];
            end
        end
`endif
        for (i = 0; i < V_+O_; i=i+1) begin
            for (j = 0; j < N; j=j+1) begin
`ifdef USE_TOWER_FIELD
                assign sig_transform[i*N+j] = ((which_sig == i && doing_aes_to_tower && sig_proc_cnt == 2) ? aes_to_tower_out[j] :
                                               (which_sig == i && doing_tower_to_aes && sig_proc_cnt == 2) ? tower_to_aes_out[j] :
                                                signature[i*N+j]);
`else 
                assign sig_transform[i*N+j] = signature[i*N+j];
`endif
            end
        end
    endgenerate

    reg sample_v_finish;
    always @(posedge clk) begin
        sample_v_finish <= (sig_cnt == sig_word_cnt && sha3_state == 0);
    end
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (n = 0; n < V; n=n+1)
                signature[n] <= signature_in[n*GF_BIT+:GF_BIT];
            for (n = V; n < V_*N; n=n+1)
                signature[n] <= 0;
            for (n = 0; n < O; n=n+1)
                signature[V_*N+n] <= signature_in[(n+V)*GF_BIT+:GF_BIT];
            for (n = O; n < O_*N; n=n+1)
                signature[V_*N+n] <= 0;
        end else begin
            for (n = 0; n < (V_+O_)*N; n=n+1)
                signature[n] <= signature_w[n];
        end
    end
    always @(*) begin
        for (n = 0; n < V_; n=n+1) begin
            for (m = 0; m < N; m=m+1) begin
                signature_w[n*N+m] = (adjusted_add_to_v_en && (adjusted_control_reg_rs1 == n) 
                                      && adjusted_proc_counter == (N-m)) ? shift_out ^ signature[n*N+m] :
                                      sig_transform[n*N+m];
            end
        end
        for (n = 0; n < O_; n=n+1) begin
            for (m = 1; m < N; m=m+1) begin
`ifdef USE_INVERSION
                signature_w[V_*N+n*N+m] = ((adjusted_store_to_o_en && (adjusted_control_reg_rs1 == n)) ? signature[V_*N+n*N+(m-1)] :
                                           sig_transform[V_*N+n*N+m]);
`else
                signature_w[V_*N+n*N+m] = ((n*N+m >= O) ? 0 :
                                           adjusted_wr_en_data_trans && (adjusted_wr_addr_data-(N*((L/N)*(L/N))) == n*N+m) ? din_data[GF_BIT-1:0] :
                                           sig_transform[V_*N+n*N+m]);
`endif
            end
        end
        for (n = 0; n < O_; n=n+1) begin
            for (m = 0; m < 1; m=m+1) begin
`ifdef USE_INVERSION
                signature_w[V_*N+n*N+m] = ((adjusted_store_to_o_en && (adjusted_control_reg_rs1 == n)) ? shift_out :
                                           sig_transform[V_*N+n*N+m]);
`else
                signature_w[V_*N+n*N+m] =  ((n*N+m >= O) ? 0 :
                                           adjusted_wr_en_data_trans && (adjusted_wr_addr_data-(N*((L/N)*(L/N))) == n*N+m) ? din_data[GF_BIT-1:0] :
                                           sig_transform[V_*N+n*N+m]);
`endif
            end
        end
        if (sample_v_finish) begin
            for (n = 0; n < V; n=n+1) begin
                signature_w[n] = sig_buffer[n*GF_BIT+:GF_BIT];
            end
            for (n = V; n < V_*N; n=n+1) begin
                signature_w[n] = 0;
            end
        end
    end
    
    reg [GF_BIT-1:0] signature_rep1 [0:(V_+O_)*N-1];
    reg [GF_BIT-1:0] signature_rep2 [0:(V_+O_)*N-1];
    reg [GF_BIT-1:0] signature_rep3 [0:(V_+O_)*N-1];
    reg [GF_BIT-1:0] signature_rep4 [0:(V_+O_)*N-1];
    reg [GF_BIT-1:0] signature_rep5 [0:(V_+O_)*N-1];
    always @(posedge clk) begin
        for (n = 0; n < (V_+O_)*N; n=n+1) begin
            signature_rep1[n] <= signature[n];
            signature_rep2[n] <= signature[n];
            signature_rep3[n] <= signature[n];
            signature_rep4[n] <= signature[n];
            signature_rep5[n] <= signature[n];
        end
    end

    reg [127:0] sig_rand_r;
    always @(posedge clk) begin
        sig_rand_r <= salt;
    end


    /*** Matrix processor ***/
    wire [OP_SIZE-1:0] operations;
    reg [13:0] key_addr_r;
    reg       key_en_r;
    reg [3:0] op_insts_r;
    reg [2*N-1:0] gauss_op_in_r;

    matrix_processor #(
        .N(N),
        .GF_BIT(GF_BIT),
        .OP_SIZE(OP_SIZE)
    ) matrix_processor_inst (
        .clk          (clk),
        .rst_n        (rst_n),
        .op_in        (operations),
        .gauss_op_in  (gauss_op_in_r),
        .dataA_in     (dataA_in),
        .dataB_in     (dataB_in),
        .data_out     (SA_dout),
        .dataB_out    (SA_dataB_out),
        .gauss_op_out (SA_op_out),
        .r_A_and      (SA_r_A_and)
    );
   
    wire [$clog2(V):0] eval_start_row [0:BANK-1];
    wire [$clog2(V):0] eval_end_row   [0:BANK-1];
    wire [$clog2(V):0] eval_start_col [0:BANK-1];
    wire [$clog2(V):0] eval_end_col   [0:BANK-1];
    // eval setting start
    assign eval_start_row[0] = (data_addr1 == Q1) ? 0 :
                               (data_addr1 == Q2) ? 0 : 0;
    assign eval_end_row[0]   = (data_addr1 == Q1) ? 7 :
                               (data_addr1 == Q2) ? 13 : 4;
    assign eval_start_col[0] = (data_addr1 == Q1) ? 0 :
                               (data_addr1 == Q2) ? 0 : 0;
    assign eval_end_col[0]   = (data_addr1 == Q1) ? 21 :
                               (data_addr1 == Q2) ? 26 : 31;
    assign eval_start_row[1] = (data_addr1 == Q1) ? 7 :
                               (data_addr1 == Q2) ? 13 : 4;
    assign eval_end_row[1]   = (data_addr1 == Q1) ? 15 :
                               (data_addr1 == Q2) ? 27 : 10;
    assign eval_start_col[1] = (data_addr1 == Q1) ? 22 :
                               (data_addr1 == Q2) ? 27 : 32;
    assign eval_end_col[1]   = (data_addr1 == Q1) ? 39 :
                               (data_addr1 == Q2) ? 9 : 10;
    assign eval_start_row[2] = (data_addr1 == Q1) ? 15 :
                               (data_addr1 == Q2) ? 27 : 10;
    assign eval_end_row[2]   = (data_addr1 == Q1) ? 25 :
                               (data_addr1 == Q2) ? 40 : 16;
    assign eval_start_col[2] = (data_addr1 == Q1) ? 40 :
                               (data_addr1 == Q2) ? 10 : 11;
    assign eval_end_col[2]   = (data_addr1 == Q1) ? 34 :
                               (data_addr1 == Q2) ? 36 : 25;
    assign eval_start_row[3] = (data_addr1 == Q1) ? 25 :
                               (data_addr1 == Q2) ? 40 : 16;
    assign eval_end_row[3]   = (data_addr1 == Q1) ? 37 :
                               (data_addr1 == Q2) ? 54 : 24;
    assign eval_start_col[3] = (data_addr1 == Q1) ? 35 :
                               (data_addr1 == Q2) ? 37 : 26;
    assign eval_end_col[3]   = (data_addr1 == Q1) ? 66 :
                               (data_addr1 == Q2) ? 19 : 35;
    assign eval_start_row[4] = (data_addr1 == Q1) ? 37 :
                               (data_addr1 == Q2) ? 54 : 24;
    assign eval_end_row[4]   = (data_addr1 == Q1) ? 67 :
                               (data_addr1 == Q2) ? 67 : 43;
    assign eval_start_col[4] = (data_addr1 == Q1) ? 67 :
                               (data_addr1 == Q2) ? 20 : 36;
    assign eval_end_col[4]   = (data_addr1 == Q1) ? 67 :
                               (data_addr1 == Q2) ? 43 : 43;
    // eval setting end
    reg [$clog2(V):0] eval_current_row [0:BANK-1];
    reg [$clog2(V):0] eval_current_col [0:BANK-1];
    reg [$clog2(V):0] eval_row;
    reg [$clog2(V):0] eval_col;
    reg eval_finish;
    wire eval_finish_buffer;
    buffering#(
        .SIZE(1),
        .DELAY(4)
    ) adjusted_eval_finish (clk, eval_finish, eval_finish_buffer);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            eval_row         <= 0;
            eval_col         <= 0;
            for (n = 0; n < BANK; n=n+1) begin
                eval_current_row[n] <= 0;
                eval_current_col[n] <= 0;   
            end
            eval_finish <= 0;
        end else begin
            eval_row <= (data_addr1 == Q1) ? V-1 : 
                        (data_addr1 == Q2) ? V-1 : O-1;
            eval_col <= (data_addr1 == Q1) ? V-1 : 
                        (data_addr1 == Q2) ? O-1 : O-1;
            for (n = 0; n < BANK; n=n+1) begin
                eval_current_row[n] <= (proc_counter == 0) ? eval_start_row[n] :
                                       (eval_finish) ? eval_start_row[n] :
                                       (eval_current_col[n] == eval_col) ? (eval_current_row[n] == eval_row ? eval_current_row[n] : eval_current_row[n] + 1) : eval_current_row[n];
                eval_current_col[n] <= (proc_counter == 0) ? eval_start_col[n] :
                                       (eval_finish) ? eval_start_col[n] :
                                       (eval_current_col[n] == eval_col) ? (eval_current_row[n] == eval_row ? eval_current_col[n] : (data_addr1 == Q2 ? 0 : eval_current_row[n] + 1)) :
                                       eval_current_col[n] + 1;
            end
            eval_finish <= (proc_counter == 0) ? 0 :
                           (eval_current_row[0] == eval_end_row[0]) && (eval_current_col[0] == eval_end_col[0]);
        end
    end 

    wire [$clog2(V):0] calc_start_row [0:BANK-1];
    wire [$clog2(V):0] calc_end_row [0:BANK-1];
    // calc setting start
    assign calc_start_row[0] = 0;
    assign calc_end_row[0]   = 13;
    assign calc_start_row[1] = 14;
    assign calc_end_row[1]   = 27;
    assign calc_start_row[2] = 28;
    assign calc_end_row[2]   = 41;
    assign calc_start_row[3] = 42;
    assign calc_end_row[3]   = 55;
    assign calc_start_row[4] = 56;
    assign calc_end_row[4]   = 67;
    // calc setting end
    reg [$clog2(V):0] calc_current_row [0:BANK-1];
    reg [$clog2(V):0] calc_row;
    reg calc_finish;
    wire calc_finish_buffer;
    buffering#(
        .SIZE(1),
        .DELAY(4)
    ) adjusted_calc_finish (clk, calc_finish, calc_finish_buffer);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            calc_row         <= 0;
            for (n = 0; n < BANK; n=n+1) begin
                calc_current_row[n] <= 0;
            end
            calc_finish      <= 0;
        end else begin
            calc_row         <= V-1;
            for (n = 0; n < BANK; n=n+1) begin
                calc_current_row[n] <= (proc_counter == 0) ? calc_start_row[n] :
                                       (calc_finish) ? calc_start_row[n] : 
                                       (calc_current_row[n] == calc_row) ? calc_current_row[n] : calc_current_row[n] + 1;
            end
            // calc row col end
            calc_finish      <= (proc_counter == 0) ? 0 :
                                (calc_current_row[0] == calc_end_row[0]);
        end
    end 

    

    wire [$clog2(V):0] mul_key_row = (proc_counter > control_reg[rs1]) ? control_reg[rs1] : proc_counter;
    wire [$clog2(V):0] mul_key_col = (proc_counter > control_reg[rs1]) ? proc_counter : control_reg[rs1];
    wire [$clog2(V):0] data_row_w = (op == EVAL) ? eval_current_row[0] :
                                    (op == CALC_L) ? calc_current_row[0] :
                                    (op == MUL_KEY_O_PIPE) ? mul_key_row :
                                    (op == MUL_KEY_SIG) ? mul_key_sig_current_row :
                                    control_reg[rs1];
    wire [$clog2(V):0] data_col_w = (op == EVAL) ? eval_current_col[0] :
                                    (op == MUL_KEY_O_PIPE) ? mul_key_col :
                                    (op == MUL_KEY_SIG) ? mul_key_sig_current_col :
                                    control_reg[rs2];
    

    reg [$clog2(V):0] data_row, data_col;
    reg [$clog2(V):0] calc_data_row [0:BANK-1];
    reg [$clog2(V):0] eval_data_row [0:BANK-1];
    reg [$clog2(V):0] eval_data_col [0:BANK-1];
    always @(posedge clk) begin
        data_row <= data_row_w;
        data_col <= data_col_w;
        for (n=0; n < BANK; n=n+1) begin
            calc_data_row[n] <= calc_current_row[n];
            eval_data_row[n] <= eval_current_row[n];
            eval_data_col[n] <= eval_current_col[n];
        end
    end
    
    // address translation
    localparam P1_depth = 470;
    localparam P2_depth = 599;
    localparam P3_depth = 198;
    localparam V_BANK = 14;
    
    wire [$clog2(O*V):0] translation_idx = (TEST_MODE == 0) ? 
                                           ((data_addr1 == Q5) ? (((O+O-(data_row-1))*data_row)>>1) + (data_col-data_row) :
                                            (data_addr1 == F2) ? data_row :
                                            (data_addr1 == Q2) ? (data_row*o_value + data_col) :
                                            (data_addr1 == Q1) ? (((V+V-(data_row-1))*data_row)>>1) + (data_col-data_row) :
                                                                 KEY_BRAM_SIZE-1) : 
                                           (TEST_MODE == 1) ? 
                                           ((data_addr1 == Q5) ? (((O+O-(data_row-1))*data_row)>>1) + (data_col-data_row) :
                                            (data_addr1 == F2 || data_addr1 == Q2) ? data_row :
                                            (data_addr1 == Q1) ? (((V+V-(data_row-1))*data_row)>>1) + (data_col-data_row) :
                                                                 KEY_BRAM_SIZE-1) :
                                           ((data_addr1 == Q5) ? (((O+O-(data_row-1))*data_row)>>1) + (data_col-data_row) :
                                            (data_addr1 == F2 || data_addr1 == Q2) ? data_row :
                                            (data_addr1 == Q1) ? (((V+V-(data_row-1))*data_row)>>1) + (data_col-data_row) :
                                                                 KEY_BRAM_SIZE-1);
    wire [$clog2(O*V):0] translation_depth = (TEST_MODE == 0) ? 
                                           ((data_addr1 == Q5) ? P3_depth :
                                            (data_addr1 == F2) ? V_BANK :
                                            (data_addr1 == Q2) ? P2_depth :
                                            (data_addr1 == Q1) ? P1_depth :
                                                                 1) : 
                                           (TEST_MODE == 1) ? 
                                           ((data_addr1 == Q5) ? P3_depth :
                                            (data_addr1 == F2 || data_addr1 == Q2) ? V_BANK :
                                            (data_addr1 == Q1) ? P1_depth :
                                                                 1) :
                                           ((data_addr1 == Q5) ? P3_depth :
                                            (data_addr1 == F2 || data_addr1 == Q2) ? V_BANK :
                                            (data_addr1 == Q1) ? P1_depth :
                                                                 1);

    reg [KEY_BRAM_DEPTH-1:0] translated_idx;
    reg   [$clog2(BANK)-1:0] translated_bank;
    always@(*) begin
        // address translation start
        if ((translation_idx < translation_depth*(0+1)) && (translation_depth*0 <= translation_idx)) begin
            translated_idx  = translation_idx-translation_depth*0;
            translated_bank = 0;
        end
        else if ((translation_idx < translation_depth*(1+1)) && (translation_depth*1 <= translation_idx)) begin
            translated_idx  = translation_idx-translation_depth*1;
            translated_bank = 1;
        end
        else if ((translation_idx < translation_depth*(2+1)) && (translation_depth*2 <= translation_idx)) begin
            translated_idx  = translation_idx-translation_depth*2;
            translated_bank = 2;
        end
        else if ((translation_idx < translation_depth*(3+1)) && (translation_depth*3 <= translation_idx)) begin
            translated_idx  = translation_idx-translation_depth*3;
            translated_bank = 3;
        end
        else if ((translation_idx < translation_depth*(4+1)) && (translation_depth*4 <= translation_idx)) begin
            translated_idx  = translation_idx-translation_depth*4;
            translated_bank = 4;
        end
        // address translation end
    end

    wire [KEY_BRAM_DEPTH-1:0] key_bram_addr = (TEST_MODE == 0) ? 
                                              ((data_addr1 == Q5) ? translated_idx :
                                               (data_addr1 == F2) ? P3_depth + data_col*translation_depth + translated_idx :
                                               (data_addr1 == Q2) ? P3_depth + V_BANK*O + translated_idx :
                                               (data_addr1 == Q1) ? P3_depth + V_BANK*O + P2_depth + translated_idx :
                                                                    KEY_BRAM_SIZE-1) : 
                                              (TEST_MODE == 1) ? 
                                              ((data_addr1 == Q5) ? translated_idx :
                                               (data_addr1 == F2 || data_addr1 == Q2) ? P3_depth + data_col*translation_depth + translated_idx :
                                               (data_addr1 == Q1) ? P3_depth + V_BANK*O + translated_idx :
                                                                    KEY_BRAM_SIZE-1) :
                                              ((data_addr1 == Q5) ? translated_idx :
                                               (data_addr1 == F2 || data_addr1 == Q2) ? P3_depth + data_col*translation_depth + translated_idx :
                                               (data_addr1 == Q1) ? P3_depth + V_BANK*RAND_STATE_NUM + translated_idx :
                                                                    KEY_BRAM_SIZE-1);
    
    reg [$clog2(BANK)+KEY_BRAM_DEPTH-1:0] key_bram_addr_r;
    always @(posedge clk) begin
        key_bram_addr_r <= {translated_bank, key_bram_addr};
    end


    // calc_l/eval input
    
    reg [$clog2((V_+O_)*N)-1:0] get_row, get_col;
    generate
        always @(*) begin
            get_row = 0;
            get_col = 0;
            case(data_addr1)
                Q5: begin // Q5
                    get_row = V_*N;
                    get_col = V_*N;
                end
                Q2, F2: begin // Q2, F2
                    get_row = 0;
                    get_col = V_*N;
                end
                Q1: begin // Q1, F1
                    get_row = 0;
                    get_col = 0;
                end
            endcase
        end
    endgenerate

    
    wire      [$clog2(V_*N)-1:0] calc_l_index_w[0:BANK-1];
    reg       [$clog2(V_*N)-1:0] calc_l_index_r[0:BANK-1];
    wire [$clog2((V_+O_)*N)-1:0] eval_row_index_w[0:BANK-1];
    wire [$clog2((V_+O_)*N)-1:0] eval_col_index_w[0:BANK-1];
    reg  [$clog2((V_+O_)*N)-1:0] eval_row_index_r[0:BANK-1];
    reg  [$clog2((V_+O_)*N)-1:0] eval_col_index_r[0:BANK-1];
    wire [GF_BIT-1:0] multiplied_signature[0:BANK-1];
    reg [N*GF_BIT-1:0] calc_l_input_r;
    reg [N*GF_BIT-1:0] eval_input_r;
    reg [GF_BIT-1:0] calc_l_input_buffer1[0:BANK-1];
    reg [GF_BIT-1:0] calc_l_input_buffer2[0:BANK-1];
    reg [GF_BIT-1:0] eval_input_buffer1[0:BANK-1];
    reg [GF_BIT-1:0] eval_input_buffer2[0:BANK-1];
    reg [N*GF_BIT-1:0] eval_input_shift;
    generate
        for (i = 0; i < BANK; i=i+1) begin
            assign calc_l_index_w[i]   = calc_data_row[i];
            if (i == 0) begin
                assign eval_row_index_w[i] = (op == EVAL) ? get_row+eval_data_row[i] : get_row+data_row;
                assign eval_col_index_w[i] = (op == EVAL) ? get_col+eval_data_col[i] : get_col+data_col;
            end else begin
                assign eval_row_index_w[i] = get_row+eval_data_row[i];
                assign eval_col_index_w[i] = get_col+eval_data_col[i];
            end
        end
        always @(posedge clk) begin
            for (n = 0; n < BANK; n=n+1) begin
                calc_l_index_r[n]   <= calc_l_index_w[n];
                eval_row_index_r[n] <= eval_row_index_w[n];
                eval_col_index_r[n] <= eval_col_index_w[n];
            end
        end
        
        if (GF_BIT == 4) begin
            for (i = 0; i < BANK; i=i+1) begin
`ifdef USE_TOWER_FIELD
                mul16_Tower u_mul(multiplied_signature[i], signature_rep1[eval_row_index_r[i]], signature_rep2[eval_col_index_r[i]]);
`else
                mul16_AES u_mul(multiplied_signature[i], signature_rep1[eval_row_index_r[i]], signature_rep2[eval_col_index_r[i]]);
`endif
            end
        end else if (GF_BIT == 8) begin
            for (i = 0; i < BANK; i=i+1) begin
`ifdef USE_TOWER_FIELD
                mul256_Tower u_mul(multiplied_signature[i], signature_rep1[eval_row_index_r[i]], signature_rep2[eval_col_index_r[i]]);
`else
                mul256_AES u_mul(multiplied_signature[i], signature_rep1[eval_row_index_r[i]], signature_rep2[eval_col_index_r[i]]);
`endif
            end
        end

        always @(posedge clk) begin
            for (n = 0; n < BANK; n=n+1) begin
                calc_l_input_buffer1[n]   <= signature_rep3[calc_l_index_r[n]];
                calc_l_input_buffer2[n]   <= calc_l_input_buffer1[n];
                eval_input_buffer1[n]     <= multiplied_signature[n];
                eval_input_buffer2[n]     <= eval_input_buffer1[n];
            end
            for (n = 0; n < O_; n=n+1) begin
                for (m = 0; m < BANK; m=m+1) begin
                    calc_l_input_r[(n*BANK+m)*GF_BIT+:GF_BIT] <= (op == CALC_L && proc_counter >= 5) ? calc_l_input_buffer2[m] : 0;
                    eval_input_r[(n*BANK+m)*GF_BIT+:GF_BIT]   <= (op == EVAL && proc_counter >= 5) ? eval_input_buffer2[m] : 0;
                end
            end
            for (n = O_*BANK; n < N; n=n+1) begin
                calc_l_input_r[n*GF_BIT+:GF_BIT] <= 0;
                eval_input_r[n*GF_BIT+:GF_BIT] <= 0;
            end
        end

        if (TEST_MODE > 0) begin
            always @(posedge clk) begin
                if (op == MUL_KEY_SIG && (mul_key_sig_wait_cnt_delay4 == (O_-1) || proc_counter == 4)) begin
                    for (n = 0; n < N; n=n+1) begin
                        if (n == (BANK*(O_-1))) begin
                            eval_input_shift[n*GF_BIT+:GF_BIT] <= multiplied_signature[0];
                        end else begin
                            eval_input_shift[n*GF_BIT+:GF_BIT] <= 0;
                        end
                    end
                end else begin
                    eval_input_shift <= eval_input_shift >> (GF_BIT*BANK);
                end
            end
        end
    endgenerate

    reg   [GF_BIT-1:0] mul_key_o_1;
    reg   [GF_BIT-1:0] mul_key_o_2;
    reg [N*GF_BIT-1:0] mul_key_o_N;
    reg [$clog2(V_*O_*N) - 1 : 0] T_mem_rd_addr_r;
    reg [$clog2(N)-1:0] T_mem_sel;
    always @(posedge clk) begin
        T_mem_sel       <= control_reg[rs3][$clog2(N)-1:0];
        mul_key_o_1     <= T_mem_dout_GF[T_mem_sel];
        mul_key_o_2     <= mul_key_o_1;
        mul_key_o_N     <= {N{mul_key_o_2}};
        T_mem_rd_addr_r <= (control_reg[rs3]>>($clog2(N)))*on_value + control_reg[rs4];
    end

    reg   [GF_BIT-1:0] mul_key_o_1_fast;
    reg   [GF_BIT-1:0] mul_key_o_2_fast;
    reg [N*GF_BIT-1:0] mul_key_o_N_fast;
    reg [$clog2(V_*O_*N) - 1 : 0] T_mem_rd_addr_r_fast;
    wire [$clog2(N)-1:0] T_mem_sel_fast;
    
    wire mul_key_o_skip = (proc_counter == control_reg[rs1]);
    wire mul_key_o_skip_buffer;
    buffering#(
        .SIZE(1),
        .DELAY(3)
    ) mul_key_o_skip_delay (clk, mul_key_o_skip, mul_key_o_skip_buffer);
    
    buffering#(
        .SIZE($clog2(N)),
        .DELAY(2)
    ) mul_key_proc_counter_delay (clk, proc_counter, T_mem_sel_fast);
    
    always @(posedge clk) begin
        mul_key_o_1_fast     <= T_mem_dout_GF[T_mem_sel_fast];
        mul_key_o_2_fast     <= (mul_key_o_skip_buffer) ? 0 : mul_key_o_1_fast;
        mul_key_o_N_fast     <= {N{mul_key_o_2_fast}};
        T_mem_rd_addr_r_fast <= (proc_counter>>($clog2(N)))*on_value + control_reg[rs4];
    end

`ifdef USE_INVERSION
    reg       [$clog2(O_*N)-1:0] mul_l_inv_which_r;
    wire      [$clog2(O_*N)-1:0] mul_l_inv_which = control_reg[rs2][$clog2(O_):0]*N+proc_counter-1;
    wire  [TRANS_BRAM_DEPTH-1:0] mul_l_inv_trans_addr = (O_*O_)*N + (control_reg[rs1][$clog2(O_):0]*on_value + control_reg[rs2][$clog2(O_):0]*n_value);
    reg   [TRANS_BRAM_DEPTH-1:0] mul_l_inv_trans_addr_r;
    always @(posedge clk) begin
        mul_l_inv_which_r      <= mul_l_inv_which;
        mul_l_inv_trans_addr_r <= mul_l_inv_trans_addr;
    end
`endif

    reg  [$clog2(O_*N)-1:0] mul_o_which_r;
    wire [$clog2(O_*N)-1:0] mul_o_which = control_reg[rs2][$clog2(O_):0]*N+proc_counter-1;
    wire  [TRANS_BRAM_DEPTH-1:0] mul_o_trans_addr = (control_reg[rs1][$clog2(V_):0]*on_value + control_reg[rs2][$clog2(O_):0]*n_value);
    reg   [TRANS_BRAM_DEPTH-1:0] mul_o_trans_addr_r;
    always @(posedge clk) begin
        mul_o_which_r      <= mul_o_which;
        mul_o_trans_addr_r <= mul_o_trans_addr;
    end

    reg SA_start_r;
    reg SA_finish_r;
    reg functionA_r;
    
    wire [GF_BIT-1:0] proc_counter_minus_1 = proc_counter - 1;
    wire [GF_BIT-1:0] proc_counter_add_1 = proc_counter + 1;
    
    always @(*) begin
        proc_counter_w           = 0;
        op_finish                = 1;
        rd_addr_data_trans       = 0;
        wr_addr_data             = 0;
        T_mem_din                = 0;
        T_mem_en                 = 0;
        T_mem_wr_addr            = 0;
        T_mem_rd_addr            = 0;
        wr_en_data_trans         = 0;
        dataB_in                 = 0;
        dataA_in                 = 0;
`ifdef USE_INVERSION
        store_to_o_en            = 0;
`endif
        add_to_v_en              = 0;
        key_addr_r               = 0;
        key_en_r                 = 0;
        op_insts_r               = 0;
        SA_start_r               = 0;
        SA_finish_r              = 0;
        functionA_r              = 0;
        gauss_op_in_r            = 0;
        unload_en_w              = 0;
        unload_cnt_w             = 0;
        unload_op_w              = op;
        unload_control_reg_rs1_w = unload_control_reg_rs1;
        unload_set_w             = 0;
        case(op)
            AES_SET_ROUND: begin
                proc_counter_w = (proc_counter[0] == 1) ? 0 : proc_counter + 1;
                op_finish      = (proc_counter[0] == 1) ? 0 : 1;
            end
            AES_UPDATE_CTR: begin
                proc_counter_w = (proc_counter[0] == 1) ? 0 : proc_counter + 1;
                op_finish      = (proc_counter[0] == 1) ? 0 : 1;
            end
            STALL: begin
                proc_counter_w = (proc_counter == imm) ? 0 : proc_counter + 1;
                op_finish      = (proc_counter == imm) ? 0 : 1;
            end
            AES_INIT_KEY: begin
                proc_counter_w = (aes_init_key_finish) ? 0 : proc_counter + 1;
                op_finish      = (aes_init_key_finish) ? 0 : 1;
            end
`ifdef USE_TOWER_FIELD
            AES_TO_TOWER, TOWER_TO_AES: begin
                proc_counter_w = (proc_counter[1:0] == 2) ? 0 : proc_counter + 1;
                op_finish      = (proc_counter[1:0] == 2) ? 0 : 1;
            end
`endif
            AES_SET_CTR: begin
                proc_counter_w = (proc_counter[0] == 1) ? 0 : proc_counter + 1;
                op_finish      = (proc_counter[0] == 1) ? 0 : 1;
            end
            SHA_SQUEEZE_SK: begin
                proc_counter_w = (proc_counter[3:0] == 1) ? 0 : proc_counter + 1;
                op_finish      = (proc_counter[3:0] == 1) ? 0 : 1;
            end
            SHA_HASH_SK: begin
                proc_counter_w = (proc_counter[3:0] == 8) ? 0 : proc_counter + 1;
                op_finish      = (proc_counter[3:0] == 8) ? 0 : 1;
            end
            SHA_HASH_V: begin
                proc_counter_w = (proc_counter[3:0] == 14) ? 0 : proc_counter + 1;
                op_finish      = (proc_counter[3:0] == 14) ? 0 : 1;
            end
            SHA_HASH_M: begin
                proc_counter_w = (proc_counter[3:0] == 10) ? 0 : proc_counter + 1;
                op_finish      = (proc_counter[3:0] == 10) ? 0 : 1;
            end
            STORE_O: begin
                T_mem_wr_addr     = control_reg[rs1] + (buffer_counter-3)*O_*N;
                T_mem_en          = (buffer_counter[$clog2(V_+2)-1:0] > 2);
                T_mem_din         = data_pipe;
                op_finish         = read_buffer_end ? 0 : 1;
            end
            STORE_L, UNLOAD_ADD_Y, UNLOAD_CHECK: begin
                op_insts_r               = 4;
                proc_counter_w           = (proc_counter[$clog2(N+1)-1:0] == N) ? 0 : proc_counter + 1;
                op_finish                = (proc_counter[$clog2(N+1)-1:0] == N) ? 0 : 1;
                unload_en_w              = (unload_set_counter == BANK-1);
                unload_cnt_w             = unload_set_cnt;
                unload_set_w             = (proc_counter[$clog2(N+1)-1:0] == N-(BANK*O_) || unload_set_counter == BANK-1);
                unload_control_reg_rs1_w = control_reg[rs1];
            end
            GAUSS_ELIM: begin // 1
                op_insts_r         = 1;
                op_finish          = gauss_done ? 0 : 1;
                rd_addr_data_trans = rd_addr_data_gauss;
                wr_addr_data       = wr_addr_data_gauss;
                wr_en_data         = 0;
                wr_en_data_trans   = wr_en_data_gauss;
                dataA_in           = SA_din;
                dataB_in           = SA_dataB_in;
                SA_start_r         = SA_start;
                SA_finish_r        = SA_finish;
                functionA_r        = functionA;
                gauss_op_in_r      = SA_op_in;
            end
            STORE_KEYS: begin // 2
                proc_counter_w = (proc_counter[1:0] == 2) ? 0 : proc_counter + 1;
                op_finish      = (proc_counter[1:0] == 2) ? 0 : 1;
                op_insts_r     = 2;
                key_addr_r     = key_bram_addr_r;
                key_en_r       = (proc_counter[1:0] == 2);
            end
            LOAD_KEYS: begin // 3
                proc_counter_w = (proc_counter[2:0] == 5) ? 0 : proc_counter + 1;
                op_finish      = (proc_counter[2:0] == 5) ? 0 : 1;
                op_insts_r     = 3;
                key_addr_r     = key_bram_addr_r;
            end
            MUL_KEY_O_PIPE: begin 
                proc_counter_w = (proc_counter == 5+V-1) ? 0 : proc_counter + 1;
                op_finish      = (proc_counter == 5+V-1) ? 0 : 1;
                T_mem_rd_addr  = T_mem_rd_addr_r_fast;
                op_insts_r     = (proc_counter >= 5) ? 7 : 0;
                dataA_in       = (proc_counter >= 5) ? mul_key_o_N_fast : 0;
                key_addr_r     = key_bram_addr_r;
                gauss_op_in_r  = {N{2'b01}};
            end
            MUL_KEY_O: begin // 4
                T_mem_rd_addr  = T_mem_rd_addr_r;
                op_insts_r     = (proc_counter[2:0] == 5) ? 7 : 0;
                proc_counter_w = (proc_counter[2:0] == 5) ? 0 : proc_counter + 1;
                op_finish      = (proc_counter[2:0] == 5) ? 0 : 1;
                dataA_in       = (proc_counter[2:0] == 5) ? mul_key_o_N : 0;
                key_addr_r     = key_bram_addr_r;
            end
            CALC_L: begin // 4
                proc_counter_w  = (calc_finish_buffer) ? 0 : proc_counter + 1;
                op_finish       = (calc_finish_buffer) ? 0 : 1;
                op_insts_r      = (proc_counter > 5) ? 7 : 0;
                dataA_in        = (proc_counter > 5) ? calc_l_input_r : 0;
                key_addr_r      = key_bram_addr_r;
            end
            EVAL: begin // 4
                proc_counter_w  = (eval_finish_buffer) ? 0 : proc_counter + 1;
                op_finish       = (eval_finish_buffer) ? 0 : 1;
                op_insts_r      = (proc_counter > 5) ? 7 : 0;
                dataA_in        = (proc_counter > 5) ? eval_input_r : 0;
                key_addr_r      = key_bram_addr_r;
            end
            MUL_KEY_SIG: begin // 6, 0 send then mul
                proc_counter_w = (mul_key_sig_finish_buffer) ? 0 : proc_counter + 1;
                op_insts_r     = (proc_counter > 2) ? 6 : 0;
                op_finish      = mul_key_sig_finish_buffer ? 0 : 1;
                dataB_in       = data_pipe_mul_key_sig;
                dataA_in       = (proc_counter > 2) ? eval_input_shift : 0;
            end
            SEND: begin // 5
                op_insts_r           = 5;
                dataB_in             = data_pipe;
                op_finish            = read_buffer_end ? 0 : 1;
            end
`ifdef USE_INVERSION
            STORE_SIG_O: begin
                proc_counter_w     = (proc_counter[$clog2(N+1)-1:0] == N) ? 0 : proc_counter + 1;
                op_finish          = (proc_counter[$clog2(N+1)-1:0] == N) ? 0 : 1;
                store_to_o_en      = proc_counter[$clog2(N+1)-1:0] > 0;
                op_insts_r         = 8;
            end
`endif
            ADD_TO_SIG_V: begin
                proc_counter_w     = (proc_counter[$clog2(N+1)-1:0] == N) ? 0 : proc_counter + 1;
                op_finish          = (proc_counter[$clog2(N+1)-1:0] == N) ? 0 : 1;
                add_to_v_en        = proc_counter[$clog2(N+1)-1:0] > 0;
                op_insts_r         = 8;
            end
`ifdef USE_INVERSION
            MUL_L_INV: begin
                proc_counter_w     = (proc_counter[$clog2(N+2)-1:0] == N+1) ? 0 : proc_counter + 1;
                op_finish          = (proc_counter[$clog2(N+2)-1:0] == N+1) ? 0 : 1;
                rd_addr_data_trans = (proc_counter-1)+mul_l_inv_trans_addr_r; // backward;
                dataA_in           = (proc_counter[$clog2(N+2)-1:0] > 1) ? sig_temp[mul_l_inv_which_r] : 0;
                dataB_in           = (proc_counter[$clog2(N+2)-1:0] > 1) ? dout_data_trans : 0;
                op_insts_r         = 9;
            end
`endif
            MUL_O: begin
                proc_counter_w     = (proc_counter[$clog2(N+2)-1:0] == N+1) ? 0 : proc_counter + 1;
                op_finish          = (proc_counter[$clog2(N+2)-1:0] == N+1) ? 0 : 1;
                T_mem_rd_addr      = (proc_counter-1)+mul_o_trans_addr_r; // backward;
                dataA_in           = (proc_counter[$clog2(N+2)-1:0] > 1) ? signature_rep4[V_*N+mul_o_which_r] : 0;
                dataB_in           = (proc_counter[$clog2(N+2)-1:0] > 1) ? T_mem_dout : 0;
                op_insts_r         = 9;
            end
            FINISH: begin
                op_finish          = 1;
            end
        endcase
    end

    assign program_counter = start_proc ? inst_data_rd_addr : 
                             should_stall ? inst_data_rd_addr - 1 :
                             mispredict ? imm[$clog2(INST_DEPTH)-1:0] : inst_data_rd_addr;

    always @(*) begin
        for (n = 0; n < 16; n=n+1) begin
            control_reg_w[n] = control_reg[n];
        end
        case(op)
            ADDI: control_reg_w[rs2] = control_reg[rs1] + imm;
            SUBI: control_reg_w[rs2] = control_reg[rs1] - imm;
        endcase
    end
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (n = 0; n < 16; n=n+1)
                control_reg[n] <= 0;
        end else begin
            for (n = 0; n < 16; n=n+1) begin
                control_reg[n] <= control_reg_w[n];
            end
        end
    end

    wire [GF_BIT*(O+V)-1:0] signature_combined;
    reg  [GF_BIT*(O+V)-1:0] signature_combined_r;
    generate
        for (i = 0; i < V; i=i+1) begin
            assign signature_combined[i*GF_BIT+:GF_BIT] = signature_rep5[i];
        end
        for (i = 0; i < O; i=i+1) begin
            assign signature_combined[(i+V)*GF_BIT+:GF_BIT] = signature_rep5[V_*N+i];
        end
        always @(posedge clk) begin
            signature_combined_r <= signature_combined;
        end
    endgenerate
    

    wire [GF_BIT-1:0] din_data_GF[0:N-1];
    generate
        for (i = 0; i < N; i=i+1) begin
            assign din_data_GF[i] = din_data[i*GF_BIT+:GF_BIT]; 
        end
    endgenerate
   
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (n = 0; n < O_*N; n=n+1) begin
                sig_temp[n] <= 0;
            end
        end else begin
            for (n = 0; n < O_; n=n+1) begin
                for (m = 0; m < N; m=m+1) begin
                    sig_temp[n*N+m] <= (adjusted_unload_en && adjusted_unload_op == UNLOAD_ADD_Y && adjusted_unload_cnt == n) ? 
                                       unload_accumulator[m] ^ message[n*N+m] : sig_temp[n*N+m];
                end
            end
        end
    end

    reg check_fail;
    wire [N-1:0] the_same;
    wire [$clog2(O_*N)-1:0] check_idx = adjusted_unload_cnt*N;
    generate
        for (i = 0; i < N; i=i+1) begin
            assign the_same[i] = (message[check_idx+i] == unload_accumulator[i]) || ((check_idx+i >= adjusted_unload_control_reg_rs1) && (O % N != 0));
        end
    endgenerate
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            check_fail <= 0;
        end else begin
            check_fail <= (adjusted_unload_en && adjusted_unload_op == UNLOAD_CHECK && states == VRFY_STATE) ? ~(&the_same) : check_fail;
        end
    end


    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            done         <= 0;
            result_out   <= 0;
            sig_rand_out <= 0;
        end else begin
            done         <= (op == FINISH) ? 1 :
                            (states == VRFY_STATE && check_fail) ? 1 : 0;
            result_out   <= states == KEYGEN_STATE ? public_key_seed :
                            states == SIGN_STATE ? signature_combined_r : 
                            states == VRFY_STATE ? check_fail : 
                            result_out;
            sig_rand_out <= sig_rand_r;
        end
    end

    always @(posedge clk) begin
        if (op == GAUSS_ELIM) begin
            gauss_elim_start <= (running_gauss || gauss_done) ? 0 : 1;
        end else begin
            gauss_elim_start <= 0;
        end  
    end
 
    assign operations[13:0] = key_addr_r;
    assign operations[14] = key_en_r;
    assign operations[15] = SA_start_r;
    assign operations[16] = SA_finish_r; 
    assign operations[17] = functionA_r;
    assign operations[21:18] = op_insts_r;



    // always @(posedge clk) begin
    //     if ((states == VRFY_STATE)) begin
    //     $write("\n================================================================================================================\n");
    //     $display("unload_set: %d, adjuster_unload_set: %d, unload_set_counter: %d", unload_set, adjusted_unload_set, unload_set_counter);
    //     $write("unload_accumulator: ");
    //     for (n = 0; n < N; n=n+1) begin
    //         $write("%x ", unload_accumulator[n]);
    //     end
    //     $write("\n");
    //     $display("sig_rand_r: %x", sig_rand_r);
    //     $display("Check %d ", check_fail);
    //     $display("Not the same");
    //     for (n = 0; n < N; n=n+1) begin
    //         $write(" %x", the_same[n]);
    //     end
    //     $write("\n");
    //     $display("keydata: %x, %x, dataB_in: %x, addr: %d, en: %d", matrix_processor_inst.p_1_2.key_data, matrix_processor_inst.p_1_2.key_write_data,
    //                                           matrix_processor_inst.p_1_2.dataB_in, matrix_processor_inst.p_1_2.op_in[KEY_BRAM_DEPTH-1:0], matrix_processor_inst.p_1_2.op_in[KEY_BRAM_DEPTH]);
        
    //     $display("unload, en: %d, cnt: %d, unload_control_rs1: %d, unload_op: %s", 
    //         adjusted_unload_en, adjusted_unload_cnt, adjusted_unload_control_reg_rs1, (adjusted_unload_op == STORE_L) ? "STORE_L" : 
    //                                                                                   (adjusted_unload_op == UNLOAD_CHECK) ? "UNLOAD_CHECK" : 
    //                                                                                   (adjusted_unload_op == UNLOAD_ADD_Y) ? "UNLOAD_ADD_Y" :
    //                                                                                   "others");
    //     $display("for F2_hat, en: %d, trans_bram_data: %x, trans_bram_wraddress: %d", trans_bram_wren, trans_bram_data, trans_bram_wraddress);
    //     $write("transpose_buffer: \n");
    //     for (n = 0; n < O_*N; n=n+1) begin
    //         $write("%x ", transpose_buffer[n]);
    //     end
    //     $write("\n");
    //     $display("tranlation: %d, translation_idx: %d, translated_idx: %d, translated_bank: %d, key_bram_addr: %d, key_addr_r: %d", translation_depth, translation_idx, translated_idx, translated_bank, key_bram_addr, key_addr_r);
    //     $display("data_row: %d, data_col: %d, data_addr1: %d", data_row, data_col, data_addr1);
    //     $display("proc_counter: %d", proc_counter);
    //     $display("mul_key_sig_current_row: %d, mul_key_sig_current_col: %d, mul_key_sig_finish: %d, mul_key_sig_finish_buffer: %d, mul_key_sig_wait_cnt: %d, mul_key_end_proc_counter: %d", mul_key_sig_current_row, mul_key_sig_current_col, mul_key_sig_finish, mul_key_sig_finish_buffer, mul_key_sig_wait_cnt, mul_key_end_proc_counter);
    //     $display("DataA %x, DataB %x, op_inst: %d", dataA_in, dataB_in, op_insts_r);
    //     for (n = 0; n < BANK; n=n+1) begin
    //         $display("bank :%d, (eval_input_buffer1: %x) <= (multiplied_signature: %x = %x * %x), (calc: %x => %x => %x => %x)", n, eval_input_buffer1[n], multiplied_signature[n], signature_rep1[eval_row_index_r[n]], signature_rep2[eval_col_index_r[n]], signature_rep3[calc_l_index_r[n]], calc_l_input_buffer1[n], calc_l_input_buffer2[n], calc_l_input_r[n]);
    //         $display("eval_dinish: %d, eval_row_index_r: %d, eval_col_index_r: %d, calc_l_index_r: %d", eval_finish, eval_row_index_r[n], eval_col_index_r[n], calc_l_index_r[n]);
    //     end
    //     $display("Buffer1, rdaddr: %d, rdq: %x, wraddr: %d, wren: %d, wdata: %x", buffer1_rdaddress, buffer1_q, buffer1_wraddress, buffer1_wren, buffer1_data);
    //     $display("Buffer2, rdaddr: %d, rdq: %x, wraddr: %d, wren: %d, wdata: %x", buffer2_rdaddress, buffer2_q, buffer2_wraddress, buffer2_wren, buffer2_data);
    //     $display("rand_state_mul_key_sig: %d, rand_state: %d, buffer_cnt: %d, buffer_rdaddress_to_add:%d, read_buffer_end: %d", rand_state_mul_key_sig, rand_state, buffer_counter, buffer_rdaddress_to_add, read_buffer_end);
    //     $write("pipe: \n");
    //     for (n = 0; n < N; n=n+1) begin
    //         $write("%x ", data_pipe[n*GF_BIT+:GF_BIT]);
    //     end
    //     $write("\n");
    //     $display("sha3_state: %d", sha3_state);
    //     $display("pk_cnt_end: %d, current_aes_state: %d, pk_cnt: %d", pk_cnt_end, current_aes_state, pk_cnt);
    //     $display("sk_cnt: %d, sk_cnt_temp: %d, sk_cnt_end: %d", sk_cnt, sk_cnt_temp, sk_cnt_end);
    //     $display("transpose: data: %x, rd_en: %d, wr_en: %d, wr_addr: %d, rd_addr: %d", transpose_data, transpose_ren, transpose_wen, transpose_wraddress_w, transpose_rdaddress_w);
    //     $display("trans_bram_data: %x, trans_bram_wren: %d, trans_bram_wraddress: %d, trans_bram_rdaddress: %d", trans_bram_data, trans_bram_wren, trans_bram_wraddress, trans_bram_rdaddress);
    //     $display("gauss: %d %x", gauss_idx, sig_temp[gauss_idx]);
    //     $display("%d %d %d", data_addr1, key_bram_addr, key_bram_addr_r);
    //     $display("test: %d %d", o_mod_n, (o_mod_n < (N>>1)) && (proc_counter >= (O_-1)));
    //     $display("key_bram_addr: %d, rs1: %d, rs2: %d, data_addr1: %d, control_reg[rs1]: %d, control_reg[rs2]: %d", key_bram_addr, rs1, rs2, data_addr1, control_reg[rs1], control_reg[rs2]);
    //     $display("pc: %d, %b", program_counter, inst_data_out);
    //     $display("control reg: %d, (%d %d %d %d %d %d %d %d)", inst_data_rd_addr, control_reg[0],control_reg[1], control_reg[2],control_reg[3] ,control_reg[4],control_reg[5],control_reg[6], control_reg[7]);
    //     $display("control reg2: %d, (%d %d %d %d %d %d %d %d)", inst_data_rd_addr, control_reg[8],control_reg[9], control_reg[10],control_reg[11] ,control_reg[12],control_reg[13],control_reg[14], control_reg[15]);
    //     $display("Op: %s", (op == FINISH) ? "FINISH" :
    //                        (op == BNE) ? "BNE" :
    //                        (op == BEQ) ? "BEQ" :
    //                        (op == BGT) ? "BGT" :
    //                        (op == ADDI) ? "ADDI" :
    //                        (op == SUBI) ? "SUBI" :
    //                        (op == AES_UPDATE_CTR) ? "AES_UPDATE_CTR":
    //                        (op == AES_SET_CTR) ? "AES_SET_CTR" :
    //                        (op == SHA_HASH_V) ? "SHA_HASH_V" :
    //                        (op == SHA_HASH_M) ? "SHA_HASH_M" :
    //                        (op == SHA_HASH_SK) ? "SHA_HASH_SK" :
    //                        (op == SHA_SQUEEZE_SK) ? "SHA_SQUEEZE_SK" :
    //                        (op == AES_INIT_KEY) ? "AES_INIT_KEY" :
    //                        (op == AES_TO_TOWER) ? "AES_TO_TOWER" :
    //                        (op == TOWER_TO_AES) ? "TOWER_TO_AES" :
    //                        (op == STORE_O) ? "STORE_O" :
    //                        (op == SEND) ? "SEND" :
    //                        (op == STALL) ? "STALL" : 
    //                        (op == STORE_KEYS) ? "STORE_KEYS" : 
    //                        (op == LOAD_KEYS) ? "LOAD_KEYS" : 
    //                        (op == MUL_KEY_O) ? "MUL_KEY_O" : 
    //                        (op == EVAL) ? "EVAL" : 
    //                        (op == CALC_L) ? "CALC_L" : 
    //                        (op == MUL_KEY_SIG) ? "MUL_KEY_SIG" : 
    //                        (op == STORE_L) ? "STORE_L" : 
    //                        (op == UNLOAD_CHECK) ? "UNLOAD_CHECK" : 
    //                        (op == ADD_TO_SIG_V) ? "ADD_TO_SIG_V" :
    //                        (op == STORE_SIG_O) ? "STORE_SIG_O" :
    //                        (op == UNLOAD_ADD_Y) ? "UNLOAD_ADD_Y" :
    //                        (op == MUL_L_INV) ? "MUL_L_INV" :
    //                        (op == MUL_O) ? "MUL_O" :
    //                        "others");
    //     $display("AES, init: %1b, next: %1b, ready: %1b, key=%x, block=%x, result=%x", aes_init, aes_next, aes_ready, aes_key, aes_ptext, aes_ctext);
    //     $display("din_dataB: %x, din_data: %x", din_dataB, din_data);
    //     $display("states: %d, proc_counter: %d, imm: %d, mispredict: %d", states, proc_counter, imm, mispredict);
    //     $display("(sha3_rst_n, ASmode, ready, we, address, start, data_in, data_out)=(%d %d %d %d %d %x %x, %x)", sha3_rst_n, sha3_ASmode, sha3_ready, sha3_we, sha3_address, sha3_start, sha3_data_in, sha3_data_out);
    //     $write("(%d, %x)\n", 0, buffer_out[127:0]);
    //     $write("(%d, %x)\n", 0, buffer_out[255:128]);
    //     // for (n = 0; n < 256; n=n+1) begin
    //     //     $write("(%d, %x%x)\n", n, mem_buffer2.mem[n], mem_buffer1.mem[n]);
    //     // end
    //     // $write("\n");
    //     $display("T_mem: %d %d %d %x %x", T_mem_rd_addr, T_mem_wr_addr, T_mem_en, T_mem_din, T_mem_dout);
    //     $display("key_mem: %d %d", key_addr_r, key_en_r);
    //     $display("msg_cnt: %d, msg_word_cnt: %d", msg_cnt, msg_word_cnt);
    //     for (n = 0; n < msg_word_cnt; n=n+1) begin
    //         $write("(%d, %x) ", msg_buffer_idx[n], msg_buffer[64*n+:64]);
    //     end
    //     $write("\n");
    //     $display("sig_cnt: %d, sig_word_cnt: %d, sample_v_finish: %d", sig_cnt, sig_word_cnt, sample_v_finish);
    //     for (n = 0; n < sig_word_cnt; n=n+1) begin
    //         $write("(%d, %x) ", sig_buffer_idx[n], sig_buffer[64*n+:64]);
    //     end
    //     $write("\n");
    //     $write("message: ");
    //     for (n = 0; n < O; n=n+1) begin
    //         $write(" %x", message[n]);
    //     end
    //     $write("\n");
    //     $write("signature: ");
    //     for (n = 0; n < (V_+O_)*N; n=n+1) begin
    //         $write(" %x", signature_w[n]);
    //     end
    //     $write("\n");
    //     $write("sig_temp: ");
    //     for (n = 0; n < (O_)*N; n=n+1) begin
    //         $write(" %x", sig_temp[n]);
    //     end
    //     $write("\n");
    //     $write("[\n");
    //     for (n = 0; n < 8; n=n+1) begin
    //         $write("[");
    //         for (m = 0; m < 3; m=m+1) begin
    //             $write (" 0x%2x,", matrix_processor_inst.p_0_0.r_w[n][m]);
    //         end
    //         for (m = 0; m < 3; m=m+1) begin
    //             $write (" 0x%2x,", matrix_processor_inst.p_0_1.r_w[n][m]);
    //         end
    //         for (m = 0; m < 3; m=m+1) begin
    //             $write (" 0x%2x,", matrix_processor_inst.p_0_2.r_w[n][m]);
    //         end
    //         for (m = 0; m < 3; m=m+1) begin
    //             $write (" 0x%2x,", matrix_processor_inst.p_0_3.r_w[n][m]);
    //         end
    //         for (m = 0; m < 4; m=m+1) begin
    //             $write (" 0x%2x,", matrix_processor_inst.p_0_4.r_w[n][m]);
    //         end
    //         $write("],");
    //         $write("\n");
    //     end
    //     // $display("----------------------------------------------------------------------------");
    //     for (n = 0; n < 8; n=n+1) begin
    //         $write("[");
    //         for (m = 0; m < 3; m=m+1) begin
    //             $write (" 0x%2x,", matrix_processor_inst.p_1_0.r_w[n][m]);
    //         end
    //         for (m = 0; m < 3; m=m+1) begin
    //             $write (" 0x%2x,", matrix_processor_inst.p_1_1.r_w[n][m]);
    //         end
    //         for (m = 0; m < 3; m=m+1) begin
    //             $write (" 0x%2x,", matrix_processor_inst.p_1_2.r_w[n][m]);
    //         end
    //         for (m = 0; m < 3; m=m+1) begin
    //             $write (" 0x%2x,", matrix_processor_inst.p_1_3.r_w[n][m]);
    //         end
    //         for (m = 0; m < 4; m=m+1) begin
    //             $write (" 0x%2x,", matrix_processor_inst.p_1_4.r_w[n][m]);
    //         end
    //         $write("],");
    //         $write("\n");
    //     end
    //     $write("]\n");
    //     end
    // end

endmodule
 
