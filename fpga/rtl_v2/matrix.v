
module bram16Kx4 #(
    parameter WIDTH = 8,
    parameter DEPTH = 1884,
    parameter FILE = "",
    parameter DELAY = 0,
    parameter BANK = 5
)(
    input  wire                                      clock,
    input  wire                      [WIDTH-1:0]      data,
    input  wire [$clog2(DEPTH)+$clog2(BANK)-1:0]   address,
    input  wire                                       wren,
    output wire                 [BANK*WIDTH-1:0]         q
);
    integer i;

    reg                      [WIDTH-1:0] tmp_data;
    reg [$clog2(DEPTH)+$clog2(BANK)-1:0] tmp_address;
    reg [$clog2(DEPTH)+$clog2(BANK)-9:0] tmp_address2;
    reg                     tmp_wren;
    always @(posedge clock) begin
        tmp_data      <= data;
        tmp_address   <= address;
        tmp_address2  <= tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9];
        tmp_wren      <= wren;
        // $display("inside: %d, %d, %d", tmp_data, tmp_address, tmp_wren);
    end 
    
    wire [WIDTH-1:0] q0;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst0 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 0))),
        .q (q0)
    );
        
    wire [WIDTH-1:0] q4;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst4 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 4))),
        .q (q4)
    );
        
    wire [WIDTH-1:0] q8;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst8 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 8))),
        .q (q8)
    );
        
    wire [WIDTH-1:0] q12;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst12 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 12))),
        .q (q12)
    );
        
    wire [WIDTH-1:0] q16;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst16 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 16))),
        .q (q16)
    );
        
    wire [WIDTH-1:0] q1;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst1 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 1))),
        .q (q1)
    );
        
    wire [WIDTH-1:0] q5;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst5 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 5))),
        .q (q5)
    );
        
    wire [WIDTH-1:0] q9;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst9 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 9))),
        .q (q9)
    );
        
    wire [WIDTH-1:0] q13;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst13 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 13))),
        .q (q13)
    );
        
    wire [WIDTH-1:0] q17;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst17 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 17))),
        .q (q17)
    );
        
    wire [WIDTH-1:0] q2;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst2 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 2))),
        .q (q2)
    );
        
    wire [WIDTH-1:0] q6;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst6 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 6))),
        .q (q6)
    );
        
    wire [WIDTH-1:0] q10;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst10 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 10))),
        .q (q10)
    );
        
    wire [WIDTH-1:0] q14;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst14 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 14))),
        .q (q14)
    );
        
    wire [WIDTH-1:0] q18;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst18 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 18))),
        .q (q18)
    );
        
    wire [WIDTH-1:0] q3;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(348),
        .FILE(FILE)
    ) mem_inst3 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 3))),
        .q (q3)
    );
        
    wire [WIDTH-1:0] q7;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(348),
        .FILE(FILE)
    ) mem_inst7 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 7))),
        .q (q7)
    );
        
    wire [WIDTH-1:0] q11;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(348),
        .FILE(FILE)
    ) mem_inst11 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 11))),
        .q (q11)
    );
        
    wire [WIDTH-1:0] q15;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(348),
        .FILE(FILE)
    ) mem_inst15 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 15))),
        .q (q15)
    );
        
    wire [WIDTH-1:0] q19;
    mem #(
        .WIDTH(WIDTH),
        .DEPTH(348),
        .FILE(FILE)
    ) mem_inst19 (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == 19))),
        .q (q19)
    );
        
    reg [BANK*WIDTH-1:0] q_r;
    generate
        if (DELAY == 0) begin
            assign q[0*WIDTH+:WIDTH] = 
                       (tmp_address2 == 0) ? q0 : 
                       (tmp_address2 == 1) ? q1 : 
                       (tmp_address2 == 2) ? q2 : 
                       (tmp_address2 == 3) ? q3 : 
                       (tmp_address2 == 4) ? q4 : 
                       (tmp_address2 == 5) ? q5 : 
                       (tmp_address2 == 6) ? q6 : 
                       (tmp_address2 == 7) ? q7 : 
                       (tmp_address2 == 8) ? q8 : 
                       (tmp_address2 == 9) ? q9 : 
                       (tmp_address2 == 10) ? q10 : 
                       (tmp_address2 == 11) ? q11 : 
                       (tmp_address2 == 12) ? q12 : 
                       (tmp_address2 == 13) ? q13 : 
                       (tmp_address2 == 14) ? q14 : 
                       (tmp_address2 == 15) ? q15 : 
                       (tmp_address2 == 16) ? q16 : 
                       (tmp_address2 == 17) ? q17 : 
                       (tmp_address2 == 18) ? q18 : 
                       (tmp_address2 == 19) ? q19 : 0;
            assign q[1*WIDTH+:WIDTH] = 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 0) ? q4 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 1) ? q5 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 2) ? q6 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 3) ? q7 : 0;
            assign q[2*WIDTH+:WIDTH] = 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 0) ? q8 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 1) ? q9 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 2) ? q10 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 3) ? q11 : 0;
            assign q[3*WIDTH+:WIDTH] = 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 0) ? q12 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 1) ? q13 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 2) ? q14 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 3) ? q15 : 0;
            assign q[4*WIDTH+:WIDTH] = 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 0) ? q16 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 1) ? q17 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 2) ? q18 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 3) ? q19 : 0;
        end else begin
            always @ (posedge clock) begin
                q_r[0*WIDTH+:WIDTH] <=
                       (tmp_address2 == 0) ? q0 : 
                       (tmp_address2 == 1) ? q1 : 
                       (tmp_address2 == 2) ? q2 : 
                       (tmp_address2 == 3) ? q3 : 
                       (tmp_address2 == 4) ? q4 : 
                       (tmp_address2 == 5) ? q5 : 
                       (tmp_address2 == 6) ? q6 : 
                       (tmp_address2 == 7) ? q7 : 
                       (tmp_address2 == 8) ? q8 : 
                       (tmp_address2 == 9) ? q9 : 
                       (tmp_address2 == 10) ? q10 : 
                       (tmp_address2 == 11) ? q11 : 
                       (tmp_address2 == 12) ? q12 : 
                       (tmp_address2 == 13) ? q13 : 
                       (tmp_address2 == 14) ? q14 : 
                       (tmp_address2 == 15) ? q15 : 
                       (tmp_address2 == 16) ? q16 : 
                       (tmp_address2 == 17) ? q17 : 
                       (tmp_address2 == 18) ? q18 : 
                       (tmp_address2 == 19) ? q19 : 0;
            end
            always @ (posedge clock) begin
                q_r[1*WIDTH+:WIDTH] <=
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 0) ? q4 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 1) ? q5 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 2) ? q6 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 3) ? q7 : 0;
            end
            always @ (posedge clock) begin
                q_r[2*WIDTH+:WIDTH] <=
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 0) ? q8 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 1) ? q9 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 2) ? q10 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 3) ? q11 : 0;
            end
            always @ (posedge clock) begin
                q_r[3*WIDTH+:WIDTH] <=
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 0) ? q12 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 1) ? q13 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 2) ? q14 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 3) ? q15 : 0;
            end
            always @ (posedge clock) begin
                q_r[4*WIDTH+:WIDTH] <=
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 0) ? q16 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 1) ? q17 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 2) ? q18 : 
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == 3) ? q19 : 0;
            end
            assign q = q_r;
        end
    endgenerate
endmodule
    
// row = 8, col = 5
module tile_0_0#(
    parameter N = 16,
    parameter GF_BIT = 8,
    parameter OP_SIZE = 22,
    parameter ROW = 8,
    parameter COL = 5
)(
    input wire                      clk,
    input wire                      rst_n,
    input wire        [OP_SIZE-1:0] op_in,        // decide which operations
    input wire     [GF_BIT*COL-1:0] dataA_in,     // for mat_mul, load
    input wire          [2*ROW-1:0] gauss_op_in,  // for gauss
    input wire     [GF_BIT*ROW-1:0] dataB_in,     // for gauss
    input wire     [GF_BIT*COL-1:0] data_in,      // for gauss, store (not used in first row)
    input wire                      start_in, 
    input wire                      finish_in,
    output wire         [2*ROW-1:0] gauss_op_out, // for gauss
    output wire    [GF_BIT*ROW-1:0] dataB_out,    // for gauss
    output wire    [GF_BIT*COL-1:0] data_out,     // for gauss, store
    output reg                      start_out,
    output reg                      finish_out,
    output wire                     r_A_and
);
    
    localparam TILE_ROW_IDX = 0;
    localparam TILE_COL_IDX = 0;
    localparam NUM_PROC_COL = 3;
    localparam BANK = 5; 

    genvar i, j, k;
    integer n, m;

    wire                  start_in_w[0:ROW-1][0:COL-1];
    wire                 start_out_w[0:ROW-1][0:COL-1];
    wire                 finish_in_w[0:ROW-1];
    wire                finish_out_w[0:ROW-1];
    wire         [3:0]  inst_op_in_w[0:ROW-1][0:COL-1];
    wire         [3:0] inst_op_out_w[0:ROW-1][0:COL-1];
    wire         [1:0]       op_in_w[0:ROW-1][0:COL-1];
    wire         [1:0]      op_out_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    dataB_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]   dataB_out_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]           r_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]     data_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    dataA_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]   dataA_out_w[0:ROW-1][0:COL-1];
    reg   [GF_BIT-1:0]     data_in_r[1:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    data_out_w[0:ROW-1][0:COL-1];

    reg [ROW-1 : 1] start_tmp;
    reg [ROW-1 : 1] start_row;
    
    reg [ROW-1 : 1] finish_tmp;
    reg [ROW-1 : 1] finish_row;
    
    reg functionA_dup;
    always @(posedge clk) begin
        functionA_dup <= op_in[17];
    end

    wire [GF_BIT*8*BANK-1:0] key_data;
    wire          [GF_BIT-1:0] key_data_w[0:ROW-1][0:COL-1];
    wire                       key_wren;
    wire      [GF_BIT*ROW-1:0] key_write_data;
    generate
        if (GF_BIT*8 != 0) begin: key_mem
            assign key_wren = op_in[14];
            bram16Kx4 #(
                .WIDTH(GF_BIT*8),
                .DELAY(1)
            ) mem_inst (
                .clock (clk),
                .data (key_write_data),
                .address (op_in[14-1:0]),
                .wren (key_wren),
                .q (key_data)
            );
            for (j = 0; j < ROW; j=j+1) begin
                for (k = 0; k < BANK; k=k+1) begin
                    assign key_data_w[j][k] = (j < 8) ? key_data[(j+k*8)*GF_BIT+:GF_BIT] : 0; // load from
                end
                assign key_write_data[j*GF_BIT+:GF_BIT] = r_w[j][0];                        // write to
            end
        end else begin
            for (j = 0; j < ROW; j=j+1) begin
                for (k = 0; k < BANK; k=k+1) begin
                    assign key_data_w[j][k] = 0; // load from
                end
            end
        end
    endgenerate

    // always@(posedge clk) begin
    //     if ((op_in[OP_SIZE-1:OP_SIZE-4] == 7)) begin
    //         $display("_____________________________________________");
    //         $display("| 0_0, 8, 5");
    //         $display("| dataA_in: %x,  dataB_in: %x, addr: %d, key_data: %x, key_write_data: %x, key_wren: %d", dataA_in, dataB_in, op_in[14-1:0], key_data, key_write_data, key_wren);
    //         $display("|____________________________________________");
    //     end
    // end
        
    // compute_unit(0, 0), (tile(0, 0), unit(0, 0))
                
    assign dataA_in_w[0][0] = dataA_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign data_in_w[0][0] = data_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign op_in_w[0][0] = gauss_op_in[2*0+1:2*0];
    assign inst_op_in_w[0][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[0][0] = dataB_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign start_in_w[0][0] = start_in;
    assign finish_in_w[0] = finish_in;
                    
    processor_ABCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(0),
        .COL_IDX(0),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) AB_proc_0_0 (
        .clk(clk),
        .start_in(start_in_w[0][0]),
        .start_out(start_out_w[0][0]),
        .finish_in(finish_in_w[0]),
        .finish_out(finish_out_w[0]),
        .key_data(key_data_w[0][0]),
        .op_in(inst_op_in_w[0][0]),
        .op_out(inst_op_out_w[0][0]),
        .gauss_op_in(op_in_w[0][0]),
        .gauss_op_out(op_out_w[0][0]),
        .data_in(data_in_w[0][0]),
        .data_out(data_out_w[0][0]),
        .dataB_in(dataB_in_w[0][0]),
        .dataB_out(dataB_out_w[0][0]),
        .dataA_in(dataA_in_w[0][0]),
        .dataA_out(dataA_out_w[0][0]),
        .r(r_w[0][0]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(0, 1), (tile(0, 0), unit(0, 1))
                
    assign dataA_in_w[0][1] = dataA_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign data_in_w[0][1] = data_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign op_in_w[0][1] = op_out_w[0][1-1];
    assign inst_op_in_w[0][1] = inst_op_out_w[0][1-1];
    assign dataB_in_w[0][1] = dataB_out_w[0][1-1];
                    
    assign start_in_w[0][1] = start_out_w[0][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(1),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_0_1 (
        .clk(clk),
        .start_in(start_in_w[0][1]),
        .start_out(start_out_w[0][1]),
        .key_data(key_data_w[0][1]),
        .op_in(inst_op_in_w[0][1]),
        .op_out(inst_op_out_w[0][1]),
        .gauss_op_in(op_in_w[0][1]),
        .gauss_op_out(op_out_w[0][1]),
        .data_in(data_in_w[0][1]),
        .data_out(data_out_w[0][1]),
        .dataB_in(dataB_in_w[0][1]),
        .dataB_out(dataB_out_w[0][1]),
        .dataA_in(dataA_in_w[0][1]),
        .dataA_out(dataA_out_w[0][1]),
        .r(r_w[0][1])
    );
                    
    // compute_unit(0, 2), (tile(0, 0), unit(0, 2))
                
    assign dataA_in_w[0][2] = dataA_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign data_in_w[0][2] = data_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign op_in_w[0][2] = op_out_w[0][2-1];
    assign inst_op_in_w[0][2] = inst_op_out_w[0][2-1];
    assign dataB_in_w[0][2] = dataB_out_w[0][2-1];
                    
    assign start_in_w[0][2] = start_out_w[0][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(2),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_0_2 (
        .clk(clk),
        .start_in(start_in_w[0][2]),
        .start_out(start_out_w[0][2]),
        .key_data(key_data_w[0][2]),
        .op_in(inst_op_in_w[0][2]),
        .op_out(inst_op_out_w[0][2]),
        .gauss_op_in(op_in_w[0][2]),
        .gauss_op_out(op_out_w[0][2]),
        .data_in(data_in_w[0][2]),
        .data_out(data_out_w[0][2]),
        .dataB_in(dataB_in_w[0][2]),
        .dataB_out(dataB_out_w[0][2]),
        .dataA_in(dataA_in_w[0][2]),
        .dataA_out(dataA_out_w[0][2]),
        .r(r_w[0][2])
    );
                    
    // compute_unit(0, 3), (tile(0, 0), unit(0, 3))
                
    assign dataA_in_w[0][3] = dataA_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign data_in_w[0][3] = data_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign op_in_w[0][3] = op_out_w[0][3-1];
    assign inst_op_in_w[0][3] = inst_op_out_w[0][3-1];
    assign dataB_in_w[0][3] = dataB_out_w[0][3-1];
                    
    assign start_in_w[0][3] = start_out_w[0][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(3),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_0_3 (
        .clk(clk),
        .start_in(start_in_w[0][3]),
        .start_out(start_out_w[0][3]),
        .key_data(key_data_w[0][3]),
        .op_in(inst_op_in_w[0][3]),
        .op_out(inst_op_out_w[0][3]),
        .gauss_op_in(op_in_w[0][3]),
        .gauss_op_out(op_out_w[0][3]),
        .data_in(data_in_w[0][3]),
        .data_out(data_out_w[0][3]),
        .dataB_in(dataB_in_w[0][3]),
        .dataB_out(dataB_out_w[0][3]),
        .dataA_in(dataA_in_w[0][3]),
        .dataA_out(dataA_out_w[0][3]),
        .r(r_w[0][3])
    );
                    
    // compute_unit(0, 4), (tile(0, 0), unit(0, 4))
                
    assign dataA_in_w[0][4] = dataA_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign data_in_w[0][4] = data_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign op_in_w[0][4] = op_out_w[0][4-1];
    assign inst_op_in_w[0][4] = inst_op_out_w[0][4-1];
    assign dataB_in_w[0][4] = dataB_out_w[0][4-1];
                    
    assign start_in_w[0][4] = start_out_w[0][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(4),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_0_4 (
        .clk(clk),
        .start_in(start_in_w[0][4]),
        .start_out(start_out_w[0][4]),
        .key_data(key_data_w[0][4]),
        .op_in(inst_op_in_w[0][4]),
        .op_out(inst_op_out_w[0][4]),
        .gauss_op_in(op_in_w[0][4]),
        .gauss_op_out(op_out_w[0][4]),
        .data_in(data_in_w[0][4]),
        .data_out(data_out_w[0][4]),
        .dataB_in(dataB_in_w[0][4]),
        .dataB_out(dataB_out_w[0][4]),
        .dataA_in(dataA_in_w[0][4]),
        .dataA_out(dataA_out_w[0][4]),
        .r(r_w[0][4])
    );
                    
    // compute_unit(1, 0), (tile(0, 0), unit(1, 0))
                
    assign dataA_in_w[1][0] = dataA_out_w[1-1][0];
                    
    assign data_in_w[1][0] = data_out_w[1-1][0];
                    
    assign op_in_w[1][0] = gauss_op_in[2*1+1:2*1];
    assign inst_op_in_w[1][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[1][0] = dataB_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign start_in_w[1][0] = start_row[1];
    assign finish_in_w[1] = finish_row[1];
                    
    always @(posedge clk) begin
        start_tmp[1] <= start_in;
        start_row[1] <= start_tmp[1];
        finish_tmp[1] <= finish_in;
        finish_row[1] <= finish_tmp[1];
    end
                        
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(1),
        .COL_IDX(0),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_1_0 (
        .clk(clk),
        .start_in(start_in_w[1][0]),
        .start_out(start_out_w[1][0]),
        .key_data(key_data_w[1][0]),
        .op_in(inst_op_in_w[1][0]),
        .op_out(inst_op_out_w[1][0]),
        .gauss_op_in(op_in_w[1][0]),
        .gauss_op_out(op_out_w[1][0]),
        .data_in(data_in_w[1][0]),
        .data_out(data_out_w[1][0]),
        .dataB_in(dataB_in_w[1][0]),
        .dataB_out(dataB_out_w[1][0]),
        .dataA_in(dataA_in_w[1][0]),
        .dataA_out(dataA_out_w[1][0]),
        .r(r_w[1][0])
    );
                    
    // compute_unit(1, 1), (tile(0, 0), unit(1, 1))
                
    assign dataA_in_w[1][1] = dataA_out_w[1-1][1];
                    
    assign data_in_w[1][1] = data_out_w[1-1][1];
                    
    assign op_in_w[1][1] = op_out_w[1][1-1];
    assign inst_op_in_w[1][1] = inst_op_out_w[1][1-1];
    assign dataB_in_w[1][1] = dataB_out_w[1][1-1];
                    
    assign start_in_w[1][1] = start_out_w[1][1-1];
                    
    processor_AB #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(1),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) AB_proc_1_1 (
        .clk(clk),
        .start_in(start_in_w[1][1]),
        .start_out(start_out_w[1][1]),
        .finish_in(finish_in_w[1]),
        .finish_out(finish_out_w[1]),
        .key_data(key_data_w[1][1]),
        .op_in(inst_op_in_w[1][1]),
        .op_out(inst_op_out_w[1][1]),
        .gauss_op_in(op_in_w[1][1]),
        .gauss_op_out(op_out_w[1][1]),
        .data_in(data_in_w[1][1]),
        .data_out(data_out_w[1][1]),
        .dataB_in(dataB_in_w[1][1]),
        .dataB_out(dataB_out_w[1][1]),
        .dataA_in(dataA_in_w[1][1]),
        .dataA_out(dataA_out_w[1][1]),
        .r(r_w[1][1]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(1, 2), (tile(0, 0), unit(1, 2))
                
    assign dataA_in_w[1][2] = dataA_out_w[1-1][2];
                    
    assign data_in_w[1][2] = data_out_w[1-1][2];
                    
    assign op_in_w[1][2] = op_out_w[1][2-1];
    assign inst_op_in_w[1][2] = inst_op_out_w[1][2-1];
    assign dataB_in_w[1][2] = dataB_out_w[1][2-1];
                    
    assign start_in_w[1][2] = start_out_w[1][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(2),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_1_2 (
        .clk(clk),
        .start_in(start_in_w[1][2]),
        .start_out(start_out_w[1][2]),
        .key_data(key_data_w[1][2]),
        .op_in(inst_op_in_w[1][2]),
        .op_out(inst_op_out_w[1][2]),
        .gauss_op_in(op_in_w[1][2]),
        .gauss_op_out(op_out_w[1][2]),
        .data_in(data_in_w[1][2]),
        .data_out(data_out_w[1][2]),
        .dataB_in(dataB_in_w[1][2]),
        .dataB_out(dataB_out_w[1][2]),
        .dataA_in(dataA_in_w[1][2]),
        .dataA_out(dataA_out_w[1][2]),
        .r(r_w[1][2])
    );
                    
    // compute_unit(1, 3), (tile(0, 0), unit(1, 3))
                
    assign dataA_in_w[1][3] = dataA_out_w[1-1][3];
                    
    assign data_in_w[1][3] = data_out_w[1-1][3];
                    
    assign op_in_w[1][3] = op_out_w[1][3-1];
    assign inst_op_in_w[1][3] = inst_op_out_w[1][3-1];
    assign dataB_in_w[1][3] = dataB_out_w[1][3-1];
                    
    assign start_in_w[1][3] = start_out_w[1][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(3),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_1_3 (
        .clk(clk),
        .start_in(start_in_w[1][3]),
        .start_out(start_out_w[1][3]),
        .key_data(key_data_w[1][3]),
        .op_in(inst_op_in_w[1][3]),
        .op_out(inst_op_out_w[1][3]),
        .gauss_op_in(op_in_w[1][3]),
        .gauss_op_out(op_out_w[1][3]),
        .data_in(data_in_w[1][3]),
        .data_out(data_out_w[1][3]),
        .dataB_in(dataB_in_w[1][3]),
        .dataB_out(dataB_out_w[1][3]),
        .dataA_in(dataA_in_w[1][3]),
        .dataA_out(dataA_out_w[1][3]),
        .r(r_w[1][3])
    );
                    
    // compute_unit(1, 4), (tile(0, 0), unit(1, 4))
                
    assign dataA_in_w[1][4] = dataA_out_w[1-1][4];
                    
    assign data_in_w[1][4] = data_out_w[1-1][4];
                    
    assign op_in_w[1][4] = op_out_w[1][4-1];
    assign inst_op_in_w[1][4] = inst_op_out_w[1][4-1];
    assign dataB_in_w[1][4] = dataB_out_w[1][4-1];
                    
    assign start_in_w[1][4] = start_out_w[1][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(4),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_1_4 (
        .clk(clk),
        .start_in(start_in_w[1][4]),
        .start_out(start_out_w[1][4]),
        .key_data(key_data_w[1][4]),
        .op_in(inst_op_in_w[1][4]),
        .op_out(inst_op_out_w[1][4]),
        .gauss_op_in(op_in_w[1][4]),
        .gauss_op_out(op_out_w[1][4]),
        .data_in(data_in_w[1][4]),
        .data_out(data_out_w[1][4]),
        .dataB_in(dataB_in_w[1][4]),
        .dataB_out(dataB_out_w[1][4]),
        .dataA_in(dataA_in_w[1][4]),
        .dataA_out(dataA_out_w[1][4]),
        .r(r_w[1][4])
    );
                    
    // compute_unit(2, 0), (tile(0, 0), unit(2, 0))
                
    assign dataA_in_w[2][0] = dataA_out_w[2-1][0];
                    
    assign data_in_w[2][0] = data_out_w[2-1][0];
                    
    assign op_in_w[2][0] = gauss_op_in[2*2+1:2*2];
    assign inst_op_in_w[2][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[2][0] = dataB_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign start_in_w[2][0] = start_row[2];
    assign finish_in_w[2] = finish_row[2];
                    
    always @(posedge clk) begin
        start_tmp[2] <= start_row[2-1];
        start_row[2] <= start_tmp[2];
        finish_tmp[2] <= finish_row[2-1];
        finish_row[2] <= finish_tmp[2];
    end
                        
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(2),
        .COL_IDX(0),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_2_0 (
        .clk(clk),
        .start_in(start_in_w[2][0]),
        .start_out(start_out_w[2][0]),
        .key_data(key_data_w[2][0]),
        .op_in(inst_op_in_w[2][0]),
        .op_out(inst_op_out_w[2][0]),
        .gauss_op_in(op_in_w[2][0]),
        .gauss_op_out(op_out_w[2][0]),
        .data_in(data_in_w[2][0]),
        .data_out(data_out_w[2][0]),
        .dataB_in(dataB_in_w[2][0]),
        .dataB_out(dataB_out_w[2][0]),
        .dataA_in(dataA_in_w[2][0]),
        .dataA_out(dataA_out_w[2][0]),
        .r(r_w[2][0])
    );
                    
    // compute_unit(2, 1), (tile(0, 0), unit(2, 1))
                
    assign dataA_in_w[2][1] = dataA_out_w[2-1][1];
                    
    assign data_in_w[2][1] = data_out_w[2-1][1];
                    
    assign op_in_w[2][1] = op_out_w[2][1-1];
    assign inst_op_in_w[2][1] = inst_op_out_w[2][1-1];
    assign dataB_in_w[2][1] = dataB_out_w[2][1-1];
                    
    assign start_in_w[2][1] = start_out_w[2][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(1),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_2_1 (
        .clk(clk),
        .start_in(start_in_w[2][1]),
        .start_out(start_out_w[2][1]),
        .key_data(key_data_w[2][1]),
        .op_in(inst_op_in_w[2][1]),
        .op_out(inst_op_out_w[2][1]),
        .gauss_op_in(op_in_w[2][1]),
        .gauss_op_out(op_out_w[2][1]),
        .data_in(data_in_w[2][1]),
        .data_out(data_out_w[2][1]),
        .dataB_in(dataB_in_w[2][1]),
        .dataB_out(dataB_out_w[2][1]),
        .dataA_in(dataA_in_w[2][1]),
        .dataA_out(dataA_out_w[2][1]),
        .r(r_w[2][1])
    );
                    
    // compute_unit(2, 2), (tile(0, 0), unit(2, 2))
                
    assign dataA_in_w[2][2] = dataA_out_w[2-1][2];
                    
    assign data_in_w[2][2] = data_out_w[2-1][2];
                    
    assign op_in_w[2][2] = op_out_w[2][2-1];
    assign inst_op_in_w[2][2] = inst_op_out_w[2][2-1];
    assign dataB_in_w[2][2] = dataB_out_w[2][2-1];
                    
    assign start_in_w[2][2] = start_out_w[2][2-1];
                    
    processor_AB #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(2),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) AB_proc_2_2 (
        .clk(clk),
        .start_in(start_in_w[2][2]),
        .start_out(start_out_w[2][2]),
        .finish_in(finish_in_w[2]),
        .finish_out(finish_out_w[2]),
        .key_data(key_data_w[2][2]),
        .op_in(inst_op_in_w[2][2]),
        .op_out(inst_op_out_w[2][2]),
        .gauss_op_in(op_in_w[2][2]),
        .gauss_op_out(op_out_w[2][2]),
        .data_in(data_in_w[2][2]),
        .data_out(data_out_w[2][2]),
        .dataB_in(dataB_in_w[2][2]),
        .dataB_out(dataB_out_w[2][2]),
        .dataA_in(dataA_in_w[2][2]),
        .dataA_out(dataA_out_w[2][2]),
        .r(r_w[2][2]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(2, 3), (tile(0, 0), unit(2, 3))
                
    assign dataA_in_w[2][3] = dataA_out_w[2-1][3];
                    
    assign data_in_w[2][3] = data_out_w[2-1][3];
                    
    assign op_in_w[2][3] = op_out_w[2][3-1];
    assign inst_op_in_w[2][3] = inst_op_out_w[2][3-1];
    assign dataB_in_w[2][3] = dataB_out_w[2][3-1];
                    
    assign start_in_w[2][3] = start_out_w[2][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(3),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_2_3 (
        .clk(clk),
        .start_in(start_in_w[2][3]),
        .start_out(start_out_w[2][3]),
        .key_data(key_data_w[2][3]),
        .op_in(inst_op_in_w[2][3]),
        .op_out(inst_op_out_w[2][3]),
        .gauss_op_in(op_in_w[2][3]),
        .gauss_op_out(op_out_w[2][3]),
        .data_in(data_in_w[2][3]),
        .data_out(data_out_w[2][3]),
        .dataB_in(dataB_in_w[2][3]),
        .dataB_out(dataB_out_w[2][3]),
        .dataA_in(dataA_in_w[2][3]),
        .dataA_out(dataA_out_w[2][3]),
        .r(r_w[2][3])
    );
                    
    // compute_unit(2, 4), (tile(0, 0), unit(2, 4))
                
    assign dataA_in_w[2][4] = dataA_out_w[2-1][4];
                    
    assign data_in_w[2][4] = data_out_w[2-1][4];
                    
    assign op_in_w[2][4] = op_out_w[2][4-1];
    assign inst_op_in_w[2][4] = inst_op_out_w[2][4-1];
    assign dataB_in_w[2][4] = dataB_out_w[2][4-1];
                    
    assign start_in_w[2][4] = start_out_w[2][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(4),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_2_4 (
        .clk(clk),
        .start_in(start_in_w[2][4]),
        .start_out(start_out_w[2][4]),
        .key_data(key_data_w[2][4]),
        .op_in(inst_op_in_w[2][4]),
        .op_out(inst_op_out_w[2][4]),
        .gauss_op_in(op_in_w[2][4]),
        .gauss_op_out(op_out_w[2][4]),
        .data_in(data_in_w[2][4]),
        .data_out(data_out_w[2][4]),
        .dataB_in(dataB_in_w[2][4]),
        .dataB_out(dataB_out_w[2][4]),
        .dataA_in(dataA_in_w[2][4]),
        .dataA_out(dataA_out_w[2][4]),
        .r(r_w[2][4])
    );
                    
    // compute_unit(3, 0), (tile(0, 0), unit(3, 0))
                
    assign dataA_in_w[3][0] = dataA_out_w[3-1][0];
                    
    assign data_in_w[3][0] = data_out_w[3-1][0];
                    
    assign op_in_w[3][0] = gauss_op_in[2*3+1:2*3];
    assign inst_op_in_w[3][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[3][0] = dataB_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign start_in_w[3][0] = start_row[3];
    assign finish_in_w[3] = finish_row[3];
                    
    always @(posedge clk) begin
        start_tmp[3] <= start_row[3-1];
        start_row[3] <= start_tmp[3];
        finish_tmp[3] <= finish_row[3-1];
        finish_row[3] <= finish_tmp[3];
    end
                        
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(3),
        .COL_IDX(0),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_3_0 (
        .clk(clk),
        .start_in(start_in_w[3][0]),
        .start_out(start_out_w[3][0]),
        .key_data(key_data_w[3][0]),
        .op_in(inst_op_in_w[3][0]),
        .op_out(inst_op_out_w[3][0]),
        .gauss_op_in(op_in_w[3][0]),
        .gauss_op_out(op_out_w[3][0]),
        .data_in(data_in_w[3][0]),
        .data_out(data_out_w[3][0]),
        .dataB_in(dataB_in_w[3][0]),
        .dataB_out(dataB_out_w[3][0]),
        .dataA_in(dataA_in_w[3][0]),
        .dataA_out(dataA_out_w[3][0]),
        .r(r_w[3][0])
    );
                    
    // compute_unit(3, 1), (tile(0, 0), unit(3, 1))
                
    assign dataA_in_w[3][1] = dataA_out_w[3-1][1];
                    
    assign data_in_w[3][1] = data_out_w[3-1][1];
                    
    assign op_in_w[3][1] = op_out_w[3][1-1];
    assign inst_op_in_w[3][1] = inst_op_out_w[3][1-1];
    assign dataB_in_w[3][1] = dataB_out_w[3][1-1];
                    
    assign start_in_w[3][1] = start_out_w[3][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(1),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_3_1 (
        .clk(clk),
        .start_in(start_in_w[3][1]),
        .start_out(start_out_w[3][1]),
        .key_data(key_data_w[3][1]),
        .op_in(inst_op_in_w[3][1]),
        .op_out(inst_op_out_w[3][1]),
        .gauss_op_in(op_in_w[3][1]),
        .gauss_op_out(op_out_w[3][1]),
        .data_in(data_in_w[3][1]),
        .data_out(data_out_w[3][1]),
        .dataB_in(dataB_in_w[3][1]),
        .dataB_out(dataB_out_w[3][1]),
        .dataA_in(dataA_in_w[3][1]),
        .dataA_out(dataA_out_w[3][1]),
        .r(r_w[3][1])
    );
                    
    // compute_unit(3, 2), (tile(0, 0), unit(3, 2))
                
    assign dataA_in_w[3][2] = dataA_out_w[3-1][2];
                    
    assign data_in_w[3][2] = data_out_w[3-1][2];
                    
    assign op_in_w[3][2] = op_out_w[3][2-1];
    assign inst_op_in_w[3][2] = inst_op_out_w[3][2-1];
    assign dataB_in_w[3][2] = dataB_out_w[3][2-1];
                    
    assign start_in_w[3][2] = start_out_w[3][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(2),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_3_2 (
        .clk(clk),
        .start_in(start_in_w[3][2]),
        .start_out(start_out_w[3][2]),
        .key_data(key_data_w[3][2]),
        .op_in(inst_op_in_w[3][2]),
        .op_out(inst_op_out_w[3][2]),
        .gauss_op_in(op_in_w[3][2]),
        .gauss_op_out(op_out_w[3][2]),
        .data_in(data_in_w[3][2]),
        .data_out(data_out_w[3][2]),
        .dataB_in(dataB_in_w[3][2]),
        .dataB_out(dataB_out_w[3][2]),
        .dataA_in(dataA_in_w[3][2]),
        .dataA_out(dataA_out_w[3][2]),
        .r(r_w[3][2])
    );
                    
    // compute_unit(3, 3), (tile(0, 0), unit(3, 3))
                
    assign dataA_in_w[3][3] = dataA_out_w[3-1][3];
                    
    assign data_in_w[3][3] = data_out_w[3-1][3];
                    
    assign op_in_w[3][3] = op_out_w[3][3-1];
    assign inst_op_in_w[3][3] = inst_op_out_w[3][3-1];
    assign dataB_in_w[3][3] = dataB_out_w[3][3-1];
                    
    assign start_in_w[3][3] = start_out_w[3][3-1];
                    
    processor_AB #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(3),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) AB_proc_3_3 (
        .clk(clk),
        .start_in(start_in_w[3][3]),
        .start_out(start_out_w[3][3]),
        .finish_in(finish_in_w[3]),
        .finish_out(finish_out_w[3]),
        .key_data(key_data_w[3][3]),
        .op_in(inst_op_in_w[3][3]),
        .op_out(inst_op_out_w[3][3]),
        .gauss_op_in(op_in_w[3][3]),
        .gauss_op_out(op_out_w[3][3]),
        .data_in(data_in_w[3][3]),
        .data_out(data_out_w[3][3]),
        .dataB_in(dataB_in_w[3][3]),
        .dataB_out(dataB_out_w[3][3]),
        .dataA_in(dataA_in_w[3][3]),
        .dataA_out(dataA_out_w[3][3]),
        .r(r_w[3][3]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(3, 4), (tile(0, 0), unit(3, 4))
                
    assign dataA_in_w[3][4] = dataA_out_w[3-1][4];
                    
    assign data_in_w[3][4] = data_out_w[3-1][4];
                    
    assign op_in_w[3][4] = op_out_w[3][4-1];
    assign inst_op_in_w[3][4] = inst_op_out_w[3][4-1];
    assign dataB_in_w[3][4] = dataB_out_w[3][4-1];
                    
    assign start_in_w[3][4] = start_out_w[3][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(4),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_3_4 (
        .clk(clk),
        .start_in(start_in_w[3][4]),
        .start_out(start_out_w[3][4]),
        .key_data(key_data_w[3][4]),
        .op_in(inst_op_in_w[3][4]),
        .op_out(inst_op_out_w[3][4]),
        .gauss_op_in(op_in_w[3][4]),
        .gauss_op_out(op_out_w[3][4]),
        .data_in(data_in_w[3][4]),
        .data_out(data_out_w[3][4]),
        .dataB_in(dataB_in_w[3][4]),
        .dataB_out(dataB_out_w[3][4]),
        .dataA_in(dataA_in_w[3][4]),
        .dataA_out(dataA_out_w[3][4]),
        .r(r_w[3][4])
    );
                    
    // compute_unit(4, 0), (tile(0, 0), unit(4, 0))
                
    assign dataA_in_w[4][0] = dataA_out_w[4-1][0];
                    
    assign data_in_w[4][0] = data_out_w[4-1][0];
                    
    assign op_in_w[4][0] = gauss_op_in[2*4+1:2*4];
    assign inst_op_in_w[4][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[4][0] = dataB_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign start_in_w[4][0] = start_row[4];
    assign finish_in_w[4] = finish_row[4];
                    
    always @(posedge clk) begin
        start_tmp[4] <= start_row[4-1];
        start_row[4] <= start_tmp[4];
        finish_tmp[4] <= finish_row[4-1];
        finish_row[4] <= finish_tmp[4];
    end
                        
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(4),
        .COL_IDX(0),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_4_0 (
        .clk(clk),
        .start_in(start_in_w[4][0]),
        .start_out(start_out_w[4][0]),
        .key_data(key_data_w[4][0]),
        .op_in(inst_op_in_w[4][0]),
        .op_out(inst_op_out_w[4][0]),
        .gauss_op_in(op_in_w[4][0]),
        .gauss_op_out(op_out_w[4][0]),
        .data_in(data_in_w[4][0]),
        .data_out(data_out_w[4][0]),
        .dataB_in(dataB_in_w[4][0]),
        .dataB_out(dataB_out_w[4][0]),
        .dataA_in(dataA_in_w[4][0]),
        .dataA_out(dataA_out_w[4][0]),
        .r(r_w[4][0])
    );
                    
    // compute_unit(4, 1), (tile(0, 0), unit(4, 1))
                
    assign dataA_in_w[4][1] = dataA_out_w[4-1][1];
                    
    assign data_in_w[4][1] = data_out_w[4-1][1];
                    
    assign op_in_w[4][1] = op_out_w[4][1-1];
    assign inst_op_in_w[4][1] = inst_op_out_w[4][1-1];
    assign dataB_in_w[4][1] = dataB_out_w[4][1-1];
                    
    assign start_in_w[4][1] = start_out_w[4][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(1),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_4_1 (
        .clk(clk),
        .start_in(start_in_w[4][1]),
        .start_out(start_out_w[4][1]),
        .key_data(key_data_w[4][1]),
        .op_in(inst_op_in_w[4][1]),
        .op_out(inst_op_out_w[4][1]),
        .gauss_op_in(op_in_w[4][1]),
        .gauss_op_out(op_out_w[4][1]),
        .data_in(data_in_w[4][1]),
        .data_out(data_out_w[4][1]),
        .dataB_in(dataB_in_w[4][1]),
        .dataB_out(dataB_out_w[4][1]),
        .dataA_in(dataA_in_w[4][1]),
        .dataA_out(dataA_out_w[4][1]),
        .r(r_w[4][1])
    );
                    
    // compute_unit(4, 2), (tile(0, 0), unit(4, 2))
                
    assign dataA_in_w[4][2] = dataA_out_w[4-1][2];
                    
    assign data_in_w[4][2] = data_out_w[4-1][2];
                    
    assign op_in_w[4][2] = op_out_w[4][2-1];
    assign inst_op_in_w[4][2] = inst_op_out_w[4][2-1];
    assign dataB_in_w[4][2] = dataB_out_w[4][2-1];
                    
    assign start_in_w[4][2] = start_out_w[4][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(2),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_4_2 (
        .clk(clk),
        .start_in(start_in_w[4][2]),
        .start_out(start_out_w[4][2]),
        .key_data(key_data_w[4][2]),
        .op_in(inst_op_in_w[4][2]),
        .op_out(inst_op_out_w[4][2]),
        .gauss_op_in(op_in_w[4][2]),
        .gauss_op_out(op_out_w[4][2]),
        .data_in(data_in_w[4][2]),
        .data_out(data_out_w[4][2]),
        .dataB_in(dataB_in_w[4][2]),
        .dataB_out(dataB_out_w[4][2]),
        .dataA_in(dataA_in_w[4][2]),
        .dataA_out(dataA_out_w[4][2]),
        .r(r_w[4][2])
    );
                    
    // compute_unit(4, 3), (tile(0, 0), unit(4, 3))
                
    assign dataA_in_w[4][3] = dataA_out_w[4-1][3];
                    
    assign data_in_w[4][3] = data_out_w[4-1][3];
                    
    assign op_in_w[4][3] = op_out_w[4][3-1];
    assign inst_op_in_w[4][3] = inst_op_out_w[4][3-1];
    assign dataB_in_w[4][3] = dataB_out_w[4][3-1];
                    
    assign start_in_w[4][3] = start_out_w[4][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(3),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_4_3 (
        .clk(clk),
        .start_in(start_in_w[4][3]),
        .start_out(start_out_w[4][3]),
        .key_data(key_data_w[4][3]),
        .op_in(inst_op_in_w[4][3]),
        .op_out(inst_op_out_w[4][3]),
        .gauss_op_in(op_in_w[4][3]),
        .gauss_op_out(op_out_w[4][3]),
        .data_in(data_in_w[4][3]),
        .data_out(data_out_w[4][3]),
        .dataB_in(dataB_in_w[4][3]),
        .dataB_out(dataB_out_w[4][3]),
        .dataA_in(dataA_in_w[4][3]),
        .dataA_out(dataA_out_w[4][3]),
        .r(r_w[4][3])
    );
                    
    // compute_unit(4, 4), (tile(0, 0), unit(4, 4))
                
    assign dataA_in_w[4][4] = dataA_out_w[4-1][4];
                    
    assign data_in_w[4][4] = data_out_w[4-1][4];
                    
    assign op_in_w[4][4] = op_out_w[4][4-1];
    assign inst_op_in_w[4][4] = inst_op_out_w[4][4-1];
    assign dataB_in_w[4][4] = dataB_out_w[4][4-1];
                    
    assign start_in_w[4][4] = start_out_w[4][4-1];
                    
    processor_AB #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(4),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) AB_proc_4_4 (
        .clk(clk),
        .start_in(start_in_w[4][4]),
        .start_out(start_out_w[4][4]),
        .finish_in(finish_in_w[4]),
        .finish_out(finish_out_w[4]),
        .key_data(key_data_w[4][4]),
        .op_in(inst_op_in_w[4][4]),
        .op_out(inst_op_out_w[4][4]),
        .gauss_op_in(op_in_w[4][4]),
        .gauss_op_out(op_out_w[4][4]),
        .data_in(data_in_w[4][4]),
        .data_out(data_out_w[4][4]),
        .dataB_in(dataB_in_w[4][4]),
        .dataB_out(dataB_out_w[4][4]),
        .dataA_in(dataA_in_w[4][4]),
        .dataA_out(dataA_out_w[4][4]),
        .r(r_w[4][4]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(5, 0), (tile(0, 0), unit(5, 0))
                
    assign dataA_in_w[5][0] = dataA_out_w[5-1][0];
                    
    assign data_in_w[5][0] = data_out_w[5-1][0];
                    
    assign op_in_w[5][0] = gauss_op_in[2*5+1:2*5];
    assign inst_op_in_w[5][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[5][0] = dataB_in[GF_BIT*5+(GF_BIT-1):GF_BIT*5];
                    
    assign start_in_w[5][0] = start_row[5];
    assign finish_in_w[5] = finish_row[5];
                    
    always @(posedge clk) begin
        start_tmp[5] <= start_row[5-1];
        start_row[5] <= start_tmp[5];
        finish_tmp[5] <= finish_row[5-1];
        finish_row[5] <= finish_tmp[5];
    end
                        
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(5),
        .COL_IDX(0),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_5_0 (
        .clk(clk),
        .start_in(start_in_w[5][0]),
        .start_out(start_out_w[5][0]),
        .key_data(key_data_w[5][0]),
        .op_in(inst_op_in_w[5][0]),
        .op_out(inst_op_out_w[5][0]),
        .gauss_op_in(op_in_w[5][0]),
        .gauss_op_out(op_out_w[5][0]),
        .data_in(data_in_w[5][0]),
        .data_out(data_out_w[5][0]),
        .dataB_in(dataB_in_w[5][0]),
        .dataB_out(dataB_out_w[5][0]),
        .dataA_in(dataA_in_w[5][0]),
        .dataA_out(dataA_out_w[5][0]),
        .r(r_w[5][0])
    );
                    
    // compute_unit(5, 1), (tile(0, 0), unit(5, 1))
                
    assign dataA_in_w[5][1] = dataA_out_w[5-1][1];
                    
    assign data_in_w[5][1] = data_out_w[5-1][1];
                    
    assign op_in_w[5][1] = op_out_w[5][1-1];
    assign inst_op_in_w[5][1] = inst_op_out_w[5][1-1];
    assign dataB_in_w[5][1] = dataB_out_w[5][1-1];
                    
    assign start_in_w[5][1] = start_out_w[5][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(1),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_5_1 (
        .clk(clk),
        .start_in(start_in_w[5][1]),
        .start_out(start_out_w[5][1]),
        .key_data(key_data_w[5][1]),
        .op_in(inst_op_in_w[5][1]),
        .op_out(inst_op_out_w[5][1]),
        .gauss_op_in(op_in_w[5][1]),
        .gauss_op_out(op_out_w[5][1]),
        .data_in(data_in_w[5][1]),
        .data_out(data_out_w[5][1]),
        .dataB_in(dataB_in_w[5][1]),
        .dataB_out(dataB_out_w[5][1]),
        .dataA_in(dataA_in_w[5][1]),
        .dataA_out(dataA_out_w[5][1]),
        .r(r_w[5][1])
    );
                    
    // compute_unit(5, 2), (tile(0, 0), unit(5, 2))
                
    assign dataA_in_w[5][2] = dataA_out_w[5-1][2];
                    
    assign data_in_w[5][2] = data_out_w[5-1][2];
                    
    assign op_in_w[5][2] = op_out_w[5][2-1];
    assign inst_op_in_w[5][2] = inst_op_out_w[5][2-1];
    assign dataB_in_w[5][2] = dataB_out_w[5][2-1];
                    
    assign start_in_w[5][2] = start_out_w[5][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(2),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_5_2 (
        .clk(clk),
        .start_in(start_in_w[5][2]),
        .start_out(start_out_w[5][2]),
        .key_data(key_data_w[5][2]),
        .op_in(inst_op_in_w[5][2]),
        .op_out(inst_op_out_w[5][2]),
        .gauss_op_in(op_in_w[5][2]),
        .gauss_op_out(op_out_w[5][2]),
        .data_in(data_in_w[5][2]),
        .data_out(data_out_w[5][2]),
        .dataB_in(dataB_in_w[5][2]),
        .dataB_out(dataB_out_w[5][2]),
        .dataA_in(dataA_in_w[5][2]),
        .dataA_out(dataA_out_w[5][2]),
        .r(r_w[5][2])
    );
                    
    // compute_unit(5, 3), (tile(0, 0), unit(5, 3))
                
    assign dataA_in_w[5][3] = dataA_out_w[5-1][3];
                    
    assign data_in_w[5][3] = data_out_w[5-1][3];
                    
    assign op_in_w[5][3] = op_out_w[5][3-1];
    assign inst_op_in_w[5][3] = inst_op_out_w[5][3-1];
    assign dataB_in_w[5][3] = dataB_out_w[5][3-1];
                    
    assign start_in_w[5][3] = start_out_w[5][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(3),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_5_3 (
        .clk(clk),
        .start_in(start_in_w[5][3]),
        .start_out(start_out_w[5][3]),
        .key_data(key_data_w[5][3]),
        .op_in(inst_op_in_w[5][3]),
        .op_out(inst_op_out_w[5][3]),
        .gauss_op_in(op_in_w[5][3]),
        .gauss_op_out(op_out_w[5][3]),
        .data_in(data_in_w[5][3]),
        .data_out(data_out_w[5][3]),
        .dataB_in(dataB_in_w[5][3]),
        .dataB_out(dataB_out_w[5][3]),
        .dataA_in(dataA_in_w[5][3]),
        .dataA_out(dataA_out_w[5][3]),
        .r(r_w[5][3])
    );
                    
    // compute_unit(5, 4), (tile(0, 0), unit(5, 4))
                
    assign dataA_in_w[5][4] = dataA_out_w[5-1][4];
                    
    assign data_in_w[5][4] = data_out_w[5-1][4];
                    
    assign op_in_w[5][4] = op_out_w[5][4-1];
    assign inst_op_in_w[5][4] = inst_op_out_w[5][4-1];
    assign dataB_in_w[5][4] = dataB_out_w[5][4-1];
                    
    assign start_in_w[5][4] = start_out_w[5][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(4),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_5_4 (
        .clk(clk),
        .start_in(start_in_w[5][4]),
        .start_out(start_out_w[5][4]),
        .key_data(key_data_w[5][4]),
        .op_in(inst_op_in_w[5][4]),
        .op_out(inst_op_out_w[5][4]),
        .gauss_op_in(op_in_w[5][4]),
        .gauss_op_out(op_out_w[5][4]),
        .data_in(data_in_w[5][4]),
        .data_out(data_out_w[5][4]),
        .dataB_in(dataB_in_w[5][4]),
        .dataB_out(dataB_out_w[5][4]),
        .dataA_in(dataA_in_w[5][4]),
        .dataA_out(dataA_out_w[5][4]),
        .r(r_w[5][4])
    );
                    
    // compute_unit(6, 0), (tile(0, 0), unit(6, 0))
                
    assign dataA_in_w[6][0] = dataA_out_w[6-1][0];
                    
    assign data_in_w[6][0] = data_out_w[6-1][0];
                    
    assign op_in_w[6][0] = gauss_op_in[2*6+1:2*6];
    assign inst_op_in_w[6][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[6][0] = dataB_in[GF_BIT*6+(GF_BIT-1):GF_BIT*6];
                    
    assign start_in_w[6][0] = start_row[6];
    assign finish_in_w[6] = finish_row[6];
                    
    always @(posedge clk) begin
        start_tmp[6] <= start_row[6-1];
        start_row[6] <= start_tmp[6];
        finish_tmp[6] <= finish_row[6-1];
        finish_row[6] <= finish_tmp[6];
    end
                        
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(6),
        .COL_IDX(0),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_6_0 (
        .clk(clk),
        .start_in(start_in_w[6][0]),
        .start_out(start_out_w[6][0]),
        .key_data(key_data_w[6][0]),
        .op_in(inst_op_in_w[6][0]),
        .op_out(inst_op_out_w[6][0]),
        .gauss_op_in(op_in_w[6][0]),
        .gauss_op_out(op_out_w[6][0]),
        .data_in(data_in_w[6][0]),
        .data_out(data_out_w[6][0]),
        .dataB_in(dataB_in_w[6][0]),
        .dataB_out(dataB_out_w[6][0]),
        .dataA_in(dataA_in_w[6][0]),
        .dataA_out(dataA_out_w[6][0]),
        .r(r_w[6][0])
    );
                    
    // compute_unit(6, 1), (tile(0, 0), unit(6, 1))
                
    assign dataA_in_w[6][1] = dataA_out_w[6-1][1];
                    
    assign data_in_w[6][1] = data_out_w[6-1][1];
                    
    assign op_in_w[6][1] = op_out_w[6][1-1];
    assign inst_op_in_w[6][1] = inst_op_out_w[6][1-1];
    assign dataB_in_w[6][1] = dataB_out_w[6][1-1];
                    
    assign start_in_w[6][1] = start_out_w[6][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(1),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_6_1 (
        .clk(clk),
        .start_in(start_in_w[6][1]),
        .start_out(start_out_w[6][1]),
        .key_data(key_data_w[6][1]),
        .op_in(inst_op_in_w[6][1]),
        .op_out(inst_op_out_w[6][1]),
        .gauss_op_in(op_in_w[6][1]),
        .gauss_op_out(op_out_w[6][1]),
        .data_in(data_in_w[6][1]),
        .data_out(data_out_w[6][1]),
        .dataB_in(dataB_in_w[6][1]),
        .dataB_out(dataB_out_w[6][1]),
        .dataA_in(dataA_in_w[6][1]),
        .dataA_out(dataA_out_w[6][1]),
        .r(r_w[6][1])
    );
                    
    // compute_unit(6, 2), (tile(0, 0), unit(6, 2))
                
    assign dataA_in_w[6][2] = dataA_out_w[6-1][2];
                    
    assign data_in_w[6][2] = data_out_w[6-1][2];
                    
    assign op_in_w[6][2] = op_out_w[6][2-1];
    assign inst_op_in_w[6][2] = inst_op_out_w[6][2-1];
    assign dataB_in_w[6][2] = dataB_out_w[6][2-1];
                    
    assign start_in_w[6][2] = start_out_w[6][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(2),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_6_2 (
        .clk(clk),
        .start_in(start_in_w[6][2]),
        .start_out(start_out_w[6][2]),
        .key_data(key_data_w[6][2]),
        .op_in(inst_op_in_w[6][2]),
        .op_out(inst_op_out_w[6][2]),
        .gauss_op_in(op_in_w[6][2]),
        .gauss_op_out(op_out_w[6][2]),
        .data_in(data_in_w[6][2]),
        .data_out(data_out_w[6][2]),
        .dataB_in(dataB_in_w[6][2]),
        .dataB_out(dataB_out_w[6][2]),
        .dataA_in(dataA_in_w[6][2]),
        .dataA_out(dataA_out_w[6][2]),
        .r(r_w[6][2])
    );
                    
    // compute_unit(6, 3), (tile(0, 0), unit(6, 3))
                
    assign dataA_in_w[6][3] = dataA_out_w[6-1][3];
                    
    assign data_in_w[6][3] = data_out_w[6-1][3];
                    
    assign op_in_w[6][3] = op_out_w[6][3-1];
    assign inst_op_in_w[6][3] = inst_op_out_w[6][3-1];
    assign dataB_in_w[6][3] = dataB_out_w[6][3-1];
                    
    assign start_in_w[6][3] = start_out_w[6][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(3),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_6_3 (
        .clk(clk),
        .start_in(start_in_w[6][3]),
        .start_out(start_out_w[6][3]),
        .key_data(key_data_w[6][3]),
        .op_in(inst_op_in_w[6][3]),
        .op_out(inst_op_out_w[6][3]),
        .gauss_op_in(op_in_w[6][3]),
        .gauss_op_out(op_out_w[6][3]),
        .data_in(data_in_w[6][3]),
        .data_out(data_out_w[6][3]),
        .dataB_in(dataB_in_w[6][3]),
        .dataB_out(dataB_out_w[6][3]),
        .dataA_in(dataA_in_w[6][3]),
        .dataA_out(dataA_out_w[6][3]),
        .r(r_w[6][3])
    );
                    
    // compute_unit(6, 4), (tile(0, 0), unit(6, 4))
                
    assign dataA_in_w[6][4] = dataA_out_w[6-1][4];
                    
    assign data_in_w[6][4] = data_out_w[6-1][4];
                    
    assign op_in_w[6][4] = op_out_w[6][4-1];
    assign inst_op_in_w[6][4] = inst_op_out_w[6][4-1];
    assign dataB_in_w[6][4] = dataB_out_w[6][4-1];
                    
    assign start_in_w[6][4] = start_out_w[6][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(4),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_6_4 (
        .clk(clk),
        .start_in(start_in_w[6][4]),
        .start_out(start_out_w[6][4]),
        .key_data(key_data_w[6][4]),
        .op_in(inst_op_in_w[6][4]),
        .op_out(inst_op_out_w[6][4]),
        .gauss_op_in(op_in_w[6][4]),
        .gauss_op_out(op_out_w[6][4]),
        .data_in(data_in_w[6][4]),
        .data_out(data_out_w[6][4]),
        .dataB_in(dataB_in_w[6][4]),
        .dataB_out(dataB_out_w[6][4]),
        .dataA_in(dataA_in_w[6][4]),
        .dataA_out(dataA_out_w[6][4]),
        .r(r_w[6][4])
    );
                    
    // compute_unit(7, 0), (tile(0, 0), unit(7, 0))
                
    assign dataA_in_w[7][0] = dataA_out_w[7-1][0];
                    
    assign data_in_w[7][0] = data_out_w[7-1][0];
                    
    assign op_in_w[7][0] = gauss_op_in[2*7+1:2*7];
    assign inst_op_in_w[7][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[7][0] = dataB_in[GF_BIT*7+(GF_BIT-1):GF_BIT*7];
                    
    assign start_in_w[7][0] = start_row[7];
    assign finish_in_w[7] = finish_row[7];
                    
    always @(posedge clk) begin
        start_tmp[7] <= start_row[7-1];
        start_row[7] <= start_tmp[7];
        finish_tmp[7] <= finish_row[7-1];
        finish_row[7] <= finish_tmp[7];
    end
                        
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(7),
        .COL_IDX(0),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_7_0 (
        .clk(clk),
        .start_in(start_in_w[7][0]),
        .start_out(start_out_w[7][0]),
        .key_data(key_data_w[7][0]),
        .op_in(inst_op_in_w[7][0]),
        .op_out(inst_op_out_w[7][0]),
        .gauss_op_in(op_in_w[7][0]),
        .gauss_op_out(op_out_w[7][0]),
        .data_in(data_in_w[7][0]),
        .data_out(data_out_w[7][0]),
        .dataB_in(dataB_in_w[7][0]),
        .dataB_out(dataB_out_w[7][0]),
        .dataA_in(dataA_in_w[7][0]),
        .dataA_out(dataA_out_w[7][0]),
        .r(r_w[7][0])
    );
                    
    // compute_unit(7, 1), (tile(0, 0), unit(7, 1))
                
    assign dataA_in_w[7][1] = dataA_out_w[7-1][1];
                    
    assign data_in_w[7][1] = data_out_w[7-1][1];
                    
    assign op_in_w[7][1] = op_out_w[7][1-1];
    assign inst_op_in_w[7][1] = inst_op_out_w[7][1-1];
    assign dataB_in_w[7][1] = dataB_out_w[7][1-1];
                    
    assign start_in_w[7][1] = start_out_w[7][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(1),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_7_1 (
        .clk(clk),
        .start_in(start_in_w[7][1]),
        .start_out(start_out_w[7][1]),
        .key_data(key_data_w[7][1]),
        .op_in(inst_op_in_w[7][1]),
        .op_out(inst_op_out_w[7][1]),
        .gauss_op_in(op_in_w[7][1]),
        .gauss_op_out(op_out_w[7][1]),
        .data_in(data_in_w[7][1]),
        .data_out(data_out_w[7][1]),
        .dataB_in(dataB_in_w[7][1]),
        .dataB_out(dataB_out_w[7][1]),
        .dataA_in(dataA_in_w[7][1]),
        .dataA_out(dataA_out_w[7][1]),
        .r(r_w[7][1])
    );
                    
    // compute_unit(7, 2), (tile(0, 0), unit(7, 2))
                
    assign dataA_in_w[7][2] = dataA_out_w[7-1][2];
                    
    assign data_in_w[7][2] = data_out_w[7-1][2];
                    
    assign op_in_w[7][2] = op_out_w[7][2-1];
    assign inst_op_in_w[7][2] = inst_op_out_w[7][2-1];
    assign dataB_in_w[7][2] = dataB_out_w[7][2-1];
                    
    assign start_in_w[7][2] = start_out_w[7][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(2),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_7_2 (
        .clk(clk),
        .start_in(start_in_w[7][2]),
        .start_out(start_out_w[7][2]),
        .key_data(key_data_w[7][2]),
        .op_in(inst_op_in_w[7][2]),
        .op_out(inst_op_out_w[7][2]),
        .gauss_op_in(op_in_w[7][2]),
        .gauss_op_out(op_out_w[7][2]),
        .data_in(data_in_w[7][2]),
        .data_out(data_out_w[7][2]),
        .dataB_in(dataB_in_w[7][2]),
        .dataB_out(dataB_out_w[7][2]),
        .dataA_in(dataA_in_w[7][2]),
        .dataA_out(dataA_out_w[7][2]),
        .r(r_w[7][2])
    );
                    
    // compute_unit(7, 3), (tile(0, 0), unit(7, 3))
                
    assign dataA_in_w[7][3] = dataA_out_w[7-1][3];
                    
    assign data_in_w[7][3] = data_out_w[7-1][3];
                    
    assign op_in_w[7][3] = op_out_w[7][3-1];
    assign inst_op_in_w[7][3] = inst_op_out_w[7][3-1];
    assign dataB_in_w[7][3] = dataB_out_w[7][3-1];
                    
    assign start_in_w[7][3] = start_out_w[7][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(3),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_7_3 (
        .clk(clk),
        .start_in(start_in_w[7][3]),
        .start_out(start_out_w[7][3]),
        .key_data(key_data_w[7][3]),
        .op_in(inst_op_in_w[7][3]),
        .op_out(inst_op_out_w[7][3]),
        .gauss_op_in(op_in_w[7][3]),
        .gauss_op_out(op_out_w[7][3]),
        .data_in(data_in_w[7][3]),
        .data_out(data_out_w[7][3]),
        .dataB_in(dataB_in_w[7][3]),
        .dataB_out(dataB_out_w[7][3]),
        .dataA_in(dataA_in_w[7][3]),
        .dataA_out(dataA_out_w[7][3]),
        .r(r_w[7][3])
    );
                    
    // compute_unit(7, 4), (tile(0, 0), unit(7, 4))
                
    assign dataA_in_w[7][4] = dataA_out_w[7-1][4];
                    
    assign data_in_w[7][4] = data_out_w[7-1][4];
                    
    assign op_in_w[7][4] = op_out_w[7][4-1];
    assign inst_op_in_w[7][4] = inst_op_out_w[7][4-1];
    assign dataB_in_w[7][4] = dataB_out_w[7][4-1];
                    
    assign start_in_w[7][4] = start_out_w[7][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(4),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_7_4 (
        .clk(clk),
        .start_in(start_in_w[7][4]),
        .start_out(start_out_w[7][4]),
        .key_data(key_data_w[7][4]),
        .op_in(inst_op_in_w[7][4]),
        .op_out(inst_op_out_w[7][4]),
        .gauss_op_in(op_in_w[7][4]),
        .gauss_op_out(op_out_w[7][4]),
        .data_in(data_in_w[7][4]),
        .data_out(data_out_w[7][4]),
        .dataB_in(dataB_in_w[7][4]),
        .dataB_out(dataB_out_w[7][4]),
        .dataA_in(dataA_in_w[7][4]),
        .dataA_out(dataA_out_w[7][4]),
        .r(r_w[7][4])
    );
                    
    generate
        for (i = 0; i < COL; i=i+1) begin
            for (j = 0; j < GF_BIT; j=j+1) begin
                assign data_out[i*GF_BIT+j] = data_out_w[ROW-1][i][j];
            end
        end
    endgenerate
        
    generate
        for (i = 0; i < ROW; i=i+1) begin
            assign gauss_op_out[2*i+1:2*i] = op_out_w[i][COL-1];
            assign dataB_out[GF_BIT*i+(GF_BIT-1):GF_BIT*i] = dataB_out_w[i][COL-1];
        end
    endgenerate
        
    wire [5-1:0] is_one;
            
                        assign is_one[0] = (r_w[0][0] == 1); // current_row = 0, current_col = 0
                        
                        assign is_one[1] = (r_w[1][1] == 1); // current_row = 1, current_col = 1
                        
                        assign is_one[2] = (r_w[2][2] == 1); // current_row = 2, current_col = 2
                        
                        assign is_one[3] = (r_w[3][3] == 1); // current_row = 3, current_col = 3
                        
                        assign is_one[4] = (r_w[4][4] == 1); // current_row = 4, current_col = 4
                        
    assign r_A_and = &is_one;
            
    reg start_out_tmp;
    reg finish_out_tmp;
    always @(posedge clk) begin
        start_out_tmp  <= start_row[ROW-1];
        finish_out_tmp <= finish_row[ROW-1];
        start_out      <= start_out_tmp;
        finish_out     <= finish_out_tmp;
    end

endmodule
        
// row = 8, col = 5
module tile_0_1#(
    parameter N = 16,
    parameter GF_BIT = 8,
    parameter OP_SIZE = 22,
    parameter ROW = 8,
    parameter COL = 5
)(
    input wire                      clk,
    input wire                      rst_n,
    input wire        [OP_SIZE-1:0] op_in,        // decide which operations
    input wire     [GF_BIT*COL-1:0] dataA_in,     // for mat_mul, load
    input wire          [2*ROW-1:0] gauss_op_in,  // for gauss
    input wire     [GF_BIT*ROW-1:0] dataB_in,     // for gauss
    input wire     [GF_BIT*COL-1:0] data_in,      // for gauss, store (not used in first row)
    input wire                      start_in, 
    input wire                      finish_in,
    output wire         [2*ROW-1:0] gauss_op_out, // for gauss
    output wire    [GF_BIT*ROW-1:0] dataB_out,    // for gauss
    output wire    [GF_BIT*COL-1:0] data_out,     // for gauss, store
    output reg                      start_out,
    output reg                      finish_out,
    output wire                     r_A_and
);
    
    localparam TILE_ROW_IDX = 0;
    localparam TILE_COL_IDX = 1;
    localparam NUM_PROC_COL = 3;
    localparam BANK = 5; 

    genvar i, j, k;
    integer n, m;

    wire                  start_in_w[0:ROW-1][0:COL-1];
    wire                 start_out_w[0:ROW-1][0:COL-1];
    wire                 finish_in_w[0:ROW-1];
    wire                finish_out_w[0:ROW-1];
    wire         [3:0]  inst_op_in_w[0:ROW-1][0:COL-1];
    wire         [3:0] inst_op_out_w[0:ROW-1][0:COL-1];
    wire         [1:0]       op_in_w[0:ROW-1][0:COL-1];
    wire         [1:0]      op_out_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    dataB_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]   dataB_out_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]           r_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]     data_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    dataA_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]   dataA_out_w[0:ROW-1][0:COL-1];
    reg   [GF_BIT-1:0]     data_in_r[1:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    data_out_w[0:ROW-1][0:COL-1];

    reg [ROW-1 : 1] start_tmp;
    reg [ROW-1 : 1] start_row;
    
    reg [ROW-1 : 1] finish_tmp;
    reg [ROW-1 : 1] finish_row;
    
    reg functionA_dup;
    always @(posedge clk) begin
        functionA_dup <= op_in[17];
    end

    wire [GF_BIT*8*BANK-1:0] key_data;
    wire          [GF_BIT-1:0] key_data_w[0:ROW-1][0:COL-1];
    wire                       key_wren;
    wire      [GF_BIT*ROW-1:0] key_write_data;
    generate
        if (GF_BIT*8 != 0) begin: key_mem
            assign key_wren = op_in[14];
            bram16Kx4 #(
                .WIDTH(GF_BIT*8),
                .DELAY(1)
            ) mem_inst (
                .clock (clk),
                .data (key_write_data),
                .address (op_in[14-1:0]),
                .wren (key_wren),
                .q (key_data)
            );
            for (j = 0; j < ROW; j=j+1) begin
                for (k = 0; k < BANK; k=k+1) begin
                    assign key_data_w[j][k] = (j < 8) ? key_data[(j+k*8)*GF_BIT+:GF_BIT] : 0; // load from
                end
                assign key_write_data[j*GF_BIT+:GF_BIT] = r_w[j][0];                        // write to
            end
        end else begin
            for (j = 0; j < ROW; j=j+1) begin
                for (k = 0; k < BANK; k=k+1) begin
                    assign key_data_w[j][k] = 0; // load from
                end
            end
        end
    endgenerate

    // always@(posedge clk) begin
    //     if ((op_in[OP_SIZE-1:OP_SIZE-4] == 7)) begin
    //         $display("_____________________________________________");
    //         $display("| 0_1, 8, 5");
    //         $display("| dataA_in: %x,  dataB_in: %x, addr: %d, key_data: %x, key_write_data: %x, key_wren: %d", dataA_in, dataB_in, op_in[14-1:0], key_data, key_write_data, key_wren);
    //         $display("|____________________________________________");
    //     end
    // end
        
    // compute_unit(0, 5), (tile(0, 1), unit(0, 0))
                
    assign dataA_in_w[0][0] = dataA_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign data_in_w[0][0] = data_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign op_in_w[0][0] = gauss_op_in[2*0+1:2*0];
    assign inst_op_in_w[0][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[0][0] = dataB_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign start_in_w[0][0] = start_in;
    assign finish_in_w[0] = finish_in;
                    
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(5),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_0_0 (
        .clk(clk),
        .start_in(start_in_w[0][0]),
        .start_out(start_out_w[0][0]),
        .key_data(key_data_w[0][0]),
        .op_in(inst_op_in_w[0][0]),
        .op_out(inst_op_out_w[0][0]),
        .gauss_op_in(op_in_w[0][0]),
        .gauss_op_out(op_out_w[0][0]),
        .data_in(data_in_w[0][0]),
        .data_out(data_out_w[0][0]),
        .dataB_in(dataB_in_w[0][0]),
        .dataB_out(dataB_out_w[0][0]),
        .dataA_in(dataA_in_w[0][0]),
        .dataA_out(dataA_out_w[0][0]),
        .r(r_w[0][0])
    );
                    
    // compute_unit(0, 6), (tile(0, 1), unit(0, 1))
                
    assign dataA_in_w[0][1] = dataA_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign data_in_w[0][1] = data_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign op_in_w[0][1] = op_out_w[0][1-1];
    assign inst_op_in_w[0][1] = inst_op_out_w[0][1-1];
    assign dataB_in_w[0][1] = dataB_out_w[0][1-1];
                    
    assign start_in_w[0][1] = start_out_w[0][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(6),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_0_1 (
        .clk(clk),
        .start_in(start_in_w[0][1]),
        .start_out(start_out_w[0][1]),
        .key_data(key_data_w[0][1]),
        .op_in(inst_op_in_w[0][1]),
        .op_out(inst_op_out_w[0][1]),
        .gauss_op_in(op_in_w[0][1]),
        .gauss_op_out(op_out_w[0][1]),
        .data_in(data_in_w[0][1]),
        .data_out(data_out_w[0][1]),
        .dataB_in(dataB_in_w[0][1]),
        .dataB_out(dataB_out_w[0][1]),
        .dataA_in(dataA_in_w[0][1]),
        .dataA_out(dataA_out_w[0][1]),
        .r(r_w[0][1])
    );
                    
    // compute_unit(0, 7), (tile(0, 1), unit(0, 2))
                
    assign dataA_in_w[0][2] = dataA_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign data_in_w[0][2] = data_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign op_in_w[0][2] = op_out_w[0][2-1];
    assign inst_op_in_w[0][2] = inst_op_out_w[0][2-1];
    assign dataB_in_w[0][2] = dataB_out_w[0][2-1];
                    
    assign start_in_w[0][2] = start_out_w[0][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(7),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_0_2 (
        .clk(clk),
        .start_in(start_in_w[0][2]),
        .start_out(start_out_w[0][2]),
        .key_data(key_data_w[0][2]),
        .op_in(inst_op_in_w[0][2]),
        .op_out(inst_op_out_w[0][2]),
        .gauss_op_in(op_in_w[0][2]),
        .gauss_op_out(op_out_w[0][2]),
        .data_in(data_in_w[0][2]),
        .data_out(data_out_w[0][2]),
        .dataB_in(dataB_in_w[0][2]),
        .dataB_out(dataB_out_w[0][2]),
        .dataA_in(dataA_in_w[0][2]),
        .dataA_out(dataA_out_w[0][2]),
        .r(r_w[0][2])
    );
                    
    // compute_unit(0, 8), (tile(0, 1), unit(0, 3))
                
    assign dataA_in_w[0][3] = dataA_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign data_in_w[0][3] = data_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign op_in_w[0][3] = op_out_w[0][3-1];
    assign inst_op_in_w[0][3] = inst_op_out_w[0][3-1];
    assign dataB_in_w[0][3] = dataB_out_w[0][3-1];
                    
    assign start_in_w[0][3] = start_out_w[0][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(8),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_0_3 (
        .clk(clk),
        .start_in(start_in_w[0][3]),
        .start_out(start_out_w[0][3]),
        .key_data(key_data_w[0][3]),
        .op_in(inst_op_in_w[0][3]),
        .op_out(inst_op_out_w[0][3]),
        .gauss_op_in(op_in_w[0][3]),
        .gauss_op_out(op_out_w[0][3]),
        .data_in(data_in_w[0][3]),
        .data_out(data_out_w[0][3]),
        .dataB_in(dataB_in_w[0][3]),
        .dataB_out(dataB_out_w[0][3]),
        .dataA_in(dataA_in_w[0][3]),
        .dataA_out(dataA_out_w[0][3]),
        .r(r_w[0][3])
    );
                    
    // compute_unit(0, 9), (tile(0, 1), unit(0, 4))
                
    assign dataA_in_w[0][4] = dataA_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign data_in_w[0][4] = data_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign op_in_w[0][4] = op_out_w[0][4-1];
    assign inst_op_in_w[0][4] = inst_op_out_w[0][4-1];
    assign dataB_in_w[0][4] = dataB_out_w[0][4-1];
                    
    assign start_in_w[0][4] = start_out_w[0][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(9),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_0_4 (
        .clk(clk),
        .start_in(start_in_w[0][4]),
        .start_out(start_out_w[0][4]),
        .key_data(key_data_w[0][4]),
        .op_in(inst_op_in_w[0][4]),
        .op_out(inst_op_out_w[0][4]),
        .gauss_op_in(op_in_w[0][4]),
        .gauss_op_out(op_out_w[0][4]),
        .data_in(data_in_w[0][4]),
        .data_out(data_out_w[0][4]),
        .dataB_in(dataB_in_w[0][4]),
        .dataB_out(dataB_out_w[0][4]),
        .dataA_in(dataA_in_w[0][4]),
        .dataA_out(dataA_out_w[0][4]),
        .r(r_w[0][4])
    );
                    
    // compute_unit(1, 5), (tile(0, 1), unit(1, 0))
                
    assign dataA_in_w[1][0] = dataA_out_w[1-1][0];
                    
    assign data_in_w[1][0] = data_out_w[1-1][0];
                    
    assign op_in_w[1][0] = gauss_op_in[2*1+1:2*1];
    assign inst_op_in_w[1][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[1][0] = dataB_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign start_in_w[1][0] = start_row[1];
    assign finish_in_w[1] = finish_row[1];
                    
    always @(posedge clk) begin
        start_tmp[1] <= start_in;
        start_row[1] <= start_tmp[1];
        finish_tmp[1] <= finish_in;
        finish_row[1] <= finish_tmp[1];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(5),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_1_0 (
        .clk(clk),
        .start_in(start_in_w[1][0]),
        .start_out(start_out_w[1][0]),
        .key_data(key_data_w[1][0]),
        .op_in(inst_op_in_w[1][0]),
        .op_out(inst_op_out_w[1][0]),
        .gauss_op_in(op_in_w[1][0]),
        .gauss_op_out(op_out_w[1][0]),
        .data_in(data_in_w[1][0]),
        .data_out(data_out_w[1][0]),
        .dataB_in(dataB_in_w[1][0]),
        .dataB_out(dataB_out_w[1][0]),
        .dataA_in(dataA_in_w[1][0]),
        .dataA_out(dataA_out_w[1][0]),
        .r(r_w[1][0])
    );
                    
    // compute_unit(1, 6), (tile(0, 1), unit(1, 1))
                
    assign dataA_in_w[1][1] = dataA_out_w[1-1][1];
                    
    assign data_in_w[1][1] = data_out_w[1-1][1];
                    
    assign op_in_w[1][1] = op_out_w[1][1-1];
    assign inst_op_in_w[1][1] = inst_op_out_w[1][1-1];
    assign dataB_in_w[1][1] = dataB_out_w[1][1-1];
                    
    assign start_in_w[1][1] = start_out_w[1][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(6),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_1_1 (
        .clk(clk),
        .start_in(start_in_w[1][1]),
        .start_out(start_out_w[1][1]),
        .key_data(key_data_w[1][1]),
        .op_in(inst_op_in_w[1][1]),
        .op_out(inst_op_out_w[1][1]),
        .gauss_op_in(op_in_w[1][1]),
        .gauss_op_out(op_out_w[1][1]),
        .data_in(data_in_w[1][1]),
        .data_out(data_out_w[1][1]),
        .dataB_in(dataB_in_w[1][1]),
        .dataB_out(dataB_out_w[1][1]),
        .dataA_in(dataA_in_w[1][1]),
        .dataA_out(dataA_out_w[1][1]),
        .r(r_w[1][1])
    );
                    
    // compute_unit(1, 7), (tile(0, 1), unit(1, 2))
                
    assign dataA_in_w[1][2] = dataA_out_w[1-1][2];
                    
    assign data_in_w[1][2] = data_out_w[1-1][2];
                    
    assign op_in_w[1][2] = op_out_w[1][2-1];
    assign inst_op_in_w[1][2] = inst_op_out_w[1][2-1];
    assign dataB_in_w[1][2] = dataB_out_w[1][2-1];
                    
    assign start_in_w[1][2] = start_out_w[1][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(7),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_1_2 (
        .clk(clk),
        .start_in(start_in_w[1][2]),
        .start_out(start_out_w[1][2]),
        .key_data(key_data_w[1][2]),
        .op_in(inst_op_in_w[1][2]),
        .op_out(inst_op_out_w[1][2]),
        .gauss_op_in(op_in_w[1][2]),
        .gauss_op_out(op_out_w[1][2]),
        .data_in(data_in_w[1][2]),
        .data_out(data_out_w[1][2]),
        .dataB_in(dataB_in_w[1][2]),
        .dataB_out(dataB_out_w[1][2]),
        .dataA_in(dataA_in_w[1][2]),
        .dataA_out(dataA_out_w[1][2]),
        .r(r_w[1][2])
    );
                    
    // compute_unit(1, 8), (tile(0, 1), unit(1, 3))
                
    assign dataA_in_w[1][3] = dataA_out_w[1-1][3];
                    
    assign data_in_w[1][3] = data_out_w[1-1][3];
                    
    assign op_in_w[1][3] = op_out_w[1][3-1];
    assign inst_op_in_w[1][3] = inst_op_out_w[1][3-1];
    assign dataB_in_w[1][3] = dataB_out_w[1][3-1];
                    
    assign start_in_w[1][3] = start_out_w[1][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(8),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_1_3 (
        .clk(clk),
        .start_in(start_in_w[1][3]),
        .start_out(start_out_w[1][3]),
        .key_data(key_data_w[1][3]),
        .op_in(inst_op_in_w[1][3]),
        .op_out(inst_op_out_w[1][3]),
        .gauss_op_in(op_in_w[1][3]),
        .gauss_op_out(op_out_w[1][3]),
        .data_in(data_in_w[1][3]),
        .data_out(data_out_w[1][3]),
        .dataB_in(dataB_in_w[1][3]),
        .dataB_out(dataB_out_w[1][3]),
        .dataA_in(dataA_in_w[1][3]),
        .dataA_out(dataA_out_w[1][3]),
        .r(r_w[1][3])
    );
                    
    // compute_unit(1, 9), (tile(0, 1), unit(1, 4))
                
    assign dataA_in_w[1][4] = dataA_out_w[1-1][4];
                    
    assign data_in_w[1][4] = data_out_w[1-1][4];
                    
    assign op_in_w[1][4] = op_out_w[1][4-1];
    assign inst_op_in_w[1][4] = inst_op_out_w[1][4-1];
    assign dataB_in_w[1][4] = dataB_out_w[1][4-1];
                    
    assign start_in_w[1][4] = start_out_w[1][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(9),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_1_4 (
        .clk(clk),
        .start_in(start_in_w[1][4]),
        .start_out(start_out_w[1][4]),
        .key_data(key_data_w[1][4]),
        .op_in(inst_op_in_w[1][4]),
        .op_out(inst_op_out_w[1][4]),
        .gauss_op_in(op_in_w[1][4]),
        .gauss_op_out(op_out_w[1][4]),
        .data_in(data_in_w[1][4]),
        .data_out(data_out_w[1][4]),
        .dataB_in(dataB_in_w[1][4]),
        .dataB_out(dataB_out_w[1][4]),
        .dataA_in(dataA_in_w[1][4]),
        .dataA_out(dataA_out_w[1][4]),
        .r(r_w[1][4])
    );
                    
    // compute_unit(2, 5), (tile(0, 1), unit(2, 0))
                
    assign dataA_in_w[2][0] = dataA_out_w[2-1][0];
                    
    assign data_in_w[2][0] = data_out_w[2-1][0];
                    
    assign op_in_w[2][0] = gauss_op_in[2*2+1:2*2];
    assign inst_op_in_w[2][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[2][0] = dataB_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign start_in_w[2][0] = start_row[2];
    assign finish_in_w[2] = finish_row[2];
                    
    always @(posedge clk) begin
        start_tmp[2] <= start_row[2-1];
        start_row[2] <= start_tmp[2];
        finish_tmp[2] <= finish_row[2-1];
        finish_row[2] <= finish_tmp[2];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(5),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_2_0 (
        .clk(clk),
        .start_in(start_in_w[2][0]),
        .start_out(start_out_w[2][0]),
        .key_data(key_data_w[2][0]),
        .op_in(inst_op_in_w[2][0]),
        .op_out(inst_op_out_w[2][0]),
        .gauss_op_in(op_in_w[2][0]),
        .gauss_op_out(op_out_w[2][0]),
        .data_in(data_in_w[2][0]),
        .data_out(data_out_w[2][0]),
        .dataB_in(dataB_in_w[2][0]),
        .dataB_out(dataB_out_w[2][0]),
        .dataA_in(dataA_in_w[2][0]),
        .dataA_out(dataA_out_w[2][0]),
        .r(r_w[2][0])
    );
                    
    // compute_unit(2, 6), (tile(0, 1), unit(2, 1))
                
    assign dataA_in_w[2][1] = dataA_out_w[2-1][1];
                    
    assign data_in_w[2][1] = data_out_w[2-1][1];
                    
    assign op_in_w[2][1] = op_out_w[2][1-1];
    assign inst_op_in_w[2][1] = inst_op_out_w[2][1-1];
    assign dataB_in_w[2][1] = dataB_out_w[2][1-1];
                    
    assign start_in_w[2][1] = start_out_w[2][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(6),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_2_1 (
        .clk(clk),
        .start_in(start_in_w[2][1]),
        .start_out(start_out_w[2][1]),
        .key_data(key_data_w[2][1]),
        .op_in(inst_op_in_w[2][1]),
        .op_out(inst_op_out_w[2][1]),
        .gauss_op_in(op_in_w[2][1]),
        .gauss_op_out(op_out_w[2][1]),
        .data_in(data_in_w[2][1]),
        .data_out(data_out_w[2][1]),
        .dataB_in(dataB_in_w[2][1]),
        .dataB_out(dataB_out_w[2][1]),
        .dataA_in(dataA_in_w[2][1]),
        .dataA_out(dataA_out_w[2][1]),
        .r(r_w[2][1])
    );
                    
    // compute_unit(2, 7), (tile(0, 1), unit(2, 2))
                
    assign dataA_in_w[2][2] = dataA_out_w[2-1][2];
                    
    assign data_in_w[2][2] = data_out_w[2-1][2];
                    
    assign op_in_w[2][2] = op_out_w[2][2-1];
    assign inst_op_in_w[2][2] = inst_op_out_w[2][2-1];
    assign dataB_in_w[2][2] = dataB_out_w[2][2-1];
                    
    assign start_in_w[2][2] = start_out_w[2][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(7),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_2_2 (
        .clk(clk),
        .start_in(start_in_w[2][2]),
        .start_out(start_out_w[2][2]),
        .key_data(key_data_w[2][2]),
        .op_in(inst_op_in_w[2][2]),
        .op_out(inst_op_out_w[2][2]),
        .gauss_op_in(op_in_w[2][2]),
        .gauss_op_out(op_out_w[2][2]),
        .data_in(data_in_w[2][2]),
        .data_out(data_out_w[2][2]),
        .dataB_in(dataB_in_w[2][2]),
        .dataB_out(dataB_out_w[2][2]),
        .dataA_in(dataA_in_w[2][2]),
        .dataA_out(dataA_out_w[2][2]),
        .r(r_w[2][2])
    );
                    
    // compute_unit(2, 8), (tile(0, 1), unit(2, 3))
                
    assign dataA_in_w[2][3] = dataA_out_w[2-1][3];
                    
    assign data_in_w[2][3] = data_out_w[2-1][3];
                    
    assign op_in_w[2][3] = op_out_w[2][3-1];
    assign inst_op_in_w[2][3] = inst_op_out_w[2][3-1];
    assign dataB_in_w[2][3] = dataB_out_w[2][3-1];
                    
    assign start_in_w[2][3] = start_out_w[2][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(8),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_2_3 (
        .clk(clk),
        .start_in(start_in_w[2][3]),
        .start_out(start_out_w[2][3]),
        .key_data(key_data_w[2][3]),
        .op_in(inst_op_in_w[2][3]),
        .op_out(inst_op_out_w[2][3]),
        .gauss_op_in(op_in_w[2][3]),
        .gauss_op_out(op_out_w[2][3]),
        .data_in(data_in_w[2][3]),
        .data_out(data_out_w[2][3]),
        .dataB_in(dataB_in_w[2][3]),
        .dataB_out(dataB_out_w[2][3]),
        .dataA_in(dataA_in_w[2][3]),
        .dataA_out(dataA_out_w[2][3]),
        .r(r_w[2][3])
    );
                    
    // compute_unit(2, 9), (tile(0, 1), unit(2, 4))
                
    assign dataA_in_w[2][4] = dataA_out_w[2-1][4];
                    
    assign data_in_w[2][4] = data_out_w[2-1][4];
                    
    assign op_in_w[2][4] = op_out_w[2][4-1];
    assign inst_op_in_w[2][4] = inst_op_out_w[2][4-1];
    assign dataB_in_w[2][4] = dataB_out_w[2][4-1];
                    
    assign start_in_w[2][4] = start_out_w[2][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(9),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_2_4 (
        .clk(clk),
        .start_in(start_in_w[2][4]),
        .start_out(start_out_w[2][4]),
        .key_data(key_data_w[2][4]),
        .op_in(inst_op_in_w[2][4]),
        .op_out(inst_op_out_w[2][4]),
        .gauss_op_in(op_in_w[2][4]),
        .gauss_op_out(op_out_w[2][4]),
        .data_in(data_in_w[2][4]),
        .data_out(data_out_w[2][4]),
        .dataB_in(dataB_in_w[2][4]),
        .dataB_out(dataB_out_w[2][4]),
        .dataA_in(dataA_in_w[2][4]),
        .dataA_out(dataA_out_w[2][4]),
        .r(r_w[2][4])
    );
                    
    // compute_unit(3, 5), (tile(0, 1), unit(3, 0))
                
    assign dataA_in_w[3][0] = dataA_out_w[3-1][0];
                    
    assign data_in_w[3][0] = data_out_w[3-1][0];
                    
    assign op_in_w[3][0] = gauss_op_in[2*3+1:2*3];
    assign inst_op_in_w[3][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[3][0] = dataB_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign start_in_w[3][0] = start_row[3];
    assign finish_in_w[3] = finish_row[3];
                    
    always @(posedge clk) begin
        start_tmp[3] <= start_row[3-1];
        start_row[3] <= start_tmp[3];
        finish_tmp[3] <= finish_row[3-1];
        finish_row[3] <= finish_tmp[3];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(5),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_3_0 (
        .clk(clk),
        .start_in(start_in_w[3][0]),
        .start_out(start_out_w[3][0]),
        .key_data(key_data_w[3][0]),
        .op_in(inst_op_in_w[3][0]),
        .op_out(inst_op_out_w[3][0]),
        .gauss_op_in(op_in_w[3][0]),
        .gauss_op_out(op_out_w[3][0]),
        .data_in(data_in_w[3][0]),
        .data_out(data_out_w[3][0]),
        .dataB_in(dataB_in_w[3][0]),
        .dataB_out(dataB_out_w[3][0]),
        .dataA_in(dataA_in_w[3][0]),
        .dataA_out(dataA_out_w[3][0]),
        .r(r_w[3][0])
    );
                    
    // compute_unit(3, 6), (tile(0, 1), unit(3, 1))
                
    assign dataA_in_w[3][1] = dataA_out_w[3-1][1];
                    
    assign data_in_w[3][1] = data_out_w[3-1][1];
                    
    assign op_in_w[3][1] = op_out_w[3][1-1];
    assign inst_op_in_w[3][1] = inst_op_out_w[3][1-1];
    assign dataB_in_w[3][1] = dataB_out_w[3][1-1];
                    
    assign start_in_w[3][1] = start_out_w[3][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(6),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_3_1 (
        .clk(clk),
        .start_in(start_in_w[3][1]),
        .start_out(start_out_w[3][1]),
        .key_data(key_data_w[3][1]),
        .op_in(inst_op_in_w[3][1]),
        .op_out(inst_op_out_w[3][1]),
        .gauss_op_in(op_in_w[3][1]),
        .gauss_op_out(op_out_w[3][1]),
        .data_in(data_in_w[3][1]),
        .data_out(data_out_w[3][1]),
        .dataB_in(dataB_in_w[3][1]),
        .dataB_out(dataB_out_w[3][1]),
        .dataA_in(dataA_in_w[3][1]),
        .dataA_out(dataA_out_w[3][1]),
        .r(r_w[3][1])
    );
                    
    // compute_unit(3, 7), (tile(0, 1), unit(3, 2))
                
    assign dataA_in_w[3][2] = dataA_out_w[3-1][2];
                    
    assign data_in_w[3][2] = data_out_w[3-1][2];
                    
    assign op_in_w[3][2] = op_out_w[3][2-1];
    assign inst_op_in_w[3][2] = inst_op_out_w[3][2-1];
    assign dataB_in_w[3][2] = dataB_out_w[3][2-1];
                    
    assign start_in_w[3][2] = start_out_w[3][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(7),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_3_2 (
        .clk(clk),
        .start_in(start_in_w[3][2]),
        .start_out(start_out_w[3][2]),
        .key_data(key_data_w[3][2]),
        .op_in(inst_op_in_w[3][2]),
        .op_out(inst_op_out_w[3][2]),
        .gauss_op_in(op_in_w[3][2]),
        .gauss_op_out(op_out_w[3][2]),
        .data_in(data_in_w[3][2]),
        .data_out(data_out_w[3][2]),
        .dataB_in(dataB_in_w[3][2]),
        .dataB_out(dataB_out_w[3][2]),
        .dataA_in(dataA_in_w[3][2]),
        .dataA_out(dataA_out_w[3][2]),
        .r(r_w[3][2])
    );
                    
    // compute_unit(3, 8), (tile(0, 1), unit(3, 3))
                
    assign dataA_in_w[3][3] = dataA_out_w[3-1][3];
                    
    assign data_in_w[3][3] = data_out_w[3-1][3];
                    
    assign op_in_w[3][3] = op_out_w[3][3-1];
    assign inst_op_in_w[3][3] = inst_op_out_w[3][3-1];
    assign dataB_in_w[3][3] = dataB_out_w[3][3-1];
                    
    assign start_in_w[3][3] = start_out_w[3][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(8),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_3_3 (
        .clk(clk),
        .start_in(start_in_w[3][3]),
        .start_out(start_out_w[3][3]),
        .key_data(key_data_w[3][3]),
        .op_in(inst_op_in_w[3][3]),
        .op_out(inst_op_out_w[3][3]),
        .gauss_op_in(op_in_w[3][3]),
        .gauss_op_out(op_out_w[3][3]),
        .data_in(data_in_w[3][3]),
        .data_out(data_out_w[3][3]),
        .dataB_in(dataB_in_w[3][3]),
        .dataB_out(dataB_out_w[3][3]),
        .dataA_in(dataA_in_w[3][3]),
        .dataA_out(dataA_out_w[3][3]),
        .r(r_w[3][3])
    );
                    
    // compute_unit(3, 9), (tile(0, 1), unit(3, 4))
                
    assign dataA_in_w[3][4] = dataA_out_w[3-1][4];
                    
    assign data_in_w[3][4] = data_out_w[3-1][4];
                    
    assign op_in_w[3][4] = op_out_w[3][4-1];
    assign inst_op_in_w[3][4] = inst_op_out_w[3][4-1];
    assign dataB_in_w[3][4] = dataB_out_w[3][4-1];
                    
    assign start_in_w[3][4] = start_out_w[3][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(9),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_3_4 (
        .clk(clk),
        .start_in(start_in_w[3][4]),
        .start_out(start_out_w[3][4]),
        .key_data(key_data_w[3][4]),
        .op_in(inst_op_in_w[3][4]),
        .op_out(inst_op_out_w[3][4]),
        .gauss_op_in(op_in_w[3][4]),
        .gauss_op_out(op_out_w[3][4]),
        .data_in(data_in_w[3][4]),
        .data_out(data_out_w[3][4]),
        .dataB_in(dataB_in_w[3][4]),
        .dataB_out(dataB_out_w[3][4]),
        .dataA_in(dataA_in_w[3][4]),
        .dataA_out(dataA_out_w[3][4]),
        .r(r_w[3][4])
    );
                    
    // compute_unit(4, 5), (tile(0, 1), unit(4, 0))
                
    assign dataA_in_w[4][0] = dataA_out_w[4-1][0];
                    
    assign data_in_w[4][0] = data_out_w[4-1][0];
                    
    assign op_in_w[4][0] = gauss_op_in[2*4+1:2*4];
    assign inst_op_in_w[4][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[4][0] = dataB_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign start_in_w[4][0] = start_row[4];
    assign finish_in_w[4] = finish_row[4];
                    
    always @(posedge clk) begin
        start_tmp[4] <= start_row[4-1];
        start_row[4] <= start_tmp[4];
        finish_tmp[4] <= finish_row[4-1];
        finish_row[4] <= finish_tmp[4];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(5),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_4_0 (
        .clk(clk),
        .start_in(start_in_w[4][0]),
        .start_out(start_out_w[4][0]),
        .key_data(key_data_w[4][0]),
        .op_in(inst_op_in_w[4][0]),
        .op_out(inst_op_out_w[4][0]),
        .gauss_op_in(op_in_w[4][0]),
        .gauss_op_out(op_out_w[4][0]),
        .data_in(data_in_w[4][0]),
        .data_out(data_out_w[4][0]),
        .dataB_in(dataB_in_w[4][0]),
        .dataB_out(dataB_out_w[4][0]),
        .dataA_in(dataA_in_w[4][0]),
        .dataA_out(dataA_out_w[4][0]),
        .r(r_w[4][0])
    );
                    
    // compute_unit(4, 6), (tile(0, 1), unit(4, 1))
                
    assign dataA_in_w[4][1] = dataA_out_w[4-1][1];
                    
    assign data_in_w[4][1] = data_out_w[4-1][1];
                    
    assign op_in_w[4][1] = op_out_w[4][1-1];
    assign inst_op_in_w[4][1] = inst_op_out_w[4][1-1];
    assign dataB_in_w[4][1] = dataB_out_w[4][1-1];
                    
    assign start_in_w[4][1] = start_out_w[4][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(6),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_4_1 (
        .clk(clk),
        .start_in(start_in_w[4][1]),
        .start_out(start_out_w[4][1]),
        .key_data(key_data_w[4][1]),
        .op_in(inst_op_in_w[4][1]),
        .op_out(inst_op_out_w[4][1]),
        .gauss_op_in(op_in_w[4][1]),
        .gauss_op_out(op_out_w[4][1]),
        .data_in(data_in_w[4][1]),
        .data_out(data_out_w[4][1]),
        .dataB_in(dataB_in_w[4][1]),
        .dataB_out(dataB_out_w[4][1]),
        .dataA_in(dataA_in_w[4][1]),
        .dataA_out(dataA_out_w[4][1]),
        .r(r_w[4][1])
    );
                    
    // compute_unit(4, 7), (tile(0, 1), unit(4, 2))
                
    assign dataA_in_w[4][2] = dataA_out_w[4-1][2];
                    
    assign data_in_w[4][2] = data_out_w[4-1][2];
                    
    assign op_in_w[4][2] = op_out_w[4][2-1];
    assign inst_op_in_w[4][2] = inst_op_out_w[4][2-1];
    assign dataB_in_w[4][2] = dataB_out_w[4][2-1];
                    
    assign start_in_w[4][2] = start_out_w[4][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(7),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_4_2 (
        .clk(clk),
        .start_in(start_in_w[4][2]),
        .start_out(start_out_w[4][2]),
        .key_data(key_data_w[4][2]),
        .op_in(inst_op_in_w[4][2]),
        .op_out(inst_op_out_w[4][2]),
        .gauss_op_in(op_in_w[4][2]),
        .gauss_op_out(op_out_w[4][2]),
        .data_in(data_in_w[4][2]),
        .data_out(data_out_w[4][2]),
        .dataB_in(dataB_in_w[4][2]),
        .dataB_out(dataB_out_w[4][2]),
        .dataA_in(dataA_in_w[4][2]),
        .dataA_out(dataA_out_w[4][2]),
        .r(r_w[4][2])
    );
                    
    // compute_unit(4, 8), (tile(0, 1), unit(4, 3))
                
    assign dataA_in_w[4][3] = dataA_out_w[4-1][3];
                    
    assign data_in_w[4][3] = data_out_w[4-1][3];
                    
    assign op_in_w[4][3] = op_out_w[4][3-1];
    assign inst_op_in_w[4][3] = inst_op_out_w[4][3-1];
    assign dataB_in_w[4][3] = dataB_out_w[4][3-1];
                    
    assign start_in_w[4][3] = start_out_w[4][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(8),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_4_3 (
        .clk(clk),
        .start_in(start_in_w[4][3]),
        .start_out(start_out_w[4][3]),
        .key_data(key_data_w[4][3]),
        .op_in(inst_op_in_w[4][3]),
        .op_out(inst_op_out_w[4][3]),
        .gauss_op_in(op_in_w[4][3]),
        .gauss_op_out(op_out_w[4][3]),
        .data_in(data_in_w[4][3]),
        .data_out(data_out_w[4][3]),
        .dataB_in(dataB_in_w[4][3]),
        .dataB_out(dataB_out_w[4][3]),
        .dataA_in(dataA_in_w[4][3]),
        .dataA_out(dataA_out_w[4][3]),
        .r(r_w[4][3])
    );
                    
    // compute_unit(4, 9), (tile(0, 1), unit(4, 4))
                
    assign dataA_in_w[4][4] = dataA_out_w[4-1][4];
                    
    assign data_in_w[4][4] = data_out_w[4-1][4];
                    
    assign op_in_w[4][4] = op_out_w[4][4-1];
    assign inst_op_in_w[4][4] = inst_op_out_w[4][4-1];
    assign dataB_in_w[4][4] = dataB_out_w[4][4-1];
                    
    assign start_in_w[4][4] = start_out_w[4][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(9),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_4_4 (
        .clk(clk),
        .start_in(start_in_w[4][4]),
        .start_out(start_out_w[4][4]),
        .key_data(key_data_w[4][4]),
        .op_in(inst_op_in_w[4][4]),
        .op_out(inst_op_out_w[4][4]),
        .gauss_op_in(op_in_w[4][4]),
        .gauss_op_out(op_out_w[4][4]),
        .data_in(data_in_w[4][4]),
        .data_out(data_out_w[4][4]),
        .dataB_in(dataB_in_w[4][4]),
        .dataB_out(dataB_out_w[4][4]),
        .dataA_in(dataA_in_w[4][4]),
        .dataA_out(dataA_out_w[4][4]),
        .r(r_w[4][4])
    );
                    
    // compute_unit(5, 5), (tile(0, 1), unit(5, 0))
                
    assign dataA_in_w[5][0] = dataA_out_w[5-1][0];
                    
    assign data_in_w[5][0] = data_out_w[5-1][0];
                    
    assign op_in_w[5][0] = gauss_op_in[2*5+1:2*5];
    assign inst_op_in_w[5][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[5][0] = dataB_in[GF_BIT*5+(GF_BIT-1):GF_BIT*5];
                    
    assign start_in_w[5][0] = start_row[5];
    assign finish_in_w[5] = finish_row[5];
                    
    always @(posedge clk) begin
        start_tmp[5] <= start_row[5-1];
        start_row[5] <= start_tmp[5];
        finish_tmp[5] <= finish_row[5-1];
        finish_row[5] <= finish_tmp[5];
    end
                        
    processor_ABC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(5),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) AB_proc_5_0 (
        .clk(clk),
        .start_in(start_in_w[5][0]),
        .start_out(start_out_w[5][0]),
        .finish_in(finish_in_w[5]),
        .finish_out(finish_out_w[5]),
        .key_data(key_data_w[5][0]),
        .op_in(inst_op_in_w[5][0]),
        .op_out(inst_op_out_w[5][0]),
        .gauss_op_in(op_in_w[5][0]),
        .gauss_op_out(op_out_w[5][0]),
        .data_in(data_in_w[5][0]),
        .data_out(data_out_w[5][0]),
        .dataB_in(dataB_in_w[5][0]),
        .dataB_out(dataB_out_w[5][0]),
        .dataA_in(dataA_in_w[5][0]),
        .dataA_out(dataA_out_w[5][0]),
        .r(r_w[5][0]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(5, 6), (tile(0, 1), unit(5, 1))
                
    assign dataA_in_w[5][1] = dataA_out_w[5-1][1];
                    
    assign data_in_w[5][1] = data_out_w[5-1][1];
                    
    assign op_in_w[5][1] = op_out_w[5][1-1];
    assign inst_op_in_w[5][1] = inst_op_out_w[5][1-1];
    assign dataB_in_w[5][1] = dataB_out_w[5][1-1];
                    
    assign start_in_w[5][1] = start_out_w[5][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(6),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_5_1 (
        .clk(clk),
        .start_in(start_in_w[5][1]),
        .start_out(start_out_w[5][1]),
        .key_data(key_data_w[5][1]),
        .op_in(inst_op_in_w[5][1]),
        .op_out(inst_op_out_w[5][1]),
        .gauss_op_in(op_in_w[5][1]),
        .gauss_op_out(op_out_w[5][1]),
        .data_in(data_in_w[5][1]),
        .data_out(data_out_w[5][1]),
        .dataB_in(dataB_in_w[5][1]),
        .dataB_out(dataB_out_w[5][1]),
        .dataA_in(dataA_in_w[5][1]),
        .dataA_out(dataA_out_w[5][1]),
        .r(r_w[5][1])
    );
                    
    // compute_unit(5, 7), (tile(0, 1), unit(5, 2))
                
    assign dataA_in_w[5][2] = dataA_out_w[5-1][2];
                    
    assign data_in_w[5][2] = data_out_w[5-1][2];
                    
    assign op_in_w[5][2] = op_out_w[5][2-1];
    assign inst_op_in_w[5][2] = inst_op_out_w[5][2-1];
    assign dataB_in_w[5][2] = dataB_out_w[5][2-1];
                    
    assign start_in_w[5][2] = start_out_w[5][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(7),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_5_2 (
        .clk(clk),
        .start_in(start_in_w[5][2]),
        .start_out(start_out_w[5][2]),
        .key_data(key_data_w[5][2]),
        .op_in(inst_op_in_w[5][2]),
        .op_out(inst_op_out_w[5][2]),
        .gauss_op_in(op_in_w[5][2]),
        .gauss_op_out(op_out_w[5][2]),
        .data_in(data_in_w[5][2]),
        .data_out(data_out_w[5][2]),
        .dataB_in(dataB_in_w[5][2]),
        .dataB_out(dataB_out_w[5][2]),
        .dataA_in(dataA_in_w[5][2]),
        .dataA_out(dataA_out_w[5][2]),
        .r(r_w[5][2])
    );
                    
    // compute_unit(5, 8), (tile(0, 1), unit(5, 3))
                
    assign dataA_in_w[5][3] = dataA_out_w[5-1][3];
                    
    assign data_in_w[5][3] = data_out_w[5-1][3];
                    
    assign op_in_w[5][3] = op_out_w[5][3-1];
    assign inst_op_in_w[5][3] = inst_op_out_w[5][3-1];
    assign dataB_in_w[5][3] = dataB_out_w[5][3-1];
                    
    assign start_in_w[5][3] = start_out_w[5][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(8),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_5_3 (
        .clk(clk),
        .start_in(start_in_w[5][3]),
        .start_out(start_out_w[5][3]),
        .key_data(key_data_w[5][3]),
        .op_in(inst_op_in_w[5][3]),
        .op_out(inst_op_out_w[5][3]),
        .gauss_op_in(op_in_w[5][3]),
        .gauss_op_out(op_out_w[5][3]),
        .data_in(data_in_w[5][3]),
        .data_out(data_out_w[5][3]),
        .dataB_in(dataB_in_w[5][3]),
        .dataB_out(dataB_out_w[5][3]),
        .dataA_in(dataA_in_w[5][3]),
        .dataA_out(dataA_out_w[5][3]),
        .r(r_w[5][3])
    );
                    
    // compute_unit(5, 9), (tile(0, 1), unit(5, 4))
                
    assign dataA_in_w[5][4] = dataA_out_w[5-1][4];
                    
    assign data_in_w[5][4] = data_out_w[5-1][4];
                    
    assign op_in_w[5][4] = op_out_w[5][4-1];
    assign inst_op_in_w[5][4] = inst_op_out_w[5][4-1];
    assign dataB_in_w[5][4] = dataB_out_w[5][4-1];
                    
    assign start_in_w[5][4] = start_out_w[5][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(9),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_5_4 (
        .clk(clk),
        .start_in(start_in_w[5][4]),
        .start_out(start_out_w[5][4]),
        .key_data(key_data_w[5][4]),
        .op_in(inst_op_in_w[5][4]),
        .op_out(inst_op_out_w[5][4]),
        .gauss_op_in(op_in_w[5][4]),
        .gauss_op_out(op_out_w[5][4]),
        .data_in(data_in_w[5][4]),
        .data_out(data_out_w[5][4]),
        .dataB_in(dataB_in_w[5][4]),
        .dataB_out(dataB_out_w[5][4]),
        .dataA_in(dataA_in_w[5][4]),
        .dataA_out(dataA_out_w[5][4]),
        .r(r_w[5][4])
    );
                    
    // compute_unit(6, 5), (tile(0, 1), unit(6, 0))
                
    assign dataA_in_w[6][0] = dataA_out_w[6-1][0];
                    
    assign data_in_w[6][0] = data_out_w[6-1][0];
                    
    assign op_in_w[6][0] = gauss_op_in[2*6+1:2*6];
    assign inst_op_in_w[6][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[6][0] = dataB_in[GF_BIT*6+(GF_BIT-1):GF_BIT*6];
                    
    assign start_in_w[6][0] = start_row[6];
    assign finish_in_w[6] = finish_row[6];
                    
    always @(posedge clk) begin
        start_tmp[6] <= start_row[6-1];
        start_row[6] <= start_tmp[6];
        finish_tmp[6] <= finish_row[6-1];
        finish_row[6] <= finish_tmp[6];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(5),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_6_0 (
        .clk(clk),
        .start_in(start_in_w[6][0]),
        .start_out(start_out_w[6][0]),
        .key_data(key_data_w[6][0]),
        .op_in(inst_op_in_w[6][0]),
        .op_out(inst_op_out_w[6][0]),
        .gauss_op_in(op_in_w[6][0]),
        .gauss_op_out(op_out_w[6][0]),
        .data_in(data_in_w[6][0]),
        .data_out(data_out_w[6][0]),
        .dataB_in(dataB_in_w[6][0]),
        .dataB_out(dataB_out_w[6][0]),
        .dataA_in(dataA_in_w[6][0]),
        .dataA_out(dataA_out_w[6][0]),
        .r(r_w[6][0])
    );
                    
    // compute_unit(6, 6), (tile(0, 1), unit(6, 1))
                
    assign dataA_in_w[6][1] = dataA_out_w[6-1][1];
                    
    assign data_in_w[6][1] = data_out_w[6-1][1];
                    
    assign op_in_w[6][1] = op_out_w[6][1-1];
    assign inst_op_in_w[6][1] = inst_op_out_w[6][1-1];
    assign dataB_in_w[6][1] = dataB_out_w[6][1-1];
                    
    assign start_in_w[6][1] = start_out_w[6][1-1];
                    
    processor_AB #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(6),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) AB_proc_6_1 (
        .clk(clk),
        .start_in(start_in_w[6][1]),
        .start_out(start_out_w[6][1]),
        .finish_in(finish_in_w[6]),
        .finish_out(finish_out_w[6]),
        .key_data(key_data_w[6][1]),
        .op_in(inst_op_in_w[6][1]),
        .op_out(inst_op_out_w[6][1]),
        .gauss_op_in(op_in_w[6][1]),
        .gauss_op_out(op_out_w[6][1]),
        .data_in(data_in_w[6][1]),
        .data_out(data_out_w[6][1]),
        .dataB_in(dataB_in_w[6][1]),
        .dataB_out(dataB_out_w[6][1]),
        .dataA_in(dataA_in_w[6][1]),
        .dataA_out(dataA_out_w[6][1]),
        .r(r_w[6][1]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(6, 7), (tile(0, 1), unit(6, 2))
                
    assign dataA_in_w[6][2] = dataA_out_w[6-1][2];
                    
    assign data_in_w[6][2] = data_out_w[6-1][2];
                    
    assign op_in_w[6][2] = op_out_w[6][2-1];
    assign inst_op_in_w[6][2] = inst_op_out_w[6][2-1];
    assign dataB_in_w[6][2] = dataB_out_w[6][2-1];
                    
    assign start_in_w[6][2] = start_out_w[6][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(7),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_6_2 (
        .clk(clk),
        .start_in(start_in_w[6][2]),
        .start_out(start_out_w[6][2]),
        .key_data(key_data_w[6][2]),
        .op_in(inst_op_in_w[6][2]),
        .op_out(inst_op_out_w[6][2]),
        .gauss_op_in(op_in_w[6][2]),
        .gauss_op_out(op_out_w[6][2]),
        .data_in(data_in_w[6][2]),
        .data_out(data_out_w[6][2]),
        .dataB_in(dataB_in_w[6][2]),
        .dataB_out(dataB_out_w[6][2]),
        .dataA_in(dataA_in_w[6][2]),
        .dataA_out(dataA_out_w[6][2]),
        .r(r_w[6][2])
    );
                    
    // compute_unit(6, 8), (tile(0, 1), unit(6, 3))
                
    assign dataA_in_w[6][3] = dataA_out_w[6-1][3];
                    
    assign data_in_w[6][3] = data_out_w[6-1][3];
                    
    assign op_in_w[6][3] = op_out_w[6][3-1];
    assign inst_op_in_w[6][3] = inst_op_out_w[6][3-1];
    assign dataB_in_w[6][3] = dataB_out_w[6][3-1];
                    
    assign start_in_w[6][3] = start_out_w[6][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(8),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_6_3 (
        .clk(clk),
        .start_in(start_in_w[6][3]),
        .start_out(start_out_w[6][3]),
        .key_data(key_data_w[6][3]),
        .op_in(inst_op_in_w[6][3]),
        .op_out(inst_op_out_w[6][3]),
        .gauss_op_in(op_in_w[6][3]),
        .gauss_op_out(op_out_w[6][3]),
        .data_in(data_in_w[6][3]),
        .data_out(data_out_w[6][3]),
        .dataB_in(dataB_in_w[6][3]),
        .dataB_out(dataB_out_w[6][3]),
        .dataA_in(dataA_in_w[6][3]),
        .dataA_out(dataA_out_w[6][3]),
        .r(r_w[6][3])
    );
                    
    // compute_unit(6, 9), (tile(0, 1), unit(6, 4))
                
    assign dataA_in_w[6][4] = dataA_out_w[6-1][4];
                    
    assign data_in_w[6][4] = data_out_w[6-1][4];
                    
    assign op_in_w[6][4] = op_out_w[6][4-1];
    assign inst_op_in_w[6][4] = inst_op_out_w[6][4-1];
    assign dataB_in_w[6][4] = dataB_out_w[6][4-1];
                    
    assign start_in_w[6][4] = start_out_w[6][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(9),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_6_4 (
        .clk(clk),
        .start_in(start_in_w[6][4]),
        .start_out(start_out_w[6][4]),
        .key_data(key_data_w[6][4]),
        .op_in(inst_op_in_w[6][4]),
        .op_out(inst_op_out_w[6][4]),
        .gauss_op_in(op_in_w[6][4]),
        .gauss_op_out(op_out_w[6][4]),
        .data_in(data_in_w[6][4]),
        .data_out(data_out_w[6][4]),
        .dataB_in(dataB_in_w[6][4]),
        .dataB_out(dataB_out_w[6][4]),
        .dataA_in(dataA_in_w[6][4]),
        .dataA_out(dataA_out_w[6][4]),
        .r(r_w[6][4])
    );
                    
    // compute_unit(7, 5), (tile(0, 1), unit(7, 0))
                
    assign dataA_in_w[7][0] = dataA_out_w[7-1][0];
                    
    assign data_in_w[7][0] = data_out_w[7-1][0];
                    
    assign op_in_w[7][0] = gauss_op_in[2*7+1:2*7];
    assign inst_op_in_w[7][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[7][0] = dataB_in[GF_BIT*7+(GF_BIT-1):GF_BIT*7];
                    
    assign start_in_w[7][0] = start_row[7];
    assign finish_in_w[7] = finish_row[7];
                    
    always @(posedge clk) begin
        start_tmp[7] <= start_row[7-1];
        start_row[7] <= start_tmp[7];
        finish_tmp[7] <= finish_row[7-1];
        finish_row[7] <= finish_tmp[7];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(5),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_7_0 (
        .clk(clk),
        .start_in(start_in_w[7][0]),
        .start_out(start_out_w[7][0]),
        .key_data(key_data_w[7][0]),
        .op_in(inst_op_in_w[7][0]),
        .op_out(inst_op_out_w[7][0]),
        .gauss_op_in(op_in_w[7][0]),
        .gauss_op_out(op_out_w[7][0]),
        .data_in(data_in_w[7][0]),
        .data_out(data_out_w[7][0]),
        .dataB_in(dataB_in_w[7][0]),
        .dataB_out(dataB_out_w[7][0]),
        .dataA_in(dataA_in_w[7][0]),
        .dataA_out(dataA_out_w[7][0]),
        .r(r_w[7][0])
    );
                    
    // compute_unit(7, 6), (tile(0, 1), unit(7, 1))
                
    assign dataA_in_w[7][1] = dataA_out_w[7-1][1];
                    
    assign data_in_w[7][1] = data_out_w[7-1][1];
                    
    assign op_in_w[7][1] = op_out_w[7][1-1];
    assign inst_op_in_w[7][1] = inst_op_out_w[7][1-1];
    assign dataB_in_w[7][1] = dataB_out_w[7][1-1];
                    
    assign start_in_w[7][1] = start_out_w[7][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(6),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_7_1 (
        .clk(clk),
        .start_in(start_in_w[7][1]),
        .start_out(start_out_w[7][1]),
        .key_data(key_data_w[7][1]),
        .op_in(inst_op_in_w[7][1]),
        .op_out(inst_op_out_w[7][1]),
        .gauss_op_in(op_in_w[7][1]),
        .gauss_op_out(op_out_w[7][1]),
        .data_in(data_in_w[7][1]),
        .data_out(data_out_w[7][1]),
        .dataB_in(dataB_in_w[7][1]),
        .dataB_out(dataB_out_w[7][1]),
        .dataA_in(dataA_in_w[7][1]),
        .dataA_out(dataA_out_w[7][1]),
        .r(r_w[7][1])
    );
                    
    // compute_unit(7, 7), (tile(0, 1), unit(7, 2))
                
    assign dataA_in_w[7][2] = dataA_out_w[7-1][2];
                    
    assign data_in_w[7][2] = data_out_w[7-1][2];
                    
    assign op_in_w[7][2] = op_out_w[7][2-1];
    assign inst_op_in_w[7][2] = inst_op_out_w[7][2-1];
    assign dataB_in_w[7][2] = dataB_out_w[7][2-1];
                    
    assign start_in_w[7][2] = start_out_w[7][2-1];
                    
    processor_AB #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(7),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) AB_proc_7_2 (
        .clk(clk),
        .start_in(start_in_w[7][2]),
        .start_out(start_out_w[7][2]),
        .finish_in(finish_in_w[7]),
        .finish_out(finish_out_w[7]),
        .key_data(key_data_w[7][2]),
        .op_in(inst_op_in_w[7][2]),
        .op_out(inst_op_out_w[7][2]),
        .gauss_op_in(op_in_w[7][2]),
        .gauss_op_out(op_out_w[7][2]),
        .data_in(data_in_w[7][2]),
        .data_out(data_out_w[7][2]),
        .dataB_in(dataB_in_w[7][2]),
        .dataB_out(dataB_out_w[7][2]),
        .dataA_in(dataA_in_w[7][2]),
        .dataA_out(dataA_out_w[7][2]),
        .r(r_w[7][2]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(7, 8), (tile(0, 1), unit(7, 3))
                
    assign dataA_in_w[7][3] = dataA_out_w[7-1][3];
                    
    assign data_in_w[7][3] = data_out_w[7-1][3];
                    
    assign op_in_w[7][3] = op_out_w[7][3-1];
    assign inst_op_in_w[7][3] = inst_op_out_w[7][3-1];
    assign dataB_in_w[7][3] = dataB_out_w[7][3-1];
                    
    assign start_in_w[7][3] = start_out_w[7][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(8),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_7_3 (
        .clk(clk),
        .start_in(start_in_w[7][3]),
        .start_out(start_out_w[7][3]),
        .key_data(key_data_w[7][3]),
        .op_in(inst_op_in_w[7][3]),
        .op_out(inst_op_out_w[7][3]),
        .gauss_op_in(op_in_w[7][3]),
        .gauss_op_out(op_out_w[7][3]),
        .data_in(data_in_w[7][3]),
        .data_out(data_out_w[7][3]),
        .dataB_in(dataB_in_w[7][3]),
        .dataB_out(dataB_out_w[7][3]),
        .dataA_in(dataA_in_w[7][3]),
        .dataA_out(dataA_out_w[7][3]),
        .r(r_w[7][3])
    );
                    
    // compute_unit(7, 9), (tile(0, 1), unit(7, 4))
                
    assign dataA_in_w[7][4] = dataA_out_w[7-1][4];
                    
    assign data_in_w[7][4] = data_out_w[7-1][4];
                    
    assign op_in_w[7][4] = op_out_w[7][4-1];
    assign inst_op_in_w[7][4] = inst_op_out_w[7][4-1];
    assign dataB_in_w[7][4] = dataB_out_w[7][4-1];
                    
    assign start_in_w[7][4] = start_out_w[7][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(9),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_7_4 (
        .clk(clk),
        .start_in(start_in_w[7][4]),
        .start_out(start_out_w[7][4]),
        .key_data(key_data_w[7][4]),
        .op_in(inst_op_in_w[7][4]),
        .op_out(inst_op_out_w[7][4]),
        .gauss_op_in(op_in_w[7][4]),
        .gauss_op_out(op_out_w[7][4]),
        .data_in(data_in_w[7][4]),
        .data_out(data_out_w[7][4]),
        .dataB_in(dataB_in_w[7][4]),
        .dataB_out(dataB_out_w[7][4]),
        .dataA_in(dataA_in_w[7][4]),
        .dataA_out(dataA_out_w[7][4]),
        .r(r_w[7][4])
    );
                    
    generate
        for (i = 0; i < COL; i=i+1) begin
            for (j = 0; j < GF_BIT; j=j+1) begin
                assign data_out[i*GF_BIT+j] = data_out_w[ROW-1][i][j];
            end
        end
    endgenerate
        
    generate
        for (i = 0; i < ROW; i=i+1) begin
            assign gauss_op_out[2*i+1:2*i] = op_out_w[i][COL-1];
            assign dataB_out[GF_BIT*i+(GF_BIT-1):GF_BIT*i] = dataB_out_w[i][COL-1];
        end
    endgenerate
        
    wire [3-1:0] is_one;
            
                        assign is_one[0] = (r_w[5][0] == 1); // current_row = 5, current_col = 5
                        
                        assign is_one[1] = (r_w[6][1] == 1); // current_row = 6, current_col = 6
                        
                        assign is_one[2] = (r_w[7][2] == 1); // current_row = 7, current_col = 7
                        
    assign r_A_and = &is_one;
            
    reg start_out_tmp;
    reg finish_out_tmp;
    always @(posedge clk) begin
        start_out_tmp  <= start_row[ROW-1];
        finish_out_tmp <= finish_row[ROW-1];
        start_out      <= start_out_tmp;
        finish_out     <= finish_out_tmp;
    end

endmodule
        
// row = 8, col = 6
module tile_0_2#(
    parameter N = 16,
    parameter GF_BIT = 8,
    parameter OP_SIZE = 22,
    parameter ROW = 8,
    parameter COL = 6
)(
    input wire                      clk,
    input wire                      rst_n,
    input wire        [OP_SIZE-1:0] op_in,        // decide which operations
    input wire     [GF_BIT*COL-1:0] dataA_in,     // for mat_mul, load
    input wire          [2*ROW-1:0] gauss_op_in,  // for gauss
    input wire     [GF_BIT*ROW-1:0] dataB_in,     // for gauss
    input wire     [GF_BIT*COL-1:0] data_in,      // for gauss, store (not used in first row)
    input wire                      start_in, 
    input wire                      finish_in,
    output wire         [2*ROW-1:0] gauss_op_out, // for gauss
    output wire    [GF_BIT*ROW-1:0] dataB_out,    // for gauss
    output wire    [GF_BIT*COL-1:0] data_out,     // for gauss, store
    output reg                      start_out,
    output reg                      finish_out,
    output wire                     r_A_and
);
    
    localparam TILE_ROW_IDX = 0;
    localparam TILE_COL_IDX = 2;
    localparam NUM_PROC_COL = 3;
    localparam BANK = 5; 

    genvar i, j, k;
    integer n, m;

    wire                  start_in_w[0:ROW-1][0:COL-1];
    wire                 start_out_w[0:ROW-1][0:COL-1];
    wire                 finish_in_w[0:ROW-1];
    wire                finish_out_w[0:ROW-1];
    wire         [3:0]  inst_op_in_w[0:ROW-1][0:COL-1];
    wire         [3:0] inst_op_out_w[0:ROW-1][0:COL-1];
    wire         [1:0]       op_in_w[0:ROW-1][0:COL-1];
    wire         [1:0]      op_out_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    dataB_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]   dataB_out_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]           r_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]     data_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    dataA_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]   dataA_out_w[0:ROW-1][0:COL-1];
    reg   [GF_BIT-1:0]     data_in_r[1:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    data_out_w[0:ROW-1][0:COL-1];

    reg [ROW-1 : 1] start_tmp;
    reg [ROW-1 : 1] start_row;
    
    reg [ROW-1 : 1] finish_tmp;
    reg [ROW-1 : 1] finish_row;
    
    reg functionA_dup;
    always @(posedge clk) begin
        functionA_dup <= op_in[17];
    end

    wire [GF_BIT*8*BANK-1:0] key_data;
    wire          [GF_BIT-1:0] key_data_w[0:ROW-1][0:COL-1];
    wire                       key_wren;
    wire      [GF_BIT*ROW-1:0] key_write_data;
    generate
        if (GF_BIT*8 != 0) begin: key_mem
            assign key_wren = op_in[14];
            bram16Kx4 #(
                .WIDTH(GF_BIT*8),
                .DELAY(1)
            ) mem_inst (
                .clock (clk),
                .data (key_write_data),
                .address (op_in[14-1:0]),
                .wren (key_wren),
                .q (key_data)
            );
            for (j = 0; j < ROW; j=j+1) begin
                for (k = 0; k < BANK; k=k+1) begin
                    assign key_data_w[j][k] = (j < 8) ? key_data[(j+k*8)*GF_BIT+:GF_BIT] : 0; // load from
                end
                assign key_write_data[j*GF_BIT+:GF_BIT] = r_w[j][0];                        // write to
            end
        end else begin
            for (j = 0; j < ROW; j=j+1) begin
                for (k = 0; k < BANK; k=k+1) begin
                    assign key_data_w[j][k] = 0; // load from
                end
            end
        end
    endgenerate

    // always@(posedge clk) begin
    //     if ((op_in[OP_SIZE-1:OP_SIZE-4] == 7)) begin
    //         $display("_____________________________________________");
    //         $display("| 0_2, 8, 6");
    //         $display("| dataA_in: %x,  dataB_in: %x, addr: %d, key_data: %x, key_write_data: %x, key_wren: %d", dataA_in, dataB_in, op_in[14-1:0], key_data, key_write_data, key_wren);
    //         $display("|____________________________________________");
    //     end
    // end
        
    // compute_unit(0, 10), (tile(0, 2), unit(0, 0))
                
    assign dataA_in_w[0][0] = dataA_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign data_in_w[0][0] = data_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign op_in_w[0][0] = gauss_op_in[2*0+1:2*0];
    assign inst_op_in_w[0][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[0][0] = dataB_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign start_in_w[0][0] = start_in;
    assign finish_in_w[0] = finish_in;
                    
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(10),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_0_0 (
        .clk(clk),
        .start_in(start_in_w[0][0]),
        .start_out(start_out_w[0][0]),
        .key_data(key_data_w[0][0]),
        .op_in(inst_op_in_w[0][0]),
        .op_out(inst_op_out_w[0][0]),
        .gauss_op_in(op_in_w[0][0]),
        .gauss_op_out(op_out_w[0][0]),
        .data_in(data_in_w[0][0]),
        .data_out(data_out_w[0][0]),
        .dataB_in(dataB_in_w[0][0]),
        .dataB_out(dataB_out_w[0][0]),
        .dataA_in(dataA_in_w[0][0]),
        .dataA_out(dataA_out_w[0][0]),
        .r(r_w[0][0])
    );
                    
    // compute_unit(0, 11), (tile(0, 2), unit(0, 1))
                
    assign dataA_in_w[0][1] = dataA_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign data_in_w[0][1] = data_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign op_in_w[0][1] = op_out_w[0][1-1];
    assign inst_op_in_w[0][1] = inst_op_out_w[0][1-1];
    assign dataB_in_w[0][1] = dataB_out_w[0][1-1];
                    
    assign start_in_w[0][1] = start_out_w[0][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(11),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_0_1 (
        .clk(clk),
        .start_in(start_in_w[0][1]),
        .start_out(start_out_w[0][1]),
        .key_data(key_data_w[0][1]),
        .op_in(inst_op_in_w[0][1]),
        .op_out(inst_op_out_w[0][1]),
        .gauss_op_in(op_in_w[0][1]),
        .gauss_op_out(op_out_w[0][1]),
        .data_in(data_in_w[0][1]),
        .data_out(data_out_w[0][1]),
        .dataB_in(dataB_in_w[0][1]),
        .dataB_out(dataB_out_w[0][1]),
        .dataA_in(dataA_in_w[0][1]),
        .dataA_out(dataA_out_w[0][1]),
        .r(r_w[0][1])
    );
                    
    // compute_unit(0, 12), (tile(0, 2), unit(0, 2))
                
    assign dataA_in_w[0][2] = dataA_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign data_in_w[0][2] = data_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign op_in_w[0][2] = op_out_w[0][2-1];
    assign inst_op_in_w[0][2] = inst_op_out_w[0][2-1];
    assign dataB_in_w[0][2] = dataB_out_w[0][2-1];
                    
    assign start_in_w[0][2] = start_out_w[0][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(12),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_0_2 (
        .clk(clk),
        .start_in(start_in_w[0][2]),
        .start_out(start_out_w[0][2]),
        .key_data(key_data_w[0][2]),
        .op_in(inst_op_in_w[0][2]),
        .op_out(inst_op_out_w[0][2]),
        .gauss_op_in(op_in_w[0][2]),
        .gauss_op_out(op_out_w[0][2]),
        .data_in(data_in_w[0][2]),
        .data_out(data_out_w[0][2]),
        .dataB_in(dataB_in_w[0][2]),
        .dataB_out(dataB_out_w[0][2]),
        .dataA_in(dataA_in_w[0][2]),
        .dataA_out(dataA_out_w[0][2]),
        .r(r_w[0][2])
    );
                    
    // compute_unit(0, 13), (tile(0, 2), unit(0, 3))
                
    assign dataA_in_w[0][3] = dataA_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign data_in_w[0][3] = data_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign op_in_w[0][3] = op_out_w[0][3-1];
    assign inst_op_in_w[0][3] = inst_op_out_w[0][3-1];
    assign dataB_in_w[0][3] = dataB_out_w[0][3-1];
                    
    assign start_in_w[0][3] = start_out_w[0][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(13),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_0_3 (
        .clk(clk),
        .start_in(start_in_w[0][3]),
        .start_out(start_out_w[0][3]),
        .key_data(key_data_w[0][3]),
        .op_in(inst_op_in_w[0][3]),
        .op_out(inst_op_out_w[0][3]),
        .gauss_op_in(op_in_w[0][3]),
        .gauss_op_out(op_out_w[0][3]),
        .data_in(data_in_w[0][3]),
        .data_out(data_out_w[0][3]),
        .dataB_in(dataB_in_w[0][3]),
        .dataB_out(dataB_out_w[0][3]),
        .dataA_in(dataA_in_w[0][3]),
        .dataA_out(dataA_out_w[0][3]),
        .r(r_w[0][3])
    );
                    
    // compute_unit(0, 14), (tile(0, 2), unit(0, 4))
                
    assign dataA_in_w[0][4] = dataA_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign data_in_w[0][4] = data_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign op_in_w[0][4] = op_out_w[0][4-1];
    assign inst_op_in_w[0][4] = inst_op_out_w[0][4-1];
    assign dataB_in_w[0][4] = dataB_out_w[0][4-1];
                    
    assign start_in_w[0][4] = start_out_w[0][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(14),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_0_4 (
        .clk(clk),
        .start_in(start_in_w[0][4]),
        .start_out(start_out_w[0][4]),
        .key_data(key_data_w[0][4]),
        .op_in(inst_op_in_w[0][4]),
        .op_out(inst_op_out_w[0][4]),
        .gauss_op_in(op_in_w[0][4]),
        .gauss_op_out(op_out_w[0][4]),
        .data_in(data_in_w[0][4]),
        .data_out(data_out_w[0][4]),
        .dataB_in(dataB_in_w[0][4]),
        .dataB_out(dataB_out_w[0][4]),
        .dataA_in(dataA_in_w[0][4]),
        .dataA_out(dataA_out_w[0][4]),
        .r(r_w[0][4])
    );
                    
    // compute_unit(0, 15), (tile(0, 2), unit(0, 5))
                
    assign dataA_in_w[0][5] = dataA_in[GF_BIT*5+(GF_BIT-1):GF_BIT*5];
                    
    assign data_in_w[0][5] = data_in[GF_BIT*5+(GF_BIT-1):GF_BIT*5];
                    
    assign op_in_w[0][5] = op_out_w[0][5-1];
    assign inst_op_in_w[0][5] = inst_op_out_w[0][5-1];
    assign dataB_in_w[0][5] = dataB_out_w[0][5-1];
                    
    assign start_in_w[0][5] = start_out_w[0][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(0),
        .COL_IDX(15),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_0_5 (
        .clk(clk),
        .start_in(start_in_w[0][5]),
        .start_out(start_out_w[0][5]),
        .key_data(key_data_w[0][5]),
        .op_in(inst_op_in_w[0][5]),
        .op_out(inst_op_out_w[0][5]),
        .gauss_op_in(op_in_w[0][5]),
        .gauss_op_out(op_out_w[0][5]),
        .data_in(data_in_w[0][5]),
        .data_out(data_out_w[0][5]),
        .dataB_in(dataB_in_w[0][5]),
        .dataB_out(dataB_out_w[0][5]),
        .dataA_in(dataA_in_w[0][5]),
        .dataA_out(dataA_out_w[0][5]),
        .r(r_w[0][5])
    );
                    
    // compute_unit(1, 10), (tile(0, 2), unit(1, 0))
                
    assign dataA_in_w[1][0] = dataA_out_w[1-1][0];
                    
    assign data_in_w[1][0] = data_out_w[1-1][0];
                    
    assign op_in_w[1][0] = gauss_op_in[2*1+1:2*1];
    assign inst_op_in_w[1][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[1][0] = dataB_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign start_in_w[1][0] = start_row[1];
    assign finish_in_w[1] = finish_row[1];
                    
    always @(posedge clk) begin
        start_tmp[1] <= start_in;
        start_row[1] <= start_tmp[1];
        finish_tmp[1] <= finish_in;
        finish_row[1] <= finish_tmp[1];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(10),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_1_0 (
        .clk(clk),
        .start_in(start_in_w[1][0]),
        .start_out(start_out_w[1][0]),
        .key_data(key_data_w[1][0]),
        .op_in(inst_op_in_w[1][0]),
        .op_out(inst_op_out_w[1][0]),
        .gauss_op_in(op_in_w[1][0]),
        .gauss_op_out(op_out_w[1][0]),
        .data_in(data_in_w[1][0]),
        .data_out(data_out_w[1][0]),
        .dataB_in(dataB_in_w[1][0]),
        .dataB_out(dataB_out_w[1][0]),
        .dataA_in(dataA_in_w[1][0]),
        .dataA_out(dataA_out_w[1][0]),
        .r(r_w[1][0])
    );
                    
    // compute_unit(1, 11), (tile(0, 2), unit(1, 1))
                
    assign dataA_in_w[1][1] = dataA_out_w[1-1][1];
                    
    assign data_in_w[1][1] = data_out_w[1-1][1];
                    
    assign op_in_w[1][1] = op_out_w[1][1-1];
    assign inst_op_in_w[1][1] = inst_op_out_w[1][1-1];
    assign dataB_in_w[1][1] = dataB_out_w[1][1-1];
                    
    assign start_in_w[1][1] = start_out_w[1][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(11),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_1_1 (
        .clk(clk),
        .start_in(start_in_w[1][1]),
        .start_out(start_out_w[1][1]),
        .key_data(key_data_w[1][1]),
        .op_in(inst_op_in_w[1][1]),
        .op_out(inst_op_out_w[1][1]),
        .gauss_op_in(op_in_w[1][1]),
        .gauss_op_out(op_out_w[1][1]),
        .data_in(data_in_w[1][1]),
        .data_out(data_out_w[1][1]),
        .dataB_in(dataB_in_w[1][1]),
        .dataB_out(dataB_out_w[1][1]),
        .dataA_in(dataA_in_w[1][1]),
        .dataA_out(dataA_out_w[1][1]),
        .r(r_w[1][1])
    );
                    
    // compute_unit(1, 12), (tile(0, 2), unit(1, 2))
                
    assign dataA_in_w[1][2] = dataA_out_w[1-1][2];
                    
    assign data_in_w[1][2] = data_out_w[1-1][2];
                    
    assign op_in_w[1][2] = op_out_w[1][2-1];
    assign inst_op_in_w[1][2] = inst_op_out_w[1][2-1];
    assign dataB_in_w[1][2] = dataB_out_w[1][2-1];
                    
    assign start_in_w[1][2] = start_out_w[1][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(12),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_1_2 (
        .clk(clk),
        .start_in(start_in_w[1][2]),
        .start_out(start_out_w[1][2]),
        .key_data(key_data_w[1][2]),
        .op_in(inst_op_in_w[1][2]),
        .op_out(inst_op_out_w[1][2]),
        .gauss_op_in(op_in_w[1][2]),
        .gauss_op_out(op_out_w[1][2]),
        .data_in(data_in_w[1][2]),
        .data_out(data_out_w[1][2]),
        .dataB_in(dataB_in_w[1][2]),
        .dataB_out(dataB_out_w[1][2]),
        .dataA_in(dataA_in_w[1][2]),
        .dataA_out(dataA_out_w[1][2]),
        .r(r_w[1][2])
    );
                    
    // compute_unit(1, 13), (tile(0, 2), unit(1, 3))
                
    assign dataA_in_w[1][3] = dataA_out_w[1-1][3];
                    
    assign data_in_w[1][3] = data_out_w[1-1][3];
                    
    assign op_in_w[1][3] = op_out_w[1][3-1];
    assign inst_op_in_w[1][3] = inst_op_out_w[1][3-1];
    assign dataB_in_w[1][3] = dataB_out_w[1][3-1];
                    
    assign start_in_w[1][3] = start_out_w[1][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(13),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_1_3 (
        .clk(clk),
        .start_in(start_in_w[1][3]),
        .start_out(start_out_w[1][3]),
        .key_data(key_data_w[1][3]),
        .op_in(inst_op_in_w[1][3]),
        .op_out(inst_op_out_w[1][3]),
        .gauss_op_in(op_in_w[1][3]),
        .gauss_op_out(op_out_w[1][3]),
        .data_in(data_in_w[1][3]),
        .data_out(data_out_w[1][3]),
        .dataB_in(dataB_in_w[1][3]),
        .dataB_out(dataB_out_w[1][3]),
        .dataA_in(dataA_in_w[1][3]),
        .dataA_out(dataA_out_w[1][3]),
        .r(r_w[1][3])
    );
                    
    // compute_unit(1, 14), (tile(0, 2), unit(1, 4))
                
    assign dataA_in_w[1][4] = dataA_out_w[1-1][4];
                    
    assign data_in_w[1][4] = data_out_w[1-1][4];
                    
    assign op_in_w[1][4] = op_out_w[1][4-1];
    assign inst_op_in_w[1][4] = inst_op_out_w[1][4-1];
    assign dataB_in_w[1][4] = dataB_out_w[1][4-1];
                    
    assign start_in_w[1][4] = start_out_w[1][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(14),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_1_4 (
        .clk(clk),
        .start_in(start_in_w[1][4]),
        .start_out(start_out_w[1][4]),
        .key_data(key_data_w[1][4]),
        .op_in(inst_op_in_w[1][4]),
        .op_out(inst_op_out_w[1][4]),
        .gauss_op_in(op_in_w[1][4]),
        .gauss_op_out(op_out_w[1][4]),
        .data_in(data_in_w[1][4]),
        .data_out(data_out_w[1][4]),
        .dataB_in(dataB_in_w[1][4]),
        .dataB_out(dataB_out_w[1][4]),
        .dataA_in(dataA_in_w[1][4]),
        .dataA_out(dataA_out_w[1][4]),
        .r(r_w[1][4])
    );
                    
    // compute_unit(1, 15), (tile(0, 2), unit(1, 5))
                
    assign dataA_in_w[1][5] = dataA_out_w[1-1][5];
                    
    assign data_in_w[1][5] = data_out_w[1-1][5];
                    
    assign op_in_w[1][5] = op_out_w[1][5-1];
    assign inst_op_in_w[1][5] = inst_op_out_w[1][5-1];
    assign dataB_in_w[1][5] = dataB_out_w[1][5-1];
                    
    assign start_in_w[1][5] = start_out_w[1][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(1),
        .COL_IDX(15),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_1_5 (
        .clk(clk),
        .start_in(start_in_w[1][5]),
        .start_out(start_out_w[1][5]),
        .key_data(key_data_w[1][5]),
        .op_in(inst_op_in_w[1][5]),
        .op_out(inst_op_out_w[1][5]),
        .gauss_op_in(op_in_w[1][5]),
        .gauss_op_out(op_out_w[1][5]),
        .data_in(data_in_w[1][5]),
        .data_out(data_out_w[1][5]),
        .dataB_in(dataB_in_w[1][5]),
        .dataB_out(dataB_out_w[1][5]),
        .dataA_in(dataA_in_w[1][5]),
        .dataA_out(dataA_out_w[1][5]),
        .r(r_w[1][5])
    );
                    
    // compute_unit(2, 10), (tile(0, 2), unit(2, 0))
                
    assign dataA_in_w[2][0] = dataA_out_w[2-1][0];
                    
    assign data_in_w[2][0] = data_out_w[2-1][0];
                    
    assign op_in_w[2][0] = gauss_op_in[2*2+1:2*2];
    assign inst_op_in_w[2][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[2][0] = dataB_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign start_in_w[2][0] = start_row[2];
    assign finish_in_w[2] = finish_row[2];
                    
    always @(posedge clk) begin
        start_tmp[2] <= start_row[2-1];
        start_row[2] <= start_tmp[2];
        finish_tmp[2] <= finish_row[2-1];
        finish_row[2] <= finish_tmp[2];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(10),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_2_0 (
        .clk(clk),
        .start_in(start_in_w[2][0]),
        .start_out(start_out_w[2][0]),
        .key_data(key_data_w[2][0]),
        .op_in(inst_op_in_w[2][0]),
        .op_out(inst_op_out_w[2][0]),
        .gauss_op_in(op_in_w[2][0]),
        .gauss_op_out(op_out_w[2][0]),
        .data_in(data_in_w[2][0]),
        .data_out(data_out_w[2][0]),
        .dataB_in(dataB_in_w[2][0]),
        .dataB_out(dataB_out_w[2][0]),
        .dataA_in(dataA_in_w[2][0]),
        .dataA_out(dataA_out_w[2][0]),
        .r(r_w[2][0])
    );
                    
    // compute_unit(2, 11), (tile(0, 2), unit(2, 1))
                
    assign dataA_in_w[2][1] = dataA_out_w[2-1][1];
                    
    assign data_in_w[2][1] = data_out_w[2-1][1];
                    
    assign op_in_w[2][1] = op_out_w[2][1-1];
    assign inst_op_in_w[2][1] = inst_op_out_w[2][1-1];
    assign dataB_in_w[2][1] = dataB_out_w[2][1-1];
                    
    assign start_in_w[2][1] = start_out_w[2][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(11),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_2_1 (
        .clk(clk),
        .start_in(start_in_w[2][1]),
        .start_out(start_out_w[2][1]),
        .key_data(key_data_w[2][1]),
        .op_in(inst_op_in_w[2][1]),
        .op_out(inst_op_out_w[2][1]),
        .gauss_op_in(op_in_w[2][1]),
        .gauss_op_out(op_out_w[2][1]),
        .data_in(data_in_w[2][1]),
        .data_out(data_out_w[2][1]),
        .dataB_in(dataB_in_w[2][1]),
        .dataB_out(dataB_out_w[2][1]),
        .dataA_in(dataA_in_w[2][1]),
        .dataA_out(dataA_out_w[2][1]),
        .r(r_w[2][1])
    );
                    
    // compute_unit(2, 12), (tile(0, 2), unit(2, 2))
                
    assign dataA_in_w[2][2] = dataA_out_w[2-1][2];
                    
    assign data_in_w[2][2] = data_out_w[2-1][2];
                    
    assign op_in_w[2][2] = op_out_w[2][2-1];
    assign inst_op_in_w[2][2] = inst_op_out_w[2][2-1];
    assign dataB_in_w[2][2] = dataB_out_w[2][2-1];
                    
    assign start_in_w[2][2] = start_out_w[2][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(12),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_2_2 (
        .clk(clk),
        .start_in(start_in_w[2][2]),
        .start_out(start_out_w[2][2]),
        .key_data(key_data_w[2][2]),
        .op_in(inst_op_in_w[2][2]),
        .op_out(inst_op_out_w[2][2]),
        .gauss_op_in(op_in_w[2][2]),
        .gauss_op_out(op_out_w[2][2]),
        .data_in(data_in_w[2][2]),
        .data_out(data_out_w[2][2]),
        .dataB_in(dataB_in_w[2][2]),
        .dataB_out(dataB_out_w[2][2]),
        .dataA_in(dataA_in_w[2][2]),
        .dataA_out(dataA_out_w[2][2]),
        .r(r_w[2][2])
    );
                    
    // compute_unit(2, 13), (tile(0, 2), unit(2, 3))
                
    assign dataA_in_w[2][3] = dataA_out_w[2-1][3];
                    
    assign data_in_w[2][3] = data_out_w[2-1][3];
                    
    assign op_in_w[2][3] = op_out_w[2][3-1];
    assign inst_op_in_w[2][3] = inst_op_out_w[2][3-1];
    assign dataB_in_w[2][3] = dataB_out_w[2][3-1];
                    
    assign start_in_w[2][3] = start_out_w[2][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(13),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_2_3 (
        .clk(clk),
        .start_in(start_in_w[2][3]),
        .start_out(start_out_w[2][3]),
        .key_data(key_data_w[2][3]),
        .op_in(inst_op_in_w[2][3]),
        .op_out(inst_op_out_w[2][3]),
        .gauss_op_in(op_in_w[2][3]),
        .gauss_op_out(op_out_w[2][3]),
        .data_in(data_in_w[2][3]),
        .data_out(data_out_w[2][3]),
        .dataB_in(dataB_in_w[2][3]),
        .dataB_out(dataB_out_w[2][3]),
        .dataA_in(dataA_in_w[2][3]),
        .dataA_out(dataA_out_w[2][3]),
        .r(r_w[2][3])
    );
                    
    // compute_unit(2, 14), (tile(0, 2), unit(2, 4))
                
    assign dataA_in_w[2][4] = dataA_out_w[2-1][4];
                    
    assign data_in_w[2][4] = data_out_w[2-1][4];
                    
    assign op_in_w[2][4] = op_out_w[2][4-1];
    assign inst_op_in_w[2][4] = inst_op_out_w[2][4-1];
    assign dataB_in_w[2][4] = dataB_out_w[2][4-1];
                    
    assign start_in_w[2][4] = start_out_w[2][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(14),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_2_4 (
        .clk(clk),
        .start_in(start_in_w[2][4]),
        .start_out(start_out_w[2][4]),
        .key_data(key_data_w[2][4]),
        .op_in(inst_op_in_w[2][4]),
        .op_out(inst_op_out_w[2][4]),
        .gauss_op_in(op_in_w[2][4]),
        .gauss_op_out(op_out_w[2][4]),
        .data_in(data_in_w[2][4]),
        .data_out(data_out_w[2][4]),
        .dataB_in(dataB_in_w[2][4]),
        .dataB_out(dataB_out_w[2][4]),
        .dataA_in(dataA_in_w[2][4]),
        .dataA_out(dataA_out_w[2][4]),
        .r(r_w[2][4])
    );
                    
    // compute_unit(2, 15), (tile(0, 2), unit(2, 5))
                
    assign dataA_in_w[2][5] = dataA_out_w[2-1][5];
                    
    assign data_in_w[2][5] = data_out_w[2-1][5];
                    
    assign op_in_w[2][5] = op_out_w[2][5-1];
    assign inst_op_in_w[2][5] = inst_op_out_w[2][5-1];
    assign dataB_in_w[2][5] = dataB_out_w[2][5-1];
                    
    assign start_in_w[2][5] = start_out_w[2][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(2),
        .COL_IDX(15),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_2_5 (
        .clk(clk),
        .start_in(start_in_w[2][5]),
        .start_out(start_out_w[2][5]),
        .key_data(key_data_w[2][5]),
        .op_in(inst_op_in_w[2][5]),
        .op_out(inst_op_out_w[2][5]),
        .gauss_op_in(op_in_w[2][5]),
        .gauss_op_out(op_out_w[2][5]),
        .data_in(data_in_w[2][5]),
        .data_out(data_out_w[2][5]),
        .dataB_in(dataB_in_w[2][5]),
        .dataB_out(dataB_out_w[2][5]),
        .dataA_in(dataA_in_w[2][5]),
        .dataA_out(dataA_out_w[2][5]),
        .r(r_w[2][5])
    );
                    
    // compute_unit(3, 10), (tile(0, 2), unit(3, 0))
                
    assign dataA_in_w[3][0] = dataA_out_w[3-1][0];
                    
    assign data_in_w[3][0] = data_out_w[3-1][0];
                    
    assign op_in_w[3][0] = gauss_op_in[2*3+1:2*3];
    assign inst_op_in_w[3][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[3][0] = dataB_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign start_in_w[3][0] = start_row[3];
    assign finish_in_w[3] = finish_row[3];
                    
    always @(posedge clk) begin
        start_tmp[3] <= start_row[3-1];
        start_row[3] <= start_tmp[3];
        finish_tmp[3] <= finish_row[3-1];
        finish_row[3] <= finish_tmp[3];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(10),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_3_0 (
        .clk(clk),
        .start_in(start_in_w[3][0]),
        .start_out(start_out_w[3][0]),
        .key_data(key_data_w[3][0]),
        .op_in(inst_op_in_w[3][0]),
        .op_out(inst_op_out_w[3][0]),
        .gauss_op_in(op_in_w[3][0]),
        .gauss_op_out(op_out_w[3][0]),
        .data_in(data_in_w[3][0]),
        .data_out(data_out_w[3][0]),
        .dataB_in(dataB_in_w[3][0]),
        .dataB_out(dataB_out_w[3][0]),
        .dataA_in(dataA_in_w[3][0]),
        .dataA_out(dataA_out_w[3][0]),
        .r(r_w[3][0])
    );
                    
    // compute_unit(3, 11), (tile(0, 2), unit(3, 1))
                
    assign dataA_in_w[3][1] = dataA_out_w[3-1][1];
                    
    assign data_in_w[3][1] = data_out_w[3-1][1];
                    
    assign op_in_w[3][1] = op_out_w[3][1-1];
    assign inst_op_in_w[3][1] = inst_op_out_w[3][1-1];
    assign dataB_in_w[3][1] = dataB_out_w[3][1-1];
                    
    assign start_in_w[3][1] = start_out_w[3][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(11),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_3_1 (
        .clk(clk),
        .start_in(start_in_w[3][1]),
        .start_out(start_out_w[3][1]),
        .key_data(key_data_w[3][1]),
        .op_in(inst_op_in_w[3][1]),
        .op_out(inst_op_out_w[3][1]),
        .gauss_op_in(op_in_w[3][1]),
        .gauss_op_out(op_out_w[3][1]),
        .data_in(data_in_w[3][1]),
        .data_out(data_out_w[3][1]),
        .dataB_in(dataB_in_w[3][1]),
        .dataB_out(dataB_out_w[3][1]),
        .dataA_in(dataA_in_w[3][1]),
        .dataA_out(dataA_out_w[3][1]),
        .r(r_w[3][1])
    );
                    
    // compute_unit(3, 12), (tile(0, 2), unit(3, 2))
                
    assign dataA_in_w[3][2] = dataA_out_w[3-1][2];
                    
    assign data_in_w[3][2] = data_out_w[3-1][2];
                    
    assign op_in_w[3][2] = op_out_w[3][2-1];
    assign inst_op_in_w[3][2] = inst_op_out_w[3][2-1];
    assign dataB_in_w[3][2] = dataB_out_w[3][2-1];
                    
    assign start_in_w[3][2] = start_out_w[3][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(12),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_3_2 (
        .clk(clk),
        .start_in(start_in_w[3][2]),
        .start_out(start_out_w[3][2]),
        .key_data(key_data_w[3][2]),
        .op_in(inst_op_in_w[3][2]),
        .op_out(inst_op_out_w[3][2]),
        .gauss_op_in(op_in_w[3][2]),
        .gauss_op_out(op_out_w[3][2]),
        .data_in(data_in_w[3][2]),
        .data_out(data_out_w[3][2]),
        .dataB_in(dataB_in_w[3][2]),
        .dataB_out(dataB_out_w[3][2]),
        .dataA_in(dataA_in_w[3][2]),
        .dataA_out(dataA_out_w[3][2]),
        .r(r_w[3][2])
    );
                    
    // compute_unit(3, 13), (tile(0, 2), unit(3, 3))
                
    assign dataA_in_w[3][3] = dataA_out_w[3-1][3];
                    
    assign data_in_w[3][3] = data_out_w[3-1][3];
                    
    assign op_in_w[3][3] = op_out_w[3][3-1];
    assign inst_op_in_w[3][3] = inst_op_out_w[3][3-1];
    assign dataB_in_w[3][3] = dataB_out_w[3][3-1];
                    
    assign start_in_w[3][3] = start_out_w[3][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(13),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_3_3 (
        .clk(clk),
        .start_in(start_in_w[3][3]),
        .start_out(start_out_w[3][3]),
        .key_data(key_data_w[3][3]),
        .op_in(inst_op_in_w[3][3]),
        .op_out(inst_op_out_w[3][3]),
        .gauss_op_in(op_in_w[3][3]),
        .gauss_op_out(op_out_w[3][3]),
        .data_in(data_in_w[3][3]),
        .data_out(data_out_w[3][3]),
        .dataB_in(dataB_in_w[3][3]),
        .dataB_out(dataB_out_w[3][3]),
        .dataA_in(dataA_in_w[3][3]),
        .dataA_out(dataA_out_w[3][3]),
        .r(r_w[3][3])
    );
                    
    // compute_unit(3, 14), (tile(0, 2), unit(3, 4))
                
    assign dataA_in_w[3][4] = dataA_out_w[3-1][4];
                    
    assign data_in_w[3][4] = data_out_w[3-1][4];
                    
    assign op_in_w[3][4] = op_out_w[3][4-1];
    assign inst_op_in_w[3][4] = inst_op_out_w[3][4-1];
    assign dataB_in_w[3][4] = dataB_out_w[3][4-1];
                    
    assign start_in_w[3][4] = start_out_w[3][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(14),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_3_4 (
        .clk(clk),
        .start_in(start_in_w[3][4]),
        .start_out(start_out_w[3][4]),
        .key_data(key_data_w[3][4]),
        .op_in(inst_op_in_w[3][4]),
        .op_out(inst_op_out_w[3][4]),
        .gauss_op_in(op_in_w[3][4]),
        .gauss_op_out(op_out_w[3][4]),
        .data_in(data_in_w[3][4]),
        .data_out(data_out_w[3][4]),
        .dataB_in(dataB_in_w[3][4]),
        .dataB_out(dataB_out_w[3][4]),
        .dataA_in(dataA_in_w[3][4]),
        .dataA_out(dataA_out_w[3][4]),
        .r(r_w[3][4])
    );
                    
    // compute_unit(3, 15), (tile(0, 2), unit(3, 5))
                
    assign dataA_in_w[3][5] = dataA_out_w[3-1][5];
                    
    assign data_in_w[3][5] = data_out_w[3-1][5];
                    
    assign op_in_w[3][5] = op_out_w[3][5-1];
    assign inst_op_in_w[3][5] = inst_op_out_w[3][5-1];
    assign dataB_in_w[3][5] = dataB_out_w[3][5-1];
                    
    assign start_in_w[3][5] = start_out_w[3][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(3),
        .COL_IDX(15),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_3_5 (
        .clk(clk),
        .start_in(start_in_w[3][5]),
        .start_out(start_out_w[3][5]),
        .key_data(key_data_w[3][5]),
        .op_in(inst_op_in_w[3][5]),
        .op_out(inst_op_out_w[3][5]),
        .gauss_op_in(op_in_w[3][5]),
        .gauss_op_out(op_out_w[3][5]),
        .data_in(data_in_w[3][5]),
        .data_out(data_out_w[3][5]),
        .dataB_in(dataB_in_w[3][5]),
        .dataB_out(dataB_out_w[3][5]),
        .dataA_in(dataA_in_w[3][5]),
        .dataA_out(dataA_out_w[3][5]),
        .r(r_w[3][5])
    );
                    
    // compute_unit(4, 10), (tile(0, 2), unit(4, 0))
                
    assign dataA_in_w[4][0] = dataA_out_w[4-1][0];
                    
    assign data_in_w[4][0] = data_out_w[4-1][0];
                    
    assign op_in_w[4][0] = gauss_op_in[2*4+1:2*4];
    assign inst_op_in_w[4][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[4][0] = dataB_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign start_in_w[4][0] = start_row[4];
    assign finish_in_w[4] = finish_row[4];
                    
    always @(posedge clk) begin
        start_tmp[4] <= start_row[4-1];
        start_row[4] <= start_tmp[4];
        finish_tmp[4] <= finish_row[4-1];
        finish_row[4] <= finish_tmp[4];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(10),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_4_0 (
        .clk(clk),
        .start_in(start_in_w[4][0]),
        .start_out(start_out_w[4][0]),
        .key_data(key_data_w[4][0]),
        .op_in(inst_op_in_w[4][0]),
        .op_out(inst_op_out_w[4][0]),
        .gauss_op_in(op_in_w[4][0]),
        .gauss_op_out(op_out_w[4][0]),
        .data_in(data_in_w[4][0]),
        .data_out(data_out_w[4][0]),
        .dataB_in(dataB_in_w[4][0]),
        .dataB_out(dataB_out_w[4][0]),
        .dataA_in(dataA_in_w[4][0]),
        .dataA_out(dataA_out_w[4][0]),
        .r(r_w[4][0])
    );
                    
    // compute_unit(4, 11), (tile(0, 2), unit(4, 1))
                
    assign dataA_in_w[4][1] = dataA_out_w[4-1][1];
                    
    assign data_in_w[4][1] = data_out_w[4-1][1];
                    
    assign op_in_w[4][1] = op_out_w[4][1-1];
    assign inst_op_in_w[4][1] = inst_op_out_w[4][1-1];
    assign dataB_in_w[4][1] = dataB_out_w[4][1-1];
                    
    assign start_in_w[4][1] = start_out_w[4][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(11),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_4_1 (
        .clk(clk),
        .start_in(start_in_w[4][1]),
        .start_out(start_out_w[4][1]),
        .key_data(key_data_w[4][1]),
        .op_in(inst_op_in_w[4][1]),
        .op_out(inst_op_out_w[4][1]),
        .gauss_op_in(op_in_w[4][1]),
        .gauss_op_out(op_out_w[4][1]),
        .data_in(data_in_w[4][1]),
        .data_out(data_out_w[4][1]),
        .dataB_in(dataB_in_w[4][1]),
        .dataB_out(dataB_out_w[4][1]),
        .dataA_in(dataA_in_w[4][1]),
        .dataA_out(dataA_out_w[4][1]),
        .r(r_w[4][1])
    );
                    
    // compute_unit(4, 12), (tile(0, 2), unit(4, 2))
                
    assign dataA_in_w[4][2] = dataA_out_w[4-1][2];
                    
    assign data_in_w[4][2] = data_out_w[4-1][2];
                    
    assign op_in_w[4][2] = op_out_w[4][2-1];
    assign inst_op_in_w[4][2] = inst_op_out_w[4][2-1];
    assign dataB_in_w[4][2] = dataB_out_w[4][2-1];
                    
    assign start_in_w[4][2] = start_out_w[4][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(12),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_4_2 (
        .clk(clk),
        .start_in(start_in_w[4][2]),
        .start_out(start_out_w[4][2]),
        .key_data(key_data_w[4][2]),
        .op_in(inst_op_in_w[4][2]),
        .op_out(inst_op_out_w[4][2]),
        .gauss_op_in(op_in_w[4][2]),
        .gauss_op_out(op_out_w[4][2]),
        .data_in(data_in_w[4][2]),
        .data_out(data_out_w[4][2]),
        .dataB_in(dataB_in_w[4][2]),
        .dataB_out(dataB_out_w[4][2]),
        .dataA_in(dataA_in_w[4][2]),
        .dataA_out(dataA_out_w[4][2]),
        .r(r_w[4][2])
    );
                    
    // compute_unit(4, 13), (tile(0, 2), unit(4, 3))
                
    assign dataA_in_w[4][3] = dataA_out_w[4-1][3];
                    
    assign data_in_w[4][3] = data_out_w[4-1][3];
                    
    assign op_in_w[4][3] = op_out_w[4][3-1];
    assign inst_op_in_w[4][3] = inst_op_out_w[4][3-1];
    assign dataB_in_w[4][3] = dataB_out_w[4][3-1];
                    
    assign start_in_w[4][3] = start_out_w[4][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(13),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_4_3 (
        .clk(clk),
        .start_in(start_in_w[4][3]),
        .start_out(start_out_w[4][3]),
        .key_data(key_data_w[4][3]),
        .op_in(inst_op_in_w[4][3]),
        .op_out(inst_op_out_w[4][3]),
        .gauss_op_in(op_in_w[4][3]),
        .gauss_op_out(op_out_w[4][3]),
        .data_in(data_in_w[4][3]),
        .data_out(data_out_w[4][3]),
        .dataB_in(dataB_in_w[4][3]),
        .dataB_out(dataB_out_w[4][3]),
        .dataA_in(dataA_in_w[4][3]),
        .dataA_out(dataA_out_w[4][3]),
        .r(r_w[4][3])
    );
                    
    // compute_unit(4, 14), (tile(0, 2), unit(4, 4))
                
    assign dataA_in_w[4][4] = dataA_out_w[4-1][4];
                    
    assign data_in_w[4][4] = data_out_w[4-1][4];
                    
    assign op_in_w[4][4] = op_out_w[4][4-1];
    assign inst_op_in_w[4][4] = inst_op_out_w[4][4-1];
    assign dataB_in_w[4][4] = dataB_out_w[4][4-1];
                    
    assign start_in_w[4][4] = start_out_w[4][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(14),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_4_4 (
        .clk(clk),
        .start_in(start_in_w[4][4]),
        .start_out(start_out_w[4][4]),
        .key_data(key_data_w[4][4]),
        .op_in(inst_op_in_w[4][4]),
        .op_out(inst_op_out_w[4][4]),
        .gauss_op_in(op_in_w[4][4]),
        .gauss_op_out(op_out_w[4][4]),
        .data_in(data_in_w[4][4]),
        .data_out(data_out_w[4][4]),
        .dataB_in(dataB_in_w[4][4]),
        .dataB_out(dataB_out_w[4][4]),
        .dataA_in(dataA_in_w[4][4]),
        .dataA_out(dataA_out_w[4][4]),
        .r(r_w[4][4])
    );
                    
    // compute_unit(4, 15), (tile(0, 2), unit(4, 5))
                
    assign dataA_in_w[4][5] = dataA_out_w[4-1][5];
                    
    assign data_in_w[4][5] = data_out_w[4-1][5];
                    
    assign op_in_w[4][5] = op_out_w[4][5-1];
    assign inst_op_in_w[4][5] = inst_op_out_w[4][5-1];
    assign dataB_in_w[4][5] = dataB_out_w[4][5-1];
                    
    assign start_in_w[4][5] = start_out_w[4][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(4),
        .COL_IDX(15),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_4_5 (
        .clk(clk),
        .start_in(start_in_w[4][5]),
        .start_out(start_out_w[4][5]),
        .key_data(key_data_w[4][5]),
        .op_in(inst_op_in_w[4][5]),
        .op_out(inst_op_out_w[4][5]),
        .gauss_op_in(op_in_w[4][5]),
        .gauss_op_out(op_out_w[4][5]),
        .data_in(data_in_w[4][5]),
        .data_out(data_out_w[4][5]),
        .dataB_in(dataB_in_w[4][5]),
        .dataB_out(dataB_out_w[4][5]),
        .dataA_in(dataA_in_w[4][5]),
        .dataA_out(dataA_out_w[4][5]),
        .r(r_w[4][5])
    );
                    
    // compute_unit(5, 10), (tile(0, 2), unit(5, 0))
                
    assign dataA_in_w[5][0] = dataA_out_w[5-1][0];
                    
    assign data_in_w[5][0] = data_out_w[5-1][0];
                    
    assign op_in_w[5][0] = gauss_op_in[2*5+1:2*5];
    assign inst_op_in_w[5][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[5][0] = dataB_in[GF_BIT*5+(GF_BIT-1):GF_BIT*5];
                    
    assign start_in_w[5][0] = start_row[5];
    assign finish_in_w[5] = finish_row[5];
                    
    always @(posedge clk) begin
        start_tmp[5] <= start_row[5-1];
        start_row[5] <= start_tmp[5];
        finish_tmp[5] <= finish_row[5-1];
        finish_row[5] <= finish_tmp[5];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(10),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_5_0 (
        .clk(clk),
        .start_in(start_in_w[5][0]),
        .start_out(start_out_w[5][0]),
        .key_data(key_data_w[5][0]),
        .op_in(inst_op_in_w[5][0]),
        .op_out(inst_op_out_w[5][0]),
        .gauss_op_in(op_in_w[5][0]),
        .gauss_op_out(op_out_w[5][0]),
        .data_in(data_in_w[5][0]),
        .data_out(data_out_w[5][0]),
        .dataB_in(dataB_in_w[5][0]),
        .dataB_out(dataB_out_w[5][0]),
        .dataA_in(dataA_in_w[5][0]),
        .dataA_out(dataA_out_w[5][0]),
        .r(r_w[5][0])
    );
                    
    // compute_unit(5, 11), (tile(0, 2), unit(5, 1))
                
    assign dataA_in_w[5][1] = dataA_out_w[5-1][1];
                    
    assign data_in_w[5][1] = data_out_w[5-1][1];
                    
    assign op_in_w[5][1] = op_out_w[5][1-1];
    assign inst_op_in_w[5][1] = inst_op_out_w[5][1-1];
    assign dataB_in_w[5][1] = dataB_out_w[5][1-1];
                    
    assign start_in_w[5][1] = start_out_w[5][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(11),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_5_1 (
        .clk(clk),
        .start_in(start_in_w[5][1]),
        .start_out(start_out_w[5][1]),
        .key_data(key_data_w[5][1]),
        .op_in(inst_op_in_w[5][1]),
        .op_out(inst_op_out_w[5][1]),
        .gauss_op_in(op_in_w[5][1]),
        .gauss_op_out(op_out_w[5][1]),
        .data_in(data_in_w[5][1]),
        .data_out(data_out_w[5][1]),
        .dataB_in(dataB_in_w[5][1]),
        .dataB_out(dataB_out_w[5][1]),
        .dataA_in(dataA_in_w[5][1]),
        .dataA_out(dataA_out_w[5][1]),
        .r(r_w[5][1])
    );
                    
    // compute_unit(5, 12), (tile(0, 2), unit(5, 2))
                
    assign dataA_in_w[5][2] = dataA_out_w[5-1][2];
                    
    assign data_in_w[5][2] = data_out_w[5-1][2];
                    
    assign op_in_w[5][2] = op_out_w[5][2-1];
    assign inst_op_in_w[5][2] = inst_op_out_w[5][2-1];
    assign dataB_in_w[5][2] = dataB_out_w[5][2-1];
                    
    assign start_in_w[5][2] = start_out_w[5][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(12),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_5_2 (
        .clk(clk),
        .start_in(start_in_w[5][2]),
        .start_out(start_out_w[5][2]),
        .key_data(key_data_w[5][2]),
        .op_in(inst_op_in_w[5][2]),
        .op_out(inst_op_out_w[5][2]),
        .gauss_op_in(op_in_w[5][2]),
        .gauss_op_out(op_out_w[5][2]),
        .data_in(data_in_w[5][2]),
        .data_out(data_out_w[5][2]),
        .dataB_in(dataB_in_w[5][2]),
        .dataB_out(dataB_out_w[5][2]),
        .dataA_in(dataA_in_w[5][2]),
        .dataA_out(dataA_out_w[5][2]),
        .r(r_w[5][2])
    );
                    
    // compute_unit(5, 13), (tile(0, 2), unit(5, 3))
                
    assign dataA_in_w[5][3] = dataA_out_w[5-1][3];
                    
    assign data_in_w[5][3] = data_out_w[5-1][3];
                    
    assign op_in_w[5][3] = op_out_w[5][3-1];
    assign inst_op_in_w[5][3] = inst_op_out_w[5][3-1];
    assign dataB_in_w[5][3] = dataB_out_w[5][3-1];
                    
    assign start_in_w[5][3] = start_out_w[5][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(13),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_5_3 (
        .clk(clk),
        .start_in(start_in_w[5][3]),
        .start_out(start_out_w[5][3]),
        .key_data(key_data_w[5][3]),
        .op_in(inst_op_in_w[5][3]),
        .op_out(inst_op_out_w[5][3]),
        .gauss_op_in(op_in_w[5][3]),
        .gauss_op_out(op_out_w[5][3]),
        .data_in(data_in_w[5][3]),
        .data_out(data_out_w[5][3]),
        .dataB_in(dataB_in_w[5][3]),
        .dataB_out(dataB_out_w[5][3]),
        .dataA_in(dataA_in_w[5][3]),
        .dataA_out(dataA_out_w[5][3]),
        .r(r_w[5][3])
    );
                    
    // compute_unit(5, 14), (tile(0, 2), unit(5, 4))
                
    assign dataA_in_w[5][4] = dataA_out_w[5-1][4];
                    
    assign data_in_w[5][4] = data_out_w[5-1][4];
                    
    assign op_in_w[5][4] = op_out_w[5][4-1];
    assign inst_op_in_w[5][4] = inst_op_out_w[5][4-1];
    assign dataB_in_w[5][4] = dataB_out_w[5][4-1];
                    
    assign start_in_w[5][4] = start_out_w[5][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(14),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_5_4 (
        .clk(clk),
        .start_in(start_in_w[5][4]),
        .start_out(start_out_w[5][4]),
        .key_data(key_data_w[5][4]),
        .op_in(inst_op_in_w[5][4]),
        .op_out(inst_op_out_w[5][4]),
        .gauss_op_in(op_in_w[5][4]),
        .gauss_op_out(op_out_w[5][4]),
        .data_in(data_in_w[5][4]),
        .data_out(data_out_w[5][4]),
        .dataB_in(dataB_in_w[5][4]),
        .dataB_out(dataB_out_w[5][4]),
        .dataA_in(dataA_in_w[5][4]),
        .dataA_out(dataA_out_w[5][4]),
        .r(r_w[5][4])
    );
                    
    // compute_unit(5, 15), (tile(0, 2), unit(5, 5))
                
    assign dataA_in_w[5][5] = dataA_out_w[5-1][5];
                    
    assign data_in_w[5][5] = data_out_w[5-1][5];
                    
    assign op_in_w[5][5] = op_out_w[5][5-1];
    assign inst_op_in_w[5][5] = inst_op_out_w[5][5-1];
    assign dataB_in_w[5][5] = dataB_out_w[5][5-1];
                    
    assign start_in_w[5][5] = start_out_w[5][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(5),
        .COL_IDX(15),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_5_5 (
        .clk(clk),
        .start_in(start_in_w[5][5]),
        .start_out(start_out_w[5][5]),
        .key_data(key_data_w[5][5]),
        .op_in(inst_op_in_w[5][5]),
        .op_out(inst_op_out_w[5][5]),
        .gauss_op_in(op_in_w[5][5]),
        .gauss_op_out(op_out_w[5][5]),
        .data_in(data_in_w[5][5]),
        .data_out(data_out_w[5][5]),
        .dataB_in(dataB_in_w[5][5]),
        .dataB_out(dataB_out_w[5][5]),
        .dataA_in(dataA_in_w[5][5]),
        .dataA_out(dataA_out_w[5][5]),
        .r(r_w[5][5])
    );
                    
    // compute_unit(6, 10), (tile(0, 2), unit(6, 0))
                
    assign dataA_in_w[6][0] = dataA_out_w[6-1][0];
                    
    assign data_in_w[6][0] = data_out_w[6-1][0];
                    
    assign op_in_w[6][0] = gauss_op_in[2*6+1:2*6];
    assign inst_op_in_w[6][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[6][0] = dataB_in[GF_BIT*6+(GF_BIT-1):GF_BIT*6];
                    
    assign start_in_w[6][0] = start_row[6];
    assign finish_in_w[6] = finish_row[6];
                    
    always @(posedge clk) begin
        start_tmp[6] <= start_row[6-1];
        start_row[6] <= start_tmp[6];
        finish_tmp[6] <= finish_row[6-1];
        finish_row[6] <= finish_tmp[6];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(10),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_6_0 (
        .clk(clk),
        .start_in(start_in_w[6][0]),
        .start_out(start_out_w[6][0]),
        .key_data(key_data_w[6][0]),
        .op_in(inst_op_in_w[6][0]),
        .op_out(inst_op_out_w[6][0]),
        .gauss_op_in(op_in_w[6][0]),
        .gauss_op_out(op_out_w[6][0]),
        .data_in(data_in_w[6][0]),
        .data_out(data_out_w[6][0]),
        .dataB_in(dataB_in_w[6][0]),
        .dataB_out(dataB_out_w[6][0]),
        .dataA_in(dataA_in_w[6][0]),
        .dataA_out(dataA_out_w[6][0]),
        .r(r_w[6][0])
    );
                    
    // compute_unit(6, 11), (tile(0, 2), unit(6, 1))
                
    assign dataA_in_w[6][1] = dataA_out_w[6-1][1];
                    
    assign data_in_w[6][1] = data_out_w[6-1][1];
                    
    assign op_in_w[6][1] = op_out_w[6][1-1];
    assign inst_op_in_w[6][1] = inst_op_out_w[6][1-1];
    assign dataB_in_w[6][1] = dataB_out_w[6][1-1];
                    
    assign start_in_w[6][1] = start_out_w[6][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(11),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_6_1 (
        .clk(clk),
        .start_in(start_in_w[6][1]),
        .start_out(start_out_w[6][1]),
        .key_data(key_data_w[6][1]),
        .op_in(inst_op_in_w[6][1]),
        .op_out(inst_op_out_w[6][1]),
        .gauss_op_in(op_in_w[6][1]),
        .gauss_op_out(op_out_w[6][1]),
        .data_in(data_in_w[6][1]),
        .data_out(data_out_w[6][1]),
        .dataB_in(dataB_in_w[6][1]),
        .dataB_out(dataB_out_w[6][1]),
        .dataA_in(dataA_in_w[6][1]),
        .dataA_out(dataA_out_w[6][1]),
        .r(r_w[6][1])
    );
                    
    // compute_unit(6, 12), (tile(0, 2), unit(6, 2))
                
    assign dataA_in_w[6][2] = dataA_out_w[6-1][2];
                    
    assign data_in_w[6][2] = data_out_w[6-1][2];
                    
    assign op_in_w[6][2] = op_out_w[6][2-1];
    assign inst_op_in_w[6][2] = inst_op_out_w[6][2-1];
    assign dataB_in_w[6][2] = dataB_out_w[6][2-1];
                    
    assign start_in_w[6][2] = start_out_w[6][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(12),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_6_2 (
        .clk(clk),
        .start_in(start_in_w[6][2]),
        .start_out(start_out_w[6][2]),
        .key_data(key_data_w[6][2]),
        .op_in(inst_op_in_w[6][2]),
        .op_out(inst_op_out_w[6][2]),
        .gauss_op_in(op_in_w[6][2]),
        .gauss_op_out(op_out_w[6][2]),
        .data_in(data_in_w[6][2]),
        .data_out(data_out_w[6][2]),
        .dataB_in(dataB_in_w[6][2]),
        .dataB_out(dataB_out_w[6][2]),
        .dataA_in(dataA_in_w[6][2]),
        .dataA_out(dataA_out_w[6][2]),
        .r(r_w[6][2])
    );
                    
    // compute_unit(6, 13), (tile(0, 2), unit(6, 3))
                
    assign dataA_in_w[6][3] = dataA_out_w[6-1][3];
                    
    assign data_in_w[6][3] = data_out_w[6-1][3];
                    
    assign op_in_w[6][3] = op_out_w[6][3-1];
    assign inst_op_in_w[6][3] = inst_op_out_w[6][3-1];
    assign dataB_in_w[6][3] = dataB_out_w[6][3-1];
                    
    assign start_in_w[6][3] = start_out_w[6][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(13),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_6_3 (
        .clk(clk),
        .start_in(start_in_w[6][3]),
        .start_out(start_out_w[6][3]),
        .key_data(key_data_w[6][3]),
        .op_in(inst_op_in_w[6][3]),
        .op_out(inst_op_out_w[6][3]),
        .gauss_op_in(op_in_w[6][3]),
        .gauss_op_out(op_out_w[6][3]),
        .data_in(data_in_w[6][3]),
        .data_out(data_out_w[6][3]),
        .dataB_in(dataB_in_w[6][3]),
        .dataB_out(dataB_out_w[6][3]),
        .dataA_in(dataA_in_w[6][3]),
        .dataA_out(dataA_out_w[6][3]),
        .r(r_w[6][3])
    );
                    
    // compute_unit(6, 14), (tile(0, 2), unit(6, 4))
                
    assign dataA_in_w[6][4] = dataA_out_w[6-1][4];
                    
    assign data_in_w[6][4] = data_out_w[6-1][4];
                    
    assign op_in_w[6][4] = op_out_w[6][4-1];
    assign inst_op_in_w[6][4] = inst_op_out_w[6][4-1];
    assign dataB_in_w[6][4] = dataB_out_w[6][4-1];
                    
    assign start_in_w[6][4] = start_out_w[6][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(14),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_6_4 (
        .clk(clk),
        .start_in(start_in_w[6][4]),
        .start_out(start_out_w[6][4]),
        .key_data(key_data_w[6][4]),
        .op_in(inst_op_in_w[6][4]),
        .op_out(inst_op_out_w[6][4]),
        .gauss_op_in(op_in_w[6][4]),
        .gauss_op_out(op_out_w[6][4]),
        .data_in(data_in_w[6][4]),
        .data_out(data_out_w[6][4]),
        .dataB_in(dataB_in_w[6][4]),
        .dataB_out(dataB_out_w[6][4]),
        .dataA_in(dataA_in_w[6][4]),
        .dataA_out(dataA_out_w[6][4]),
        .r(r_w[6][4])
    );
                    
    // compute_unit(6, 15), (tile(0, 2), unit(6, 5))
                
    assign dataA_in_w[6][5] = dataA_out_w[6-1][5];
                    
    assign data_in_w[6][5] = data_out_w[6-1][5];
                    
    assign op_in_w[6][5] = op_out_w[6][5-1];
    assign inst_op_in_w[6][5] = inst_op_out_w[6][5-1];
    assign dataB_in_w[6][5] = dataB_out_w[6][5-1];
                    
    assign start_in_w[6][5] = start_out_w[6][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(6),
        .COL_IDX(15),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_6_5 (
        .clk(clk),
        .start_in(start_in_w[6][5]),
        .start_out(start_out_w[6][5]),
        .key_data(key_data_w[6][5]),
        .op_in(inst_op_in_w[6][5]),
        .op_out(inst_op_out_w[6][5]),
        .gauss_op_in(op_in_w[6][5]),
        .gauss_op_out(op_out_w[6][5]),
        .data_in(data_in_w[6][5]),
        .data_out(data_out_w[6][5]),
        .dataB_in(dataB_in_w[6][5]),
        .dataB_out(dataB_out_w[6][5]),
        .dataA_in(dataA_in_w[6][5]),
        .dataA_out(dataA_out_w[6][5]),
        .r(r_w[6][5])
    );
                    
    // compute_unit(7, 10), (tile(0, 2), unit(7, 0))
                
    assign dataA_in_w[7][0] = dataA_out_w[7-1][0];
                    
    assign data_in_w[7][0] = data_out_w[7-1][0];
                    
    assign op_in_w[7][0] = gauss_op_in[2*7+1:2*7];
    assign inst_op_in_w[7][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[7][0] = dataB_in[GF_BIT*7+(GF_BIT-1):GF_BIT*7];
                    
    assign start_in_w[7][0] = start_row[7];
    assign finish_in_w[7] = finish_row[7];
                    
    always @(posedge clk) begin
        start_tmp[7] <= start_row[7-1];
        start_row[7] <= start_tmp[7];
        finish_tmp[7] <= finish_row[7-1];
        finish_row[7] <= finish_tmp[7];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(10),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_7_0 (
        .clk(clk),
        .start_in(start_in_w[7][0]),
        .start_out(start_out_w[7][0]),
        .key_data(key_data_w[7][0]),
        .op_in(inst_op_in_w[7][0]),
        .op_out(inst_op_out_w[7][0]),
        .gauss_op_in(op_in_w[7][0]),
        .gauss_op_out(op_out_w[7][0]),
        .data_in(data_in_w[7][0]),
        .data_out(data_out_w[7][0]),
        .dataB_in(dataB_in_w[7][0]),
        .dataB_out(dataB_out_w[7][0]),
        .dataA_in(dataA_in_w[7][0]),
        .dataA_out(dataA_out_w[7][0]),
        .r(r_w[7][0])
    );
                    
    // compute_unit(7, 11), (tile(0, 2), unit(7, 1))
                
    assign dataA_in_w[7][1] = dataA_out_w[7-1][1];
                    
    assign data_in_w[7][1] = data_out_w[7-1][1];
                    
    assign op_in_w[7][1] = op_out_w[7][1-1];
    assign inst_op_in_w[7][1] = inst_op_out_w[7][1-1];
    assign dataB_in_w[7][1] = dataB_out_w[7][1-1];
                    
    assign start_in_w[7][1] = start_out_w[7][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(11),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_7_1 (
        .clk(clk),
        .start_in(start_in_w[7][1]),
        .start_out(start_out_w[7][1]),
        .key_data(key_data_w[7][1]),
        .op_in(inst_op_in_w[7][1]),
        .op_out(inst_op_out_w[7][1]),
        .gauss_op_in(op_in_w[7][1]),
        .gauss_op_out(op_out_w[7][1]),
        .data_in(data_in_w[7][1]),
        .data_out(data_out_w[7][1]),
        .dataB_in(dataB_in_w[7][1]),
        .dataB_out(dataB_out_w[7][1]),
        .dataA_in(dataA_in_w[7][1]),
        .dataA_out(dataA_out_w[7][1]),
        .r(r_w[7][1])
    );
                    
    // compute_unit(7, 12), (tile(0, 2), unit(7, 2))
                
    assign dataA_in_w[7][2] = dataA_out_w[7-1][2];
                    
    assign data_in_w[7][2] = data_out_w[7-1][2];
                    
    assign op_in_w[7][2] = op_out_w[7][2-1];
    assign inst_op_in_w[7][2] = inst_op_out_w[7][2-1];
    assign dataB_in_w[7][2] = dataB_out_w[7][2-1];
                    
    assign start_in_w[7][2] = start_out_w[7][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(12),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_7_2 (
        .clk(clk),
        .start_in(start_in_w[7][2]),
        .start_out(start_out_w[7][2]),
        .key_data(key_data_w[7][2]),
        .op_in(inst_op_in_w[7][2]),
        .op_out(inst_op_out_w[7][2]),
        .gauss_op_in(op_in_w[7][2]),
        .gauss_op_out(op_out_w[7][2]),
        .data_in(data_in_w[7][2]),
        .data_out(data_out_w[7][2]),
        .dataB_in(dataB_in_w[7][2]),
        .dataB_out(dataB_out_w[7][2]),
        .dataA_in(dataA_in_w[7][2]),
        .dataA_out(dataA_out_w[7][2]),
        .r(r_w[7][2])
    );
                    
    // compute_unit(7, 13), (tile(0, 2), unit(7, 3))
                
    assign dataA_in_w[7][3] = dataA_out_w[7-1][3];
                    
    assign data_in_w[7][3] = data_out_w[7-1][3];
                    
    assign op_in_w[7][3] = op_out_w[7][3-1];
    assign inst_op_in_w[7][3] = inst_op_out_w[7][3-1];
    assign dataB_in_w[7][3] = dataB_out_w[7][3-1];
                    
    assign start_in_w[7][3] = start_out_w[7][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(13),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_7_3 (
        .clk(clk),
        .start_in(start_in_w[7][3]),
        .start_out(start_out_w[7][3]),
        .key_data(key_data_w[7][3]),
        .op_in(inst_op_in_w[7][3]),
        .op_out(inst_op_out_w[7][3]),
        .gauss_op_in(op_in_w[7][3]),
        .gauss_op_out(op_out_w[7][3]),
        .data_in(data_in_w[7][3]),
        .data_out(data_out_w[7][3]),
        .dataB_in(dataB_in_w[7][3]),
        .dataB_out(dataB_out_w[7][3]),
        .dataA_in(dataA_in_w[7][3]),
        .dataA_out(dataA_out_w[7][3]),
        .r(r_w[7][3])
    );
                    
    // compute_unit(7, 14), (tile(0, 2), unit(7, 4))
                
    assign dataA_in_w[7][4] = dataA_out_w[7-1][4];
                    
    assign data_in_w[7][4] = data_out_w[7-1][4];
                    
    assign op_in_w[7][4] = op_out_w[7][4-1];
    assign inst_op_in_w[7][4] = inst_op_out_w[7][4-1];
    assign dataB_in_w[7][4] = dataB_out_w[7][4-1];
                    
    assign start_in_w[7][4] = start_out_w[7][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(14),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_7_4 (
        .clk(clk),
        .start_in(start_in_w[7][4]),
        .start_out(start_out_w[7][4]),
        .key_data(key_data_w[7][4]),
        .op_in(inst_op_in_w[7][4]),
        .op_out(inst_op_out_w[7][4]),
        .gauss_op_in(op_in_w[7][4]),
        .gauss_op_out(op_out_w[7][4]),
        .data_in(data_in_w[7][4]),
        .data_out(data_out_w[7][4]),
        .dataB_in(dataB_in_w[7][4]),
        .dataB_out(dataB_out_w[7][4]),
        .dataA_in(dataA_in_w[7][4]),
        .dataA_out(dataA_out_w[7][4]),
        .r(r_w[7][4])
    );
                    
    // compute_unit(7, 15), (tile(0, 2), unit(7, 5))
                
    assign dataA_in_w[7][5] = dataA_out_w[7-1][5];
                    
    assign data_in_w[7][5] = data_out_w[7-1][5];
                    
    assign op_in_w[7][5] = op_out_w[7][5-1];
    assign inst_op_in_w[7][5] = inst_op_out_w[7][5-1];
    assign dataB_in_w[7][5] = dataB_out_w[7][5-1];
                    
    assign start_in_w[7][5] = start_out_w[7][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(7),
        .COL_IDX(15),
        .TILE_ROW_IDX(0),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_7_5 (
        .clk(clk),
        .start_in(start_in_w[7][5]),
        .start_out(start_out_w[7][5]),
        .key_data(key_data_w[7][5]),
        .op_in(inst_op_in_w[7][5]),
        .op_out(inst_op_out_w[7][5]),
        .gauss_op_in(op_in_w[7][5]),
        .gauss_op_out(op_out_w[7][5]),
        .data_in(data_in_w[7][5]),
        .data_out(data_out_w[7][5]),
        .dataB_in(dataB_in_w[7][5]),
        .dataB_out(dataB_out_w[7][5]),
        .dataA_in(dataA_in_w[7][5]),
        .dataA_out(dataA_out_w[7][5]),
        .r(r_w[7][5])
    );
                    
    generate
        for (i = 0; i < COL; i=i+1) begin
            for (j = 0; j < GF_BIT; j=j+1) begin
                assign data_out[i*GF_BIT+j] = data_out_w[ROW-1][i][j];
            end
        end
    endgenerate
        
    generate
        for (i = 0; i < ROW; i=i+1) begin
            assign gauss_op_out[2*i+1:2*i] = op_out_w[i][COL-1];
            assign dataB_out[GF_BIT*i+(GF_BIT-1):GF_BIT*i] = dataB_out_w[i][COL-1];
        end
    endgenerate
        
    assign r_A_and = 1;
            
    reg start_out_tmp;
    reg finish_out_tmp;
    always @(posedge clk) begin
        start_out_tmp  <= start_row[ROW-1];
        finish_out_tmp <= finish_row[ROW-1];
        start_out      <= start_out_tmp;
        finish_out     <= finish_out_tmp;
    end

endmodule
        
// row = 8, col = 5
module tile_1_0#(
    parameter N = 16,
    parameter GF_BIT = 8,
    parameter OP_SIZE = 22,
    parameter ROW = 8,
    parameter COL = 5
)(
    input wire                      clk,
    input wire                      rst_n,
    input wire        [OP_SIZE-1:0] op_in,        // decide which operations
    input wire     [GF_BIT*COL-1:0] dataA_in,     // for mat_mul, load
    input wire          [2*ROW-1:0] gauss_op_in,  // for gauss
    input wire     [GF_BIT*ROW-1:0] dataB_in,     // for gauss
    input wire     [GF_BIT*COL-1:0] data_in,      // for gauss, store (not used in first row)
    input wire                      start_in, 
    input wire                      finish_in,
    output wire         [2*ROW-1:0] gauss_op_out, // for gauss
    output wire    [GF_BIT*ROW-1:0] dataB_out,    // for gauss
    output wire    [GF_BIT*COL-1:0] data_out,     // for gauss, store
    output reg                      start_out,
    output reg                      finish_out,
    output wire                     r_A_and
);
    
    localparam TILE_ROW_IDX = 1;
    localparam TILE_COL_IDX = 0;
    localparam NUM_PROC_COL = 3;
    localparam BANK = 5; 

    genvar i, j, k;
    integer n, m;

    wire                  start_in_w[0:ROW-1][0:COL-1];
    wire                 start_out_w[0:ROW-1][0:COL-1];
    wire                 finish_in_w[0:ROW-1];
    wire                finish_out_w[0:ROW-1];
    wire         [3:0]  inst_op_in_w[0:ROW-1][0:COL-1];
    wire         [3:0] inst_op_out_w[0:ROW-1][0:COL-1];
    wire         [1:0]       op_in_w[0:ROW-1][0:COL-1];
    wire         [1:0]      op_out_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    dataB_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]   dataB_out_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]           r_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]     data_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    dataA_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]   dataA_out_w[0:ROW-1][0:COL-1];
    reg   [GF_BIT-1:0]     data_in_r[1:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    data_out_w[0:ROW-1][0:COL-1];

    reg [ROW-1 : 1] start_tmp;
    reg [ROW-1 : 1] start_row;
    
    reg [ROW-1 : 1] finish_tmp;
    reg [ROW-1 : 1] finish_row;
    
    reg functionA_dup;
    always @(posedge clk) begin
        functionA_dup <= op_in[17];
    end

    wire [GF_BIT*4*BANK-1:0] key_data;
    wire          [GF_BIT-1:0] key_data_w[0:ROW-1][0:COL-1];
    wire                       key_wren;
    wire      [GF_BIT*ROW-1:0] key_write_data;
    generate
        if (GF_BIT*4 != 0) begin: key_mem
            assign key_wren = op_in[14];
            bram16Kx4 #(
                .WIDTH(GF_BIT*4),
                .DELAY(1)
            ) mem_inst (
                .clock (clk),
                .data (key_write_data),
                .address (op_in[14-1:0]),
                .wren (key_wren),
                .q (key_data)
            );
            for (j = 0; j < ROW; j=j+1) begin
                for (k = 0; k < BANK; k=k+1) begin
                    assign key_data_w[j][k] = (j < 4) ? key_data[(j+k*4)*GF_BIT+:GF_BIT] : 0; // load from
                end
                assign key_write_data[j*GF_BIT+:GF_BIT] = r_w[j][0];                        // write to
            end
        end else begin
            for (j = 0; j < ROW; j=j+1) begin
                for (k = 0; k < BANK; k=k+1) begin
                    assign key_data_w[j][k] = 0; // load from
                end
            end
        end
    endgenerate

    // always@(posedge clk) begin
    //     if ((op_in[OP_SIZE-1:OP_SIZE-4] == 7)) begin
    //         $display("_____________________________________________");
    //         $display("| 1_0, 8, 5");
    //         $display("| dataA_in: %x,  dataB_in: %x, addr: %d, key_data: %x, key_write_data: %x, key_wren: %d", dataA_in, dataB_in, op_in[14-1:0], key_data, key_write_data, key_wren);
    //         $display("|____________________________________________");
    //     end
    // end
        
    // compute_unit(8, 0), (tile(1, 0), unit(0, 0))
                
    assign dataA_in_w[0][0] = dataA_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign data_in_w[0][0] = data_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign op_in_w[0][0] = gauss_op_in[2*0+1:2*0];
    assign inst_op_in_w[0][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[0][0] = dataB_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign start_in_w[0][0] = start_in;
    assign finish_in_w[0] = finish_in;
                    
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(8),
        .COL_IDX(0),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_0_0 (
        .clk(clk),
        .start_in(start_in_w[0][0]),
        .start_out(start_out_w[0][0]),
        .key_data(key_data_w[0][0]),
        .op_in(inst_op_in_w[0][0]),
        .op_out(inst_op_out_w[0][0]),
        .gauss_op_in(op_in_w[0][0]),
        .gauss_op_out(op_out_w[0][0]),
        .data_in(data_in_w[0][0]),
        .data_out(data_out_w[0][0]),
        .dataB_in(dataB_in_w[0][0]),
        .dataB_out(dataB_out_w[0][0]),
        .dataA_in(dataA_in_w[0][0]),
        .dataA_out(dataA_out_w[0][0]),
        .r(r_w[0][0])
    );
                    
    // compute_unit(8, 1), (tile(1, 0), unit(0, 1))
                
    assign dataA_in_w[0][1] = dataA_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign data_in_w[0][1] = data_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign op_in_w[0][1] = op_out_w[0][1-1];
    assign inst_op_in_w[0][1] = inst_op_out_w[0][1-1];
    assign dataB_in_w[0][1] = dataB_out_w[0][1-1];
                    
    assign start_in_w[0][1] = start_out_w[0][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(1),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_0_1 (
        .clk(clk),
        .start_in(start_in_w[0][1]),
        .start_out(start_out_w[0][1]),
        .key_data(key_data_w[0][1]),
        .op_in(inst_op_in_w[0][1]),
        .op_out(inst_op_out_w[0][1]),
        .gauss_op_in(op_in_w[0][1]),
        .gauss_op_out(op_out_w[0][1]),
        .data_in(data_in_w[0][1]),
        .data_out(data_out_w[0][1]),
        .dataB_in(dataB_in_w[0][1]),
        .dataB_out(dataB_out_w[0][1]),
        .dataA_in(dataA_in_w[0][1]),
        .dataA_out(dataA_out_w[0][1]),
        .r(r_w[0][1])
    );
                    
    // compute_unit(8, 2), (tile(1, 0), unit(0, 2))
                
    assign dataA_in_w[0][2] = dataA_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign data_in_w[0][2] = data_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign op_in_w[0][2] = op_out_w[0][2-1];
    assign inst_op_in_w[0][2] = inst_op_out_w[0][2-1];
    assign dataB_in_w[0][2] = dataB_out_w[0][2-1];
                    
    assign start_in_w[0][2] = start_out_w[0][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(2),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_0_2 (
        .clk(clk),
        .start_in(start_in_w[0][2]),
        .start_out(start_out_w[0][2]),
        .key_data(key_data_w[0][2]),
        .op_in(inst_op_in_w[0][2]),
        .op_out(inst_op_out_w[0][2]),
        .gauss_op_in(op_in_w[0][2]),
        .gauss_op_out(op_out_w[0][2]),
        .data_in(data_in_w[0][2]),
        .data_out(data_out_w[0][2]),
        .dataB_in(dataB_in_w[0][2]),
        .dataB_out(dataB_out_w[0][2]),
        .dataA_in(dataA_in_w[0][2]),
        .dataA_out(dataA_out_w[0][2]),
        .r(r_w[0][2])
    );
                    
    // compute_unit(8, 3), (tile(1, 0), unit(0, 3))
                
    assign dataA_in_w[0][3] = dataA_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign data_in_w[0][3] = data_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign op_in_w[0][3] = op_out_w[0][3-1];
    assign inst_op_in_w[0][3] = inst_op_out_w[0][3-1];
    assign dataB_in_w[0][3] = dataB_out_w[0][3-1];
                    
    assign start_in_w[0][3] = start_out_w[0][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(3),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_0_3 (
        .clk(clk),
        .start_in(start_in_w[0][3]),
        .start_out(start_out_w[0][3]),
        .key_data(key_data_w[0][3]),
        .op_in(inst_op_in_w[0][3]),
        .op_out(inst_op_out_w[0][3]),
        .gauss_op_in(op_in_w[0][3]),
        .gauss_op_out(op_out_w[0][3]),
        .data_in(data_in_w[0][3]),
        .data_out(data_out_w[0][3]),
        .dataB_in(dataB_in_w[0][3]),
        .dataB_out(dataB_out_w[0][3]),
        .dataA_in(dataA_in_w[0][3]),
        .dataA_out(dataA_out_w[0][3]),
        .r(r_w[0][3])
    );
                    
    // compute_unit(8, 4), (tile(1, 0), unit(0, 4))
                
    assign dataA_in_w[0][4] = dataA_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign data_in_w[0][4] = data_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign op_in_w[0][4] = op_out_w[0][4-1];
    assign inst_op_in_w[0][4] = inst_op_out_w[0][4-1];
    assign dataB_in_w[0][4] = dataB_out_w[0][4-1];
                    
    assign start_in_w[0][4] = start_out_w[0][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(4),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_0_4 (
        .clk(clk),
        .start_in(start_in_w[0][4]),
        .start_out(start_out_w[0][4]),
        .key_data(key_data_w[0][4]),
        .op_in(inst_op_in_w[0][4]),
        .op_out(inst_op_out_w[0][4]),
        .gauss_op_in(op_in_w[0][4]),
        .gauss_op_out(op_out_w[0][4]),
        .data_in(data_in_w[0][4]),
        .data_out(data_out_w[0][4]),
        .dataB_in(dataB_in_w[0][4]),
        .dataB_out(dataB_out_w[0][4]),
        .dataA_in(dataA_in_w[0][4]),
        .dataA_out(dataA_out_w[0][4]),
        .r(r_w[0][4])
    );
                    
    // compute_unit(9, 0), (tile(1, 0), unit(1, 0))
                
    assign dataA_in_w[1][0] = dataA_out_w[1-1][0];
                    
    assign data_in_w[1][0] = data_out_w[1-1][0];
                    
    assign op_in_w[1][0] = gauss_op_in[2*1+1:2*1];
    assign inst_op_in_w[1][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[1][0] = dataB_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign start_in_w[1][0] = start_row[1];
    assign finish_in_w[1] = finish_row[1];
                    
    always @(posedge clk) begin
        start_tmp[1] <= start_in;
        start_row[1] <= start_tmp[1];
        finish_tmp[1] <= finish_in;
        finish_row[1] <= finish_tmp[1];
    end
                        
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(9),
        .COL_IDX(0),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_1_0 (
        .clk(clk),
        .start_in(start_in_w[1][0]),
        .start_out(start_out_w[1][0]),
        .key_data(key_data_w[1][0]),
        .op_in(inst_op_in_w[1][0]),
        .op_out(inst_op_out_w[1][0]),
        .gauss_op_in(op_in_w[1][0]),
        .gauss_op_out(op_out_w[1][0]),
        .data_in(data_in_w[1][0]),
        .data_out(data_out_w[1][0]),
        .dataB_in(dataB_in_w[1][0]),
        .dataB_out(dataB_out_w[1][0]),
        .dataA_in(dataA_in_w[1][0]),
        .dataA_out(dataA_out_w[1][0]),
        .r(r_w[1][0])
    );
                    
    // compute_unit(9, 1), (tile(1, 0), unit(1, 1))
                
    assign dataA_in_w[1][1] = dataA_out_w[1-1][1];
                    
    assign data_in_w[1][1] = data_out_w[1-1][1];
                    
    assign op_in_w[1][1] = op_out_w[1][1-1];
    assign inst_op_in_w[1][1] = inst_op_out_w[1][1-1];
    assign dataB_in_w[1][1] = dataB_out_w[1][1-1];
                    
    assign start_in_w[1][1] = start_out_w[1][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(1),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_1_1 (
        .clk(clk),
        .start_in(start_in_w[1][1]),
        .start_out(start_out_w[1][1]),
        .key_data(key_data_w[1][1]),
        .op_in(inst_op_in_w[1][1]),
        .op_out(inst_op_out_w[1][1]),
        .gauss_op_in(op_in_w[1][1]),
        .gauss_op_out(op_out_w[1][1]),
        .data_in(data_in_w[1][1]),
        .data_out(data_out_w[1][1]),
        .dataB_in(dataB_in_w[1][1]),
        .dataB_out(dataB_out_w[1][1]),
        .dataA_in(dataA_in_w[1][1]),
        .dataA_out(dataA_out_w[1][1]),
        .r(r_w[1][1])
    );
                    
    // compute_unit(9, 2), (tile(1, 0), unit(1, 2))
                
    assign dataA_in_w[1][2] = dataA_out_w[1-1][2];
                    
    assign data_in_w[1][2] = data_out_w[1-1][2];
                    
    assign op_in_w[1][2] = op_out_w[1][2-1];
    assign inst_op_in_w[1][2] = inst_op_out_w[1][2-1];
    assign dataB_in_w[1][2] = dataB_out_w[1][2-1];
                    
    assign start_in_w[1][2] = start_out_w[1][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(2),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_1_2 (
        .clk(clk),
        .start_in(start_in_w[1][2]),
        .start_out(start_out_w[1][2]),
        .key_data(key_data_w[1][2]),
        .op_in(inst_op_in_w[1][2]),
        .op_out(inst_op_out_w[1][2]),
        .gauss_op_in(op_in_w[1][2]),
        .gauss_op_out(op_out_w[1][2]),
        .data_in(data_in_w[1][2]),
        .data_out(data_out_w[1][2]),
        .dataB_in(dataB_in_w[1][2]),
        .dataB_out(dataB_out_w[1][2]),
        .dataA_in(dataA_in_w[1][2]),
        .dataA_out(dataA_out_w[1][2]),
        .r(r_w[1][2])
    );
                    
    // compute_unit(9, 3), (tile(1, 0), unit(1, 3))
                
    assign dataA_in_w[1][3] = dataA_out_w[1-1][3];
                    
    assign data_in_w[1][3] = data_out_w[1-1][3];
                    
    assign op_in_w[1][3] = op_out_w[1][3-1];
    assign inst_op_in_w[1][3] = inst_op_out_w[1][3-1];
    assign dataB_in_w[1][3] = dataB_out_w[1][3-1];
                    
    assign start_in_w[1][3] = start_out_w[1][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(3),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_1_3 (
        .clk(clk),
        .start_in(start_in_w[1][3]),
        .start_out(start_out_w[1][3]),
        .key_data(key_data_w[1][3]),
        .op_in(inst_op_in_w[1][3]),
        .op_out(inst_op_out_w[1][3]),
        .gauss_op_in(op_in_w[1][3]),
        .gauss_op_out(op_out_w[1][3]),
        .data_in(data_in_w[1][3]),
        .data_out(data_out_w[1][3]),
        .dataB_in(dataB_in_w[1][3]),
        .dataB_out(dataB_out_w[1][3]),
        .dataA_in(dataA_in_w[1][3]),
        .dataA_out(dataA_out_w[1][3]),
        .r(r_w[1][3])
    );
                    
    // compute_unit(9, 4), (tile(1, 0), unit(1, 4))
                
    assign dataA_in_w[1][4] = dataA_out_w[1-1][4];
                    
    assign data_in_w[1][4] = data_out_w[1-1][4];
                    
    assign op_in_w[1][4] = op_out_w[1][4-1];
    assign inst_op_in_w[1][4] = inst_op_out_w[1][4-1];
    assign dataB_in_w[1][4] = dataB_out_w[1][4-1];
                    
    assign start_in_w[1][4] = start_out_w[1][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(4),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_1_4 (
        .clk(clk),
        .start_in(start_in_w[1][4]),
        .start_out(start_out_w[1][4]),
        .key_data(key_data_w[1][4]),
        .op_in(inst_op_in_w[1][4]),
        .op_out(inst_op_out_w[1][4]),
        .gauss_op_in(op_in_w[1][4]),
        .gauss_op_out(op_out_w[1][4]),
        .data_in(data_in_w[1][4]),
        .data_out(data_out_w[1][4]),
        .dataB_in(dataB_in_w[1][4]),
        .dataB_out(dataB_out_w[1][4]),
        .dataA_in(dataA_in_w[1][4]),
        .dataA_out(dataA_out_w[1][4]),
        .r(r_w[1][4])
    );
                    
    // compute_unit(10, 0), (tile(1, 0), unit(2, 0))
                
    assign dataA_in_w[2][0] = dataA_out_w[2-1][0];
                    
    assign data_in_w[2][0] = data_out_w[2-1][0];
                    
    assign op_in_w[2][0] = gauss_op_in[2*2+1:2*2];
    assign inst_op_in_w[2][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[2][0] = dataB_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign start_in_w[2][0] = start_row[2];
    assign finish_in_w[2] = finish_row[2];
                    
    always @(posedge clk) begin
        start_tmp[2] <= start_row[2-1];
        start_row[2] <= start_tmp[2];
        finish_tmp[2] <= finish_row[2-1];
        finish_row[2] <= finish_tmp[2];
    end
                        
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(10),
        .COL_IDX(0),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_2_0 (
        .clk(clk),
        .start_in(start_in_w[2][0]),
        .start_out(start_out_w[2][0]),
        .key_data(key_data_w[2][0]),
        .op_in(inst_op_in_w[2][0]),
        .op_out(inst_op_out_w[2][0]),
        .gauss_op_in(op_in_w[2][0]),
        .gauss_op_out(op_out_w[2][0]),
        .data_in(data_in_w[2][0]),
        .data_out(data_out_w[2][0]),
        .dataB_in(dataB_in_w[2][0]),
        .dataB_out(dataB_out_w[2][0]),
        .dataA_in(dataA_in_w[2][0]),
        .dataA_out(dataA_out_w[2][0]),
        .r(r_w[2][0])
    );
                    
    // compute_unit(10, 1), (tile(1, 0), unit(2, 1))
                
    assign dataA_in_w[2][1] = dataA_out_w[2-1][1];
                    
    assign data_in_w[2][1] = data_out_w[2-1][1];
                    
    assign op_in_w[2][1] = op_out_w[2][1-1];
    assign inst_op_in_w[2][1] = inst_op_out_w[2][1-1];
    assign dataB_in_w[2][1] = dataB_out_w[2][1-1];
                    
    assign start_in_w[2][1] = start_out_w[2][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(1),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_2_1 (
        .clk(clk),
        .start_in(start_in_w[2][1]),
        .start_out(start_out_w[2][1]),
        .key_data(key_data_w[2][1]),
        .op_in(inst_op_in_w[2][1]),
        .op_out(inst_op_out_w[2][1]),
        .gauss_op_in(op_in_w[2][1]),
        .gauss_op_out(op_out_w[2][1]),
        .data_in(data_in_w[2][1]),
        .data_out(data_out_w[2][1]),
        .dataB_in(dataB_in_w[2][1]),
        .dataB_out(dataB_out_w[2][1]),
        .dataA_in(dataA_in_w[2][1]),
        .dataA_out(dataA_out_w[2][1]),
        .r(r_w[2][1])
    );
                    
    // compute_unit(10, 2), (tile(1, 0), unit(2, 2))
                
    assign dataA_in_w[2][2] = dataA_out_w[2-1][2];
                    
    assign data_in_w[2][2] = data_out_w[2-1][2];
                    
    assign op_in_w[2][2] = op_out_w[2][2-1];
    assign inst_op_in_w[2][2] = inst_op_out_w[2][2-1];
    assign dataB_in_w[2][2] = dataB_out_w[2][2-1];
                    
    assign start_in_w[2][2] = start_out_w[2][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(2),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_2_2 (
        .clk(clk),
        .start_in(start_in_w[2][2]),
        .start_out(start_out_w[2][2]),
        .key_data(key_data_w[2][2]),
        .op_in(inst_op_in_w[2][2]),
        .op_out(inst_op_out_w[2][2]),
        .gauss_op_in(op_in_w[2][2]),
        .gauss_op_out(op_out_w[2][2]),
        .data_in(data_in_w[2][2]),
        .data_out(data_out_w[2][2]),
        .dataB_in(dataB_in_w[2][2]),
        .dataB_out(dataB_out_w[2][2]),
        .dataA_in(dataA_in_w[2][2]),
        .dataA_out(dataA_out_w[2][2]),
        .r(r_w[2][2])
    );
                    
    // compute_unit(10, 3), (tile(1, 0), unit(2, 3))
                
    assign dataA_in_w[2][3] = dataA_out_w[2-1][3];
                    
    assign data_in_w[2][3] = data_out_w[2-1][3];
                    
    assign op_in_w[2][3] = op_out_w[2][3-1];
    assign inst_op_in_w[2][3] = inst_op_out_w[2][3-1];
    assign dataB_in_w[2][3] = dataB_out_w[2][3-1];
                    
    assign start_in_w[2][3] = start_out_w[2][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(3),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_2_3 (
        .clk(clk),
        .start_in(start_in_w[2][3]),
        .start_out(start_out_w[2][3]),
        .key_data(key_data_w[2][3]),
        .op_in(inst_op_in_w[2][3]),
        .op_out(inst_op_out_w[2][3]),
        .gauss_op_in(op_in_w[2][3]),
        .gauss_op_out(op_out_w[2][3]),
        .data_in(data_in_w[2][3]),
        .data_out(data_out_w[2][3]),
        .dataB_in(dataB_in_w[2][3]),
        .dataB_out(dataB_out_w[2][3]),
        .dataA_in(dataA_in_w[2][3]),
        .dataA_out(dataA_out_w[2][3]),
        .r(r_w[2][3])
    );
                    
    // compute_unit(10, 4), (tile(1, 0), unit(2, 4))
                
    assign dataA_in_w[2][4] = dataA_out_w[2-1][4];
                    
    assign data_in_w[2][4] = data_out_w[2-1][4];
                    
    assign op_in_w[2][4] = op_out_w[2][4-1];
    assign inst_op_in_w[2][4] = inst_op_out_w[2][4-1];
    assign dataB_in_w[2][4] = dataB_out_w[2][4-1];
                    
    assign start_in_w[2][4] = start_out_w[2][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(4),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_2_4 (
        .clk(clk),
        .start_in(start_in_w[2][4]),
        .start_out(start_out_w[2][4]),
        .key_data(key_data_w[2][4]),
        .op_in(inst_op_in_w[2][4]),
        .op_out(inst_op_out_w[2][4]),
        .gauss_op_in(op_in_w[2][4]),
        .gauss_op_out(op_out_w[2][4]),
        .data_in(data_in_w[2][4]),
        .data_out(data_out_w[2][4]),
        .dataB_in(dataB_in_w[2][4]),
        .dataB_out(dataB_out_w[2][4]),
        .dataA_in(dataA_in_w[2][4]),
        .dataA_out(dataA_out_w[2][4]),
        .r(r_w[2][4])
    );
                    
    // compute_unit(11, 0), (tile(1, 0), unit(3, 0))
                
    assign dataA_in_w[3][0] = dataA_out_w[3-1][0];
                    
    assign data_in_w[3][0] = data_out_w[3-1][0];
                    
    assign op_in_w[3][0] = gauss_op_in[2*3+1:2*3];
    assign inst_op_in_w[3][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[3][0] = dataB_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign start_in_w[3][0] = start_row[3];
    assign finish_in_w[3] = finish_row[3];
                    
    always @(posedge clk) begin
        start_tmp[3] <= start_row[3-1];
        start_row[3] <= start_tmp[3];
        finish_tmp[3] <= finish_row[3-1];
        finish_row[3] <= finish_tmp[3];
    end
                        
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(11),
        .COL_IDX(0),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_3_0 (
        .clk(clk),
        .start_in(start_in_w[3][0]),
        .start_out(start_out_w[3][0]),
        .key_data(key_data_w[3][0]),
        .op_in(inst_op_in_w[3][0]),
        .op_out(inst_op_out_w[3][0]),
        .gauss_op_in(op_in_w[3][0]),
        .gauss_op_out(op_out_w[3][0]),
        .data_in(data_in_w[3][0]),
        .data_out(data_out_w[3][0]),
        .dataB_in(dataB_in_w[3][0]),
        .dataB_out(dataB_out_w[3][0]),
        .dataA_in(dataA_in_w[3][0]),
        .dataA_out(dataA_out_w[3][0]),
        .r(r_w[3][0])
    );
                    
    // compute_unit(11, 1), (tile(1, 0), unit(3, 1))
                
    assign dataA_in_w[3][1] = dataA_out_w[3-1][1];
                    
    assign data_in_w[3][1] = data_out_w[3-1][1];
                    
    assign op_in_w[3][1] = op_out_w[3][1-1];
    assign inst_op_in_w[3][1] = inst_op_out_w[3][1-1];
    assign dataB_in_w[3][1] = dataB_out_w[3][1-1];
                    
    assign start_in_w[3][1] = start_out_w[3][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(1),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_3_1 (
        .clk(clk),
        .start_in(start_in_w[3][1]),
        .start_out(start_out_w[3][1]),
        .key_data(key_data_w[3][1]),
        .op_in(inst_op_in_w[3][1]),
        .op_out(inst_op_out_w[3][1]),
        .gauss_op_in(op_in_w[3][1]),
        .gauss_op_out(op_out_w[3][1]),
        .data_in(data_in_w[3][1]),
        .data_out(data_out_w[3][1]),
        .dataB_in(dataB_in_w[3][1]),
        .dataB_out(dataB_out_w[3][1]),
        .dataA_in(dataA_in_w[3][1]),
        .dataA_out(dataA_out_w[3][1]),
        .r(r_w[3][1])
    );
                    
    // compute_unit(11, 2), (tile(1, 0), unit(3, 2))
                
    assign dataA_in_w[3][2] = dataA_out_w[3-1][2];
                    
    assign data_in_w[3][2] = data_out_w[3-1][2];
                    
    assign op_in_w[3][2] = op_out_w[3][2-1];
    assign inst_op_in_w[3][2] = inst_op_out_w[3][2-1];
    assign dataB_in_w[3][2] = dataB_out_w[3][2-1];
                    
    assign start_in_w[3][2] = start_out_w[3][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(2),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_3_2 (
        .clk(clk),
        .start_in(start_in_w[3][2]),
        .start_out(start_out_w[3][2]),
        .key_data(key_data_w[3][2]),
        .op_in(inst_op_in_w[3][2]),
        .op_out(inst_op_out_w[3][2]),
        .gauss_op_in(op_in_w[3][2]),
        .gauss_op_out(op_out_w[3][2]),
        .data_in(data_in_w[3][2]),
        .data_out(data_out_w[3][2]),
        .dataB_in(dataB_in_w[3][2]),
        .dataB_out(dataB_out_w[3][2]),
        .dataA_in(dataA_in_w[3][2]),
        .dataA_out(dataA_out_w[3][2]),
        .r(r_w[3][2])
    );
                    
    // compute_unit(11, 3), (tile(1, 0), unit(3, 3))
                
    assign dataA_in_w[3][3] = dataA_out_w[3-1][3];
                    
    assign data_in_w[3][3] = data_out_w[3-1][3];
                    
    assign op_in_w[3][3] = op_out_w[3][3-1];
    assign inst_op_in_w[3][3] = inst_op_out_w[3][3-1];
    assign dataB_in_w[3][3] = dataB_out_w[3][3-1];
                    
    assign start_in_w[3][3] = start_out_w[3][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(3),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_3_3 (
        .clk(clk),
        .start_in(start_in_w[3][3]),
        .start_out(start_out_w[3][3]),
        .key_data(key_data_w[3][3]),
        .op_in(inst_op_in_w[3][3]),
        .op_out(inst_op_out_w[3][3]),
        .gauss_op_in(op_in_w[3][3]),
        .gauss_op_out(op_out_w[3][3]),
        .data_in(data_in_w[3][3]),
        .data_out(data_out_w[3][3]),
        .dataB_in(dataB_in_w[3][3]),
        .dataB_out(dataB_out_w[3][3]),
        .dataA_in(dataA_in_w[3][3]),
        .dataA_out(dataA_out_w[3][3]),
        .r(r_w[3][3])
    );
                    
    // compute_unit(11, 4), (tile(1, 0), unit(3, 4))
                
    assign dataA_in_w[3][4] = dataA_out_w[3-1][4];
                    
    assign data_in_w[3][4] = data_out_w[3-1][4];
                    
    assign op_in_w[3][4] = op_out_w[3][4-1];
    assign inst_op_in_w[3][4] = inst_op_out_w[3][4-1];
    assign dataB_in_w[3][4] = dataB_out_w[3][4-1];
                    
    assign start_in_w[3][4] = start_out_w[3][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(4),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_3_4 (
        .clk(clk),
        .start_in(start_in_w[3][4]),
        .start_out(start_out_w[3][4]),
        .key_data(key_data_w[3][4]),
        .op_in(inst_op_in_w[3][4]),
        .op_out(inst_op_out_w[3][4]),
        .gauss_op_in(op_in_w[3][4]),
        .gauss_op_out(op_out_w[3][4]),
        .data_in(data_in_w[3][4]),
        .data_out(data_out_w[3][4]),
        .dataB_in(dataB_in_w[3][4]),
        .dataB_out(dataB_out_w[3][4]),
        .dataA_in(dataA_in_w[3][4]),
        .dataA_out(dataA_out_w[3][4]),
        .r(r_w[3][4])
    );
                    
    // compute_unit(12, 0), (tile(1, 0), unit(4, 0))
                
    assign dataA_in_w[4][0] = dataA_out_w[4-1][0];
                    
    assign data_in_w[4][0] = data_out_w[4-1][0];
                    
    assign op_in_w[4][0] = gauss_op_in[2*4+1:2*4];
    assign inst_op_in_w[4][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[4][0] = dataB_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign start_in_w[4][0] = start_row[4];
    assign finish_in_w[4] = finish_row[4];
                    
    always @(posedge clk) begin
        start_tmp[4] <= start_row[4-1];
        start_row[4] <= start_tmp[4];
        finish_tmp[4] <= finish_row[4-1];
        finish_row[4] <= finish_tmp[4];
    end
                        
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(12),
        .COL_IDX(0),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_4_0 (
        .clk(clk),
        .start_in(start_in_w[4][0]),
        .start_out(start_out_w[4][0]),
        .key_data(key_data_w[4][0]),
        .op_in(inst_op_in_w[4][0]),
        .op_out(inst_op_out_w[4][0]),
        .gauss_op_in(op_in_w[4][0]),
        .gauss_op_out(op_out_w[4][0]),
        .data_in(data_in_w[4][0]),
        .data_out(data_out_w[4][0]),
        .dataB_in(dataB_in_w[4][0]),
        .dataB_out(dataB_out_w[4][0]),
        .dataA_in(dataA_in_w[4][0]),
        .dataA_out(dataA_out_w[4][0]),
        .r(r_w[4][0])
    );
                    
    // compute_unit(12, 1), (tile(1, 0), unit(4, 1))
                
    assign dataA_in_w[4][1] = dataA_out_w[4-1][1];
                    
    assign data_in_w[4][1] = data_out_w[4-1][1];
                    
    assign op_in_w[4][1] = op_out_w[4][1-1];
    assign inst_op_in_w[4][1] = inst_op_out_w[4][1-1];
    assign dataB_in_w[4][1] = dataB_out_w[4][1-1];
                    
    assign start_in_w[4][1] = start_out_w[4][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(1),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_4_1 (
        .clk(clk),
        .start_in(start_in_w[4][1]),
        .start_out(start_out_w[4][1]),
        .key_data(key_data_w[4][1]),
        .op_in(inst_op_in_w[4][1]),
        .op_out(inst_op_out_w[4][1]),
        .gauss_op_in(op_in_w[4][1]),
        .gauss_op_out(op_out_w[4][1]),
        .data_in(data_in_w[4][1]),
        .data_out(data_out_w[4][1]),
        .dataB_in(dataB_in_w[4][1]),
        .dataB_out(dataB_out_w[4][1]),
        .dataA_in(dataA_in_w[4][1]),
        .dataA_out(dataA_out_w[4][1]),
        .r(r_w[4][1])
    );
                    
    // compute_unit(12, 2), (tile(1, 0), unit(4, 2))
                
    assign dataA_in_w[4][2] = dataA_out_w[4-1][2];
                    
    assign data_in_w[4][2] = data_out_w[4-1][2];
                    
    assign op_in_w[4][2] = op_out_w[4][2-1];
    assign inst_op_in_w[4][2] = inst_op_out_w[4][2-1];
    assign dataB_in_w[4][2] = dataB_out_w[4][2-1];
                    
    assign start_in_w[4][2] = start_out_w[4][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(2),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_4_2 (
        .clk(clk),
        .start_in(start_in_w[4][2]),
        .start_out(start_out_w[4][2]),
        .key_data(key_data_w[4][2]),
        .op_in(inst_op_in_w[4][2]),
        .op_out(inst_op_out_w[4][2]),
        .gauss_op_in(op_in_w[4][2]),
        .gauss_op_out(op_out_w[4][2]),
        .data_in(data_in_w[4][2]),
        .data_out(data_out_w[4][2]),
        .dataB_in(dataB_in_w[4][2]),
        .dataB_out(dataB_out_w[4][2]),
        .dataA_in(dataA_in_w[4][2]),
        .dataA_out(dataA_out_w[4][2]),
        .r(r_w[4][2])
    );
                    
    // compute_unit(12, 3), (tile(1, 0), unit(4, 3))
                
    assign dataA_in_w[4][3] = dataA_out_w[4-1][3];
                    
    assign data_in_w[4][3] = data_out_w[4-1][3];
                    
    assign op_in_w[4][3] = op_out_w[4][3-1];
    assign inst_op_in_w[4][3] = inst_op_out_w[4][3-1];
    assign dataB_in_w[4][3] = dataB_out_w[4][3-1];
                    
    assign start_in_w[4][3] = start_out_w[4][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(3),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_4_3 (
        .clk(clk),
        .start_in(start_in_w[4][3]),
        .start_out(start_out_w[4][3]),
        .key_data(key_data_w[4][3]),
        .op_in(inst_op_in_w[4][3]),
        .op_out(inst_op_out_w[4][3]),
        .gauss_op_in(op_in_w[4][3]),
        .gauss_op_out(op_out_w[4][3]),
        .data_in(data_in_w[4][3]),
        .data_out(data_out_w[4][3]),
        .dataB_in(dataB_in_w[4][3]),
        .dataB_out(dataB_out_w[4][3]),
        .dataA_in(dataA_in_w[4][3]),
        .dataA_out(dataA_out_w[4][3]),
        .r(r_w[4][3])
    );
                    
    // compute_unit(12, 4), (tile(1, 0), unit(4, 4))
                
    assign dataA_in_w[4][4] = dataA_out_w[4-1][4];
                    
    assign data_in_w[4][4] = data_out_w[4-1][4];
                    
    assign op_in_w[4][4] = op_out_w[4][4-1];
    assign inst_op_in_w[4][4] = inst_op_out_w[4][4-1];
    assign dataB_in_w[4][4] = dataB_out_w[4][4-1];
                    
    assign start_in_w[4][4] = start_out_w[4][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(4),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_4_4 (
        .clk(clk),
        .start_in(start_in_w[4][4]),
        .start_out(start_out_w[4][4]),
        .key_data(key_data_w[4][4]),
        .op_in(inst_op_in_w[4][4]),
        .op_out(inst_op_out_w[4][4]),
        .gauss_op_in(op_in_w[4][4]),
        .gauss_op_out(op_out_w[4][4]),
        .data_in(data_in_w[4][4]),
        .data_out(data_out_w[4][4]),
        .dataB_in(dataB_in_w[4][4]),
        .dataB_out(dataB_out_w[4][4]),
        .dataA_in(dataA_in_w[4][4]),
        .dataA_out(dataA_out_w[4][4]),
        .r(r_w[4][4])
    );
                    
    // compute_unit(13, 0), (tile(1, 0), unit(5, 0))
                
    assign dataA_in_w[5][0] = dataA_out_w[5-1][0];
                    
    assign data_in_w[5][0] = data_out_w[5-1][0];
                    
    assign op_in_w[5][0] = gauss_op_in[2*5+1:2*5];
    assign inst_op_in_w[5][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[5][0] = dataB_in[GF_BIT*5+(GF_BIT-1):GF_BIT*5];
                    
    assign start_in_w[5][0] = start_row[5];
    assign finish_in_w[5] = finish_row[5];
                    
    always @(posedge clk) begin
        start_tmp[5] <= start_row[5-1];
        start_row[5] <= start_tmp[5];
        finish_tmp[5] <= finish_row[5-1];
        finish_row[5] <= finish_tmp[5];
    end
                        
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(13),
        .COL_IDX(0),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_5_0 (
        .clk(clk),
        .start_in(start_in_w[5][0]),
        .start_out(start_out_w[5][0]),
        .key_data(key_data_w[5][0]),
        .op_in(inst_op_in_w[5][0]),
        .op_out(inst_op_out_w[5][0]),
        .gauss_op_in(op_in_w[5][0]),
        .gauss_op_out(op_out_w[5][0]),
        .data_in(data_in_w[5][0]),
        .data_out(data_out_w[5][0]),
        .dataB_in(dataB_in_w[5][0]),
        .dataB_out(dataB_out_w[5][0]),
        .dataA_in(dataA_in_w[5][0]),
        .dataA_out(dataA_out_w[5][0]),
        .r(r_w[5][0])
    );
                    
    // compute_unit(13, 1), (tile(1, 0), unit(5, 1))
                
    assign dataA_in_w[5][1] = dataA_out_w[5-1][1];
                    
    assign data_in_w[5][1] = data_out_w[5-1][1];
                    
    assign op_in_w[5][1] = op_out_w[5][1-1];
    assign inst_op_in_w[5][1] = inst_op_out_w[5][1-1];
    assign dataB_in_w[5][1] = dataB_out_w[5][1-1];
                    
    assign start_in_w[5][1] = start_out_w[5][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(1),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_5_1 (
        .clk(clk),
        .start_in(start_in_w[5][1]),
        .start_out(start_out_w[5][1]),
        .key_data(key_data_w[5][1]),
        .op_in(inst_op_in_w[5][1]),
        .op_out(inst_op_out_w[5][1]),
        .gauss_op_in(op_in_w[5][1]),
        .gauss_op_out(op_out_w[5][1]),
        .data_in(data_in_w[5][1]),
        .data_out(data_out_w[5][1]),
        .dataB_in(dataB_in_w[5][1]),
        .dataB_out(dataB_out_w[5][1]),
        .dataA_in(dataA_in_w[5][1]),
        .dataA_out(dataA_out_w[5][1]),
        .r(r_w[5][1])
    );
                    
    // compute_unit(13, 2), (tile(1, 0), unit(5, 2))
                
    assign dataA_in_w[5][2] = dataA_out_w[5-1][2];
                    
    assign data_in_w[5][2] = data_out_w[5-1][2];
                    
    assign op_in_w[5][2] = op_out_w[5][2-1];
    assign inst_op_in_w[5][2] = inst_op_out_w[5][2-1];
    assign dataB_in_w[5][2] = dataB_out_w[5][2-1];
                    
    assign start_in_w[5][2] = start_out_w[5][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(2),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_5_2 (
        .clk(clk),
        .start_in(start_in_w[5][2]),
        .start_out(start_out_w[5][2]),
        .key_data(key_data_w[5][2]),
        .op_in(inst_op_in_w[5][2]),
        .op_out(inst_op_out_w[5][2]),
        .gauss_op_in(op_in_w[5][2]),
        .gauss_op_out(op_out_w[5][2]),
        .data_in(data_in_w[5][2]),
        .data_out(data_out_w[5][2]),
        .dataB_in(dataB_in_w[5][2]),
        .dataB_out(dataB_out_w[5][2]),
        .dataA_in(dataA_in_w[5][2]),
        .dataA_out(dataA_out_w[5][2]),
        .r(r_w[5][2])
    );
                    
    // compute_unit(13, 3), (tile(1, 0), unit(5, 3))
                
    assign dataA_in_w[5][3] = dataA_out_w[5-1][3];
                    
    assign data_in_w[5][3] = data_out_w[5-1][3];
                    
    assign op_in_w[5][3] = op_out_w[5][3-1];
    assign inst_op_in_w[5][3] = inst_op_out_w[5][3-1];
    assign dataB_in_w[5][3] = dataB_out_w[5][3-1];
                    
    assign start_in_w[5][3] = start_out_w[5][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(3),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_5_3 (
        .clk(clk),
        .start_in(start_in_w[5][3]),
        .start_out(start_out_w[5][3]),
        .key_data(key_data_w[5][3]),
        .op_in(inst_op_in_w[5][3]),
        .op_out(inst_op_out_w[5][3]),
        .gauss_op_in(op_in_w[5][3]),
        .gauss_op_out(op_out_w[5][3]),
        .data_in(data_in_w[5][3]),
        .data_out(data_out_w[5][3]),
        .dataB_in(dataB_in_w[5][3]),
        .dataB_out(dataB_out_w[5][3]),
        .dataA_in(dataA_in_w[5][3]),
        .dataA_out(dataA_out_w[5][3]),
        .r(r_w[5][3])
    );
                    
    // compute_unit(13, 4), (tile(1, 0), unit(5, 4))
                
    assign dataA_in_w[5][4] = dataA_out_w[5-1][4];
                    
    assign data_in_w[5][4] = data_out_w[5-1][4];
                    
    assign op_in_w[5][4] = op_out_w[5][4-1];
    assign inst_op_in_w[5][4] = inst_op_out_w[5][4-1];
    assign dataB_in_w[5][4] = dataB_out_w[5][4-1];
                    
    assign start_in_w[5][4] = start_out_w[5][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(4),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_5_4 (
        .clk(clk),
        .start_in(start_in_w[5][4]),
        .start_out(start_out_w[5][4]),
        .key_data(key_data_w[5][4]),
        .op_in(inst_op_in_w[5][4]),
        .op_out(inst_op_out_w[5][4]),
        .gauss_op_in(op_in_w[5][4]),
        .gauss_op_out(op_out_w[5][4]),
        .data_in(data_in_w[5][4]),
        .data_out(data_out_w[5][4]),
        .dataB_in(dataB_in_w[5][4]),
        .dataB_out(dataB_out_w[5][4]),
        .dataA_in(dataA_in_w[5][4]),
        .dataA_out(dataA_out_w[5][4]),
        .r(r_w[5][4])
    );
                    
    // compute_unit(14, 0), (tile(1, 0), unit(6, 0))
                
    assign dataA_in_w[6][0] = dataA_out_w[6-1][0];
                    
    assign data_in_w[6][0] = data_out_w[6-1][0];
                    
    assign op_in_w[6][0] = gauss_op_in[2*6+1:2*6];
    assign inst_op_in_w[6][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[6][0] = dataB_in[GF_BIT*6+(GF_BIT-1):GF_BIT*6];
                    
    assign start_in_w[6][0] = start_row[6];
    assign finish_in_w[6] = finish_row[6];
                    
    always @(posedge clk) begin
        start_tmp[6] <= start_row[6-1];
        start_row[6] <= start_tmp[6];
        finish_tmp[6] <= finish_row[6-1];
        finish_row[6] <= finish_tmp[6];
    end
                        
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(14),
        .COL_IDX(0),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_6_0 (
        .clk(clk),
        .start_in(start_in_w[6][0]),
        .start_out(start_out_w[6][0]),
        .key_data(key_data_w[6][0]),
        .op_in(inst_op_in_w[6][0]),
        .op_out(inst_op_out_w[6][0]),
        .gauss_op_in(op_in_w[6][0]),
        .gauss_op_out(op_out_w[6][0]),
        .data_in(data_in_w[6][0]),
        .data_out(data_out_w[6][0]),
        .dataB_in(dataB_in_w[6][0]),
        .dataB_out(dataB_out_w[6][0]),
        .dataA_in(dataA_in_w[6][0]),
        .dataA_out(dataA_out_w[6][0]),
        .r(r_w[6][0])
    );
                    
    // compute_unit(14, 1), (tile(1, 0), unit(6, 1))
                
    assign dataA_in_w[6][1] = dataA_out_w[6-1][1];
                    
    assign data_in_w[6][1] = data_out_w[6-1][1];
                    
    assign op_in_w[6][1] = op_out_w[6][1-1];
    assign inst_op_in_w[6][1] = inst_op_out_w[6][1-1];
    assign dataB_in_w[6][1] = dataB_out_w[6][1-1];
                    
    assign start_in_w[6][1] = start_out_w[6][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(1),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_6_1 (
        .clk(clk),
        .start_in(start_in_w[6][1]),
        .start_out(start_out_w[6][1]),
        .key_data(key_data_w[6][1]),
        .op_in(inst_op_in_w[6][1]),
        .op_out(inst_op_out_w[6][1]),
        .gauss_op_in(op_in_w[6][1]),
        .gauss_op_out(op_out_w[6][1]),
        .data_in(data_in_w[6][1]),
        .data_out(data_out_w[6][1]),
        .dataB_in(dataB_in_w[6][1]),
        .dataB_out(dataB_out_w[6][1]),
        .dataA_in(dataA_in_w[6][1]),
        .dataA_out(dataA_out_w[6][1]),
        .r(r_w[6][1])
    );
                    
    // compute_unit(14, 2), (tile(1, 0), unit(6, 2))
                
    assign dataA_in_w[6][2] = dataA_out_w[6-1][2];
                    
    assign data_in_w[6][2] = data_out_w[6-1][2];
                    
    assign op_in_w[6][2] = op_out_w[6][2-1];
    assign inst_op_in_w[6][2] = inst_op_out_w[6][2-1];
    assign dataB_in_w[6][2] = dataB_out_w[6][2-1];
                    
    assign start_in_w[6][2] = start_out_w[6][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(2),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_6_2 (
        .clk(clk),
        .start_in(start_in_w[6][2]),
        .start_out(start_out_w[6][2]),
        .key_data(key_data_w[6][2]),
        .op_in(inst_op_in_w[6][2]),
        .op_out(inst_op_out_w[6][2]),
        .gauss_op_in(op_in_w[6][2]),
        .gauss_op_out(op_out_w[6][2]),
        .data_in(data_in_w[6][2]),
        .data_out(data_out_w[6][2]),
        .dataB_in(dataB_in_w[6][2]),
        .dataB_out(dataB_out_w[6][2]),
        .dataA_in(dataA_in_w[6][2]),
        .dataA_out(dataA_out_w[6][2]),
        .r(r_w[6][2])
    );
                    
    // compute_unit(14, 3), (tile(1, 0), unit(6, 3))
                
    assign dataA_in_w[6][3] = dataA_out_w[6-1][3];
                    
    assign data_in_w[6][3] = data_out_w[6-1][3];
                    
    assign op_in_w[6][3] = op_out_w[6][3-1];
    assign inst_op_in_w[6][3] = inst_op_out_w[6][3-1];
    assign dataB_in_w[6][3] = dataB_out_w[6][3-1];
                    
    assign start_in_w[6][3] = start_out_w[6][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(3),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_6_3 (
        .clk(clk),
        .start_in(start_in_w[6][3]),
        .start_out(start_out_w[6][3]),
        .key_data(key_data_w[6][3]),
        .op_in(inst_op_in_w[6][3]),
        .op_out(inst_op_out_w[6][3]),
        .gauss_op_in(op_in_w[6][3]),
        .gauss_op_out(op_out_w[6][3]),
        .data_in(data_in_w[6][3]),
        .data_out(data_out_w[6][3]),
        .dataB_in(dataB_in_w[6][3]),
        .dataB_out(dataB_out_w[6][3]),
        .dataA_in(dataA_in_w[6][3]),
        .dataA_out(dataA_out_w[6][3]),
        .r(r_w[6][3])
    );
                    
    // compute_unit(14, 4), (tile(1, 0), unit(6, 4))
                
    assign dataA_in_w[6][4] = dataA_out_w[6-1][4];
                    
    assign data_in_w[6][4] = data_out_w[6-1][4];
                    
    assign op_in_w[6][4] = op_out_w[6][4-1];
    assign inst_op_in_w[6][4] = inst_op_out_w[6][4-1];
    assign dataB_in_w[6][4] = dataB_out_w[6][4-1];
                    
    assign start_in_w[6][4] = start_out_w[6][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(4),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_6_4 (
        .clk(clk),
        .start_in(start_in_w[6][4]),
        .start_out(start_out_w[6][4]),
        .key_data(key_data_w[6][4]),
        .op_in(inst_op_in_w[6][4]),
        .op_out(inst_op_out_w[6][4]),
        .gauss_op_in(op_in_w[6][4]),
        .gauss_op_out(op_out_w[6][4]),
        .data_in(data_in_w[6][4]),
        .data_out(data_out_w[6][4]),
        .dataB_in(dataB_in_w[6][4]),
        .dataB_out(dataB_out_w[6][4]),
        .dataA_in(dataA_in_w[6][4]),
        .dataA_out(dataA_out_w[6][4]),
        .r(r_w[6][4])
    );
                    
    // compute_unit(15, 0), (tile(1, 0), unit(7, 0))
                
    assign dataA_in_w[7][0] = dataA_out_w[7-1][0];
                    
    assign data_in_w[7][0] = data_out_w[7-1][0];
                    
    assign op_in_w[7][0] = gauss_op_in[2*7+1:2*7];
    assign inst_op_in_w[7][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[7][0] = dataB_in[GF_BIT*7+(GF_BIT-1):GF_BIT*7];
                    
    assign start_in_w[7][0] = start_row[7];
    assign finish_in_w[7] = finish_row[7];
                    
    always @(posedge clk) begin
        start_tmp[7] <= start_row[7-1];
        start_row[7] <= start_tmp[7];
        finish_tmp[7] <= finish_row[7-1];
        finish_row[7] <= finish_tmp[7];
    end
                        
    processor_BCD #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(4),
        .ROW_IDX(15),
        .COL_IDX(0),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_7_0 (
        .clk(clk),
        .start_in(start_in_w[7][0]),
        .start_out(start_out_w[7][0]),
        .key_data(key_data_w[7][0]),
        .op_in(inst_op_in_w[7][0]),
        .op_out(inst_op_out_w[7][0]),
        .gauss_op_in(op_in_w[7][0]),
        .gauss_op_out(op_out_w[7][0]),
        .data_in(data_in_w[7][0]),
        .data_out(data_out_w[7][0]),
        .dataB_in(dataB_in_w[7][0]),
        .dataB_out(dataB_out_w[7][0]),
        .dataA_in(dataA_in_w[7][0]),
        .dataA_out(dataA_out_w[7][0]),
        .r(r_w[7][0])
    );
                    
    // compute_unit(15, 1), (tile(1, 0), unit(7, 1))
                
    assign dataA_in_w[7][1] = dataA_out_w[7-1][1];
                    
    assign data_in_w[7][1] = data_out_w[7-1][1];
                    
    assign op_in_w[7][1] = op_out_w[7][1-1];
    assign inst_op_in_w[7][1] = inst_op_out_w[7][1-1];
    assign dataB_in_w[7][1] = dataB_out_w[7][1-1];
                    
    assign start_in_w[7][1] = start_out_w[7][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(1),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_7_1 (
        .clk(clk),
        .start_in(start_in_w[7][1]),
        .start_out(start_out_w[7][1]),
        .key_data(key_data_w[7][1]),
        .op_in(inst_op_in_w[7][1]),
        .op_out(inst_op_out_w[7][1]),
        .gauss_op_in(op_in_w[7][1]),
        .gauss_op_out(op_out_w[7][1]),
        .data_in(data_in_w[7][1]),
        .data_out(data_out_w[7][1]),
        .dataB_in(dataB_in_w[7][1]),
        .dataB_out(dataB_out_w[7][1]),
        .dataA_in(dataA_in_w[7][1]),
        .dataA_out(dataA_out_w[7][1]),
        .r(r_w[7][1])
    );
                    
    // compute_unit(15, 2), (tile(1, 0), unit(7, 2))
                
    assign dataA_in_w[7][2] = dataA_out_w[7-1][2];
                    
    assign data_in_w[7][2] = data_out_w[7-1][2];
                    
    assign op_in_w[7][2] = op_out_w[7][2-1];
    assign inst_op_in_w[7][2] = inst_op_out_w[7][2-1];
    assign dataB_in_w[7][2] = dataB_out_w[7][2-1];
                    
    assign start_in_w[7][2] = start_out_w[7][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(2),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_7_2 (
        .clk(clk),
        .start_in(start_in_w[7][2]),
        .start_out(start_out_w[7][2]),
        .key_data(key_data_w[7][2]),
        .op_in(inst_op_in_w[7][2]),
        .op_out(inst_op_out_w[7][2]),
        .gauss_op_in(op_in_w[7][2]),
        .gauss_op_out(op_out_w[7][2]),
        .data_in(data_in_w[7][2]),
        .data_out(data_out_w[7][2]),
        .dataB_in(dataB_in_w[7][2]),
        .dataB_out(dataB_out_w[7][2]),
        .dataA_in(dataA_in_w[7][2]),
        .dataA_out(dataA_out_w[7][2]),
        .r(r_w[7][2])
    );
                    
    // compute_unit(15, 3), (tile(1, 0), unit(7, 3))
                
    assign dataA_in_w[7][3] = dataA_out_w[7-1][3];
                    
    assign data_in_w[7][3] = data_out_w[7-1][3];
                    
    assign op_in_w[7][3] = op_out_w[7][3-1];
    assign inst_op_in_w[7][3] = inst_op_out_w[7][3-1];
    assign dataB_in_w[7][3] = dataB_out_w[7][3-1];
                    
    assign start_in_w[7][3] = start_out_w[7][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(3),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_7_3 (
        .clk(clk),
        .start_in(start_in_w[7][3]),
        .start_out(start_out_w[7][3]),
        .key_data(key_data_w[7][3]),
        .op_in(inst_op_in_w[7][3]),
        .op_out(inst_op_out_w[7][3]),
        .gauss_op_in(op_in_w[7][3]),
        .gauss_op_out(op_out_w[7][3]),
        .data_in(data_in_w[7][3]),
        .data_out(data_out_w[7][3]),
        .dataB_in(dataB_in_w[7][3]),
        .dataB_out(dataB_out_w[7][3]),
        .dataA_in(dataA_in_w[7][3]),
        .dataA_out(dataA_out_w[7][3]),
        .r(r_w[7][3])
    );
                    
    // compute_unit(15, 4), (tile(1, 0), unit(7, 4))
                
    assign dataA_in_w[7][4] = dataA_out_w[7-1][4];
                    
    assign data_in_w[7][4] = data_out_w[7-1][4];
                    
    assign op_in_w[7][4] = op_out_w[7][4-1];
    assign inst_op_in_w[7][4] = inst_op_out_w[7][4-1];
    assign dataB_in_w[7][4] = dataB_out_w[7][4-1];
                    
    assign start_in_w[7][4] = start_out_w[7][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(4),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(0),
        .NUM_PROC_COL(3)
    ) B_proc_7_4 (
        .clk(clk),
        .start_in(start_in_w[7][4]),
        .start_out(start_out_w[7][4]),
        .key_data(key_data_w[7][4]),
        .op_in(inst_op_in_w[7][4]),
        .op_out(inst_op_out_w[7][4]),
        .gauss_op_in(op_in_w[7][4]),
        .gauss_op_out(op_out_w[7][4]),
        .data_in(data_in_w[7][4]),
        .data_out(data_out_w[7][4]),
        .dataB_in(dataB_in_w[7][4]),
        .dataB_out(dataB_out_w[7][4]),
        .dataA_in(dataA_in_w[7][4]),
        .dataA_out(dataA_out_w[7][4]),
        .r(r_w[7][4])
    );
                    
    generate
        for (i = 0; i < COL; i=i+1) begin
            for (j = 0; j < GF_BIT; j=j+1) begin
                assign data_out[i*GF_BIT+j] = data_out_w[ROW-1][i][j];
            end
        end
    endgenerate
        
    generate
        for (i = 0; i < ROW; i=i+1) begin
            assign gauss_op_out[2*i+1:2*i] = op_out_w[i][COL-1];
            assign dataB_out[GF_BIT*i+(GF_BIT-1):GF_BIT*i] = dataB_out_w[i][COL-1];
        end
    endgenerate
        
    assign r_A_and = 1;
            
    reg start_out_tmp;
    reg finish_out_tmp;
    always @(posedge clk) begin
        start_out_tmp  <= start_row[ROW-1];
        finish_out_tmp <= finish_row[ROW-1];
        start_out      <= start_out_tmp;
        finish_out     <= finish_out_tmp;
    end

endmodule
        
// row = 8, col = 5
module tile_1_1#(
    parameter N = 16,
    parameter GF_BIT = 8,
    parameter OP_SIZE = 22,
    parameter ROW = 8,
    parameter COL = 5
)(
    input wire                      clk,
    input wire                      rst_n,
    input wire        [OP_SIZE-1:0] op_in,        // decide which operations
    input wire     [GF_BIT*COL-1:0] dataA_in,     // for mat_mul, load
    input wire          [2*ROW-1:0] gauss_op_in,  // for gauss
    input wire     [GF_BIT*ROW-1:0] dataB_in,     // for gauss
    input wire     [GF_BIT*COL-1:0] data_in,      // for gauss, store (not used in first row)
    input wire                      start_in, 
    input wire                      finish_in,
    output wire         [2*ROW-1:0] gauss_op_out, // for gauss
    output wire    [GF_BIT*ROW-1:0] dataB_out,    // for gauss
    output wire    [GF_BIT*COL-1:0] data_out,     // for gauss, store
    output reg                      start_out,
    output reg                      finish_out,
    output wire                     r_A_and
);
    
    localparam TILE_ROW_IDX = 1;
    localparam TILE_COL_IDX = 1;
    localparam NUM_PROC_COL = 3;
    localparam BANK = 5; 

    genvar i, j, k;
    integer n, m;

    wire                  start_in_w[0:ROW-1][0:COL-1];
    wire                 start_out_w[0:ROW-1][0:COL-1];
    wire                 finish_in_w[0:ROW-1];
    wire                finish_out_w[0:ROW-1];
    wire         [3:0]  inst_op_in_w[0:ROW-1][0:COL-1];
    wire         [3:0] inst_op_out_w[0:ROW-1][0:COL-1];
    wire         [1:0]       op_in_w[0:ROW-1][0:COL-1];
    wire         [1:0]      op_out_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    dataB_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]   dataB_out_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]           r_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]     data_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    dataA_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]   dataA_out_w[0:ROW-1][0:COL-1];
    reg   [GF_BIT-1:0]     data_in_r[1:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    data_out_w[0:ROW-1][0:COL-1];

    reg [ROW-1 : 1] start_tmp;
    reg [ROW-1 : 1] start_row;
    
    reg [ROW-1 : 1] finish_tmp;
    reg [ROW-1 : 1] finish_row;
    
    reg functionA_dup;
    always @(posedge clk) begin
        functionA_dup <= op_in[17];
    end

    wire [GF_BIT*8*BANK-1:0] key_data;
    wire          [GF_BIT-1:0] key_data_w[0:ROW-1][0:COL-1];
    wire                       key_wren;
    wire      [GF_BIT*ROW-1:0] key_write_data;
    generate
        if (GF_BIT*8 != 0) begin: key_mem
            assign key_wren = op_in[14];
            bram16Kx4 #(
                .WIDTH(GF_BIT*8),
                .DELAY(1)
            ) mem_inst (
                .clock (clk),
                .data (key_write_data),
                .address (op_in[14-1:0]),
                .wren (key_wren),
                .q (key_data)
            );
            for (j = 0; j < ROW; j=j+1) begin
                for (k = 0; k < BANK; k=k+1) begin
                    assign key_data_w[j][k] = (j < 8) ? key_data[(j+k*8)*GF_BIT+:GF_BIT] : 0; // load from
                end
                assign key_write_data[j*GF_BIT+:GF_BIT] = r_w[j][0];                        // write to
            end
        end else begin
            for (j = 0; j < ROW; j=j+1) begin
                for (k = 0; k < BANK; k=k+1) begin
                    assign key_data_w[j][k] = 0; // load from
                end
            end
        end
    endgenerate

    // always@(posedge clk) begin
    //     if ((op_in[OP_SIZE-1:OP_SIZE-4] == 7)) begin
    //         $display("_____________________________________________");
    //         $display("| 1_1, 8, 5");
    //         $display("| dataA_in: %x,  dataB_in: %x, addr: %d, key_data: %x, key_write_data: %x, key_wren: %d", dataA_in, dataB_in, op_in[14-1:0], key_data, key_write_data, key_wren);
    //         $display("|____________________________________________");
    //     end
    // end
        
    // compute_unit(8, 5), (tile(1, 1), unit(0, 0))
                
    assign dataA_in_w[0][0] = dataA_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign data_in_w[0][0] = data_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign op_in_w[0][0] = gauss_op_in[2*0+1:2*0];
    assign inst_op_in_w[0][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[0][0] = dataB_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign start_in_w[0][0] = start_in;
    assign finish_in_w[0] = finish_in;
                    
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(5),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_0_0 (
        .clk(clk),
        .start_in(start_in_w[0][0]),
        .start_out(start_out_w[0][0]),
        .key_data(key_data_w[0][0]),
        .op_in(inst_op_in_w[0][0]),
        .op_out(inst_op_out_w[0][0]),
        .gauss_op_in(op_in_w[0][0]),
        .gauss_op_out(op_out_w[0][0]),
        .data_in(data_in_w[0][0]),
        .data_out(data_out_w[0][0]),
        .dataB_in(dataB_in_w[0][0]),
        .dataB_out(dataB_out_w[0][0]),
        .dataA_in(dataA_in_w[0][0]),
        .dataA_out(dataA_out_w[0][0]),
        .r(r_w[0][0])
    );
                    
    // compute_unit(8, 6), (tile(1, 1), unit(0, 1))
                
    assign dataA_in_w[0][1] = dataA_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign data_in_w[0][1] = data_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign op_in_w[0][1] = op_out_w[0][1-1];
    assign inst_op_in_w[0][1] = inst_op_out_w[0][1-1];
    assign dataB_in_w[0][1] = dataB_out_w[0][1-1];
                    
    assign start_in_w[0][1] = start_out_w[0][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(6),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_0_1 (
        .clk(clk),
        .start_in(start_in_w[0][1]),
        .start_out(start_out_w[0][1]),
        .key_data(key_data_w[0][1]),
        .op_in(inst_op_in_w[0][1]),
        .op_out(inst_op_out_w[0][1]),
        .gauss_op_in(op_in_w[0][1]),
        .gauss_op_out(op_out_w[0][1]),
        .data_in(data_in_w[0][1]),
        .data_out(data_out_w[0][1]),
        .dataB_in(dataB_in_w[0][1]),
        .dataB_out(dataB_out_w[0][1]),
        .dataA_in(dataA_in_w[0][1]),
        .dataA_out(dataA_out_w[0][1]),
        .r(r_w[0][1])
    );
                    
    // compute_unit(8, 7), (tile(1, 1), unit(0, 2))
                
    assign dataA_in_w[0][2] = dataA_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign data_in_w[0][2] = data_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign op_in_w[0][2] = op_out_w[0][2-1];
    assign inst_op_in_w[0][2] = inst_op_out_w[0][2-1];
    assign dataB_in_w[0][2] = dataB_out_w[0][2-1];
                    
    assign start_in_w[0][2] = start_out_w[0][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(7),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_0_2 (
        .clk(clk),
        .start_in(start_in_w[0][2]),
        .start_out(start_out_w[0][2]),
        .key_data(key_data_w[0][2]),
        .op_in(inst_op_in_w[0][2]),
        .op_out(inst_op_out_w[0][2]),
        .gauss_op_in(op_in_w[0][2]),
        .gauss_op_out(op_out_w[0][2]),
        .data_in(data_in_w[0][2]),
        .data_out(data_out_w[0][2]),
        .dataB_in(dataB_in_w[0][2]),
        .dataB_out(dataB_out_w[0][2]),
        .dataA_in(dataA_in_w[0][2]),
        .dataA_out(dataA_out_w[0][2]),
        .r(r_w[0][2])
    );
                    
    // compute_unit(8, 8), (tile(1, 1), unit(0, 3))
                
    assign dataA_in_w[0][3] = dataA_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign data_in_w[0][3] = data_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign op_in_w[0][3] = op_out_w[0][3-1];
    assign inst_op_in_w[0][3] = inst_op_out_w[0][3-1];
    assign dataB_in_w[0][3] = dataB_out_w[0][3-1];
                    
    assign start_in_w[0][3] = start_out_w[0][3-1];
                    
    processor_AB #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(8),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) AB_proc_0_3 (
        .clk(clk),
        .start_in(start_in_w[0][3]),
        .start_out(start_out_w[0][3]),
        .finish_in(finish_in_w[0]),
        .finish_out(finish_out_w[0]),
        .key_data(key_data_w[0][3]),
        .op_in(inst_op_in_w[0][3]),
        .op_out(inst_op_out_w[0][3]),
        .gauss_op_in(op_in_w[0][3]),
        .gauss_op_out(op_out_w[0][3]),
        .data_in(data_in_w[0][3]),
        .data_out(data_out_w[0][3]),
        .dataB_in(dataB_in_w[0][3]),
        .dataB_out(dataB_out_w[0][3]),
        .dataA_in(dataA_in_w[0][3]),
        .dataA_out(dataA_out_w[0][3]),
        .r(r_w[0][3]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(8, 9), (tile(1, 1), unit(0, 4))
                
    assign dataA_in_w[0][4] = dataA_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign data_in_w[0][4] = data_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign op_in_w[0][4] = op_out_w[0][4-1];
    assign inst_op_in_w[0][4] = inst_op_out_w[0][4-1];
    assign dataB_in_w[0][4] = dataB_out_w[0][4-1];
                    
    assign start_in_w[0][4] = start_out_w[0][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(9),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_0_4 (
        .clk(clk),
        .start_in(start_in_w[0][4]),
        .start_out(start_out_w[0][4]),
        .key_data(key_data_w[0][4]),
        .op_in(inst_op_in_w[0][4]),
        .op_out(inst_op_out_w[0][4]),
        .gauss_op_in(op_in_w[0][4]),
        .gauss_op_out(op_out_w[0][4]),
        .data_in(data_in_w[0][4]),
        .data_out(data_out_w[0][4]),
        .dataB_in(dataB_in_w[0][4]),
        .dataB_out(dataB_out_w[0][4]),
        .dataA_in(dataA_in_w[0][4]),
        .dataA_out(dataA_out_w[0][4]),
        .r(r_w[0][4])
    );
                    
    // compute_unit(9, 5), (tile(1, 1), unit(1, 0))
                
    assign dataA_in_w[1][0] = dataA_out_w[1-1][0];
                    
    assign data_in_w[1][0] = data_out_w[1-1][0];
                    
    assign op_in_w[1][0] = gauss_op_in[2*1+1:2*1];
    assign inst_op_in_w[1][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[1][0] = dataB_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign start_in_w[1][0] = start_row[1];
    assign finish_in_w[1] = finish_row[1];
                    
    always @(posedge clk) begin
        start_tmp[1] <= start_in;
        start_row[1] <= start_tmp[1];
        finish_tmp[1] <= finish_in;
        finish_row[1] <= finish_tmp[1];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(5),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_1_0 (
        .clk(clk),
        .start_in(start_in_w[1][0]),
        .start_out(start_out_w[1][0]),
        .key_data(key_data_w[1][0]),
        .op_in(inst_op_in_w[1][0]),
        .op_out(inst_op_out_w[1][0]),
        .gauss_op_in(op_in_w[1][0]),
        .gauss_op_out(op_out_w[1][0]),
        .data_in(data_in_w[1][0]),
        .data_out(data_out_w[1][0]),
        .dataB_in(dataB_in_w[1][0]),
        .dataB_out(dataB_out_w[1][0]),
        .dataA_in(dataA_in_w[1][0]),
        .dataA_out(dataA_out_w[1][0]),
        .r(r_w[1][0])
    );
                    
    // compute_unit(9, 6), (tile(1, 1), unit(1, 1))
                
    assign dataA_in_w[1][1] = dataA_out_w[1-1][1];
                    
    assign data_in_w[1][1] = data_out_w[1-1][1];
                    
    assign op_in_w[1][1] = op_out_w[1][1-1];
    assign inst_op_in_w[1][1] = inst_op_out_w[1][1-1];
    assign dataB_in_w[1][1] = dataB_out_w[1][1-1];
                    
    assign start_in_w[1][1] = start_out_w[1][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(6),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_1_1 (
        .clk(clk),
        .start_in(start_in_w[1][1]),
        .start_out(start_out_w[1][1]),
        .key_data(key_data_w[1][1]),
        .op_in(inst_op_in_w[1][1]),
        .op_out(inst_op_out_w[1][1]),
        .gauss_op_in(op_in_w[1][1]),
        .gauss_op_out(op_out_w[1][1]),
        .data_in(data_in_w[1][1]),
        .data_out(data_out_w[1][1]),
        .dataB_in(dataB_in_w[1][1]),
        .dataB_out(dataB_out_w[1][1]),
        .dataA_in(dataA_in_w[1][1]),
        .dataA_out(dataA_out_w[1][1]),
        .r(r_w[1][1])
    );
                    
    // compute_unit(9, 7), (tile(1, 1), unit(1, 2))
                
    assign dataA_in_w[1][2] = dataA_out_w[1-1][2];
                    
    assign data_in_w[1][2] = data_out_w[1-1][2];
                    
    assign op_in_w[1][2] = op_out_w[1][2-1];
    assign inst_op_in_w[1][2] = inst_op_out_w[1][2-1];
    assign dataB_in_w[1][2] = dataB_out_w[1][2-1];
                    
    assign start_in_w[1][2] = start_out_w[1][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(7),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_1_2 (
        .clk(clk),
        .start_in(start_in_w[1][2]),
        .start_out(start_out_w[1][2]),
        .key_data(key_data_w[1][2]),
        .op_in(inst_op_in_w[1][2]),
        .op_out(inst_op_out_w[1][2]),
        .gauss_op_in(op_in_w[1][2]),
        .gauss_op_out(op_out_w[1][2]),
        .data_in(data_in_w[1][2]),
        .data_out(data_out_w[1][2]),
        .dataB_in(dataB_in_w[1][2]),
        .dataB_out(dataB_out_w[1][2]),
        .dataA_in(dataA_in_w[1][2]),
        .dataA_out(dataA_out_w[1][2]),
        .r(r_w[1][2])
    );
                    
    // compute_unit(9, 8), (tile(1, 1), unit(1, 3))
                
    assign dataA_in_w[1][3] = dataA_out_w[1-1][3];
                    
    assign data_in_w[1][3] = data_out_w[1-1][3];
                    
    assign op_in_w[1][3] = op_out_w[1][3-1];
    assign inst_op_in_w[1][3] = inst_op_out_w[1][3-1];
    assign dataB_in_w[1][3] = dataB_out_w[1][3-1];
                    
    assign start_in_w[1][3] = start_out_w[1][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(8),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_1_3 (
        .clk(clk),
        .start_in(start_in_w[1][3]),
        .start_out(start_out_w[1][3]),
        .key_data(key_data_w[1][3]),
        .op_in(inst_op_in_w[1][3]),
        .op_out(inst_op_out_w[1][3]),
        .gauss_op_in(op_in_w[1][3]),
        .gauss_op_out(op_out_w[1][3]),
        .data_in(data_in_w[1][3]),
        .data_out(data_out_w[1][3]),
        .dataB_in(dataB_in_w[1][3]),
        .dataB_out(dataB_out_w[1][3]),
        .dataA_in(dataA_in_w[1][3]),
        .dataA_out(dataA_out_w[1][3]),
        .r(r_w[1][3])
    );
                    
    // compute_unit(9, 9), (tile(1, 1), unit(1, 4))
                
    assign dataA_in_w[1][4] = dataA_out_w[1-1][4];
                    
    assign data_in_w[1][4] = data_out_w[1-1][4];
                    
    assign op_in_w[1][4] = op_out_w[1][4-1];
    assign inst_op_in_w[1][4] = inst_op_out_w[1][4-1];
    assign dataB_in_w[1][4] = dataB_out_w[1][4-1];
                    
    assign start_in_w[1][4] = start_out_w[1][4-1];
                    
    processor_AB #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(9),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) AB_proc_1_4 (
        .clk(clk),
        .start_in(start_in_w[1][4]),
        .start_out(start_out_w[1][4]),
        .finish_in(finish_in_w[1]),
        .finish_out(finish_out_w[1]),
        .key_data(key_data_w[1][4]),
        .op_in(inst_op_in_w[1][4]),
        .op_out(inst_op_out_w[1][4]),
        .gauss_op_in(op_in_w[1][4]),
        .gauss_op_out(op_out_w[1][4]),
        .data_in(data_in_w[1][4]),
        .data_out(data_out_w[1][4]),
        .dataB_in(dataB_in_w[1][4]),
        .dataB_out(dataB_out_w[1][4]),
        .dataA_in(dataA_in_w[1][4]),
        .dataA_out(dataA_out_w[1][4]),
        .r(r_w[1][4]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(10, 5), (tile(1, 1), unit(2, 0))
                
    assign dataA_in_w[2][0] = dataA_out_w[2-1][0];
                    
    assign data_in_w[2][0] = data_out_w[2-1][0];
                    
    assign op_in_w[2][0] = gauss_op_in[2*2+1:2*2];
    assign inst_op_in_w[2][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[2][0] = dataB_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign start_in_w[2][0] = start_row[2];
    assign finish_in_w[2] = finish_row[2];
                    
    always @(posedge clk) begin
        start_tmp[2] <= start_row[2-1];
        start_row[2] <= start_tmp[2];
        finish_tmp[2] <= finish_row[2-1];
        finish_row[2] <= finish_tmp[2];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(5),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_2_0 (
        .clk(clk),
        .start_in(start_in_w[2][0]),
        .start_out(start_out_w[2][0]),
        .key_data(key_data_w[2][0]),
        .op_in(inst_op_in_w[2][0]),
        .op_out(inst_op_out_w[2][0]),
        .gauss_op_in(op_in_w[2][0]),
        .gauss_op_out(op_out_w[2][0]),
        .data_in(data_in_w[2][0]),
        .data_out(data_out_w[2][0]),
        .dataB_in(dataB_in_w[2][0]),
        .dataB_out(dataB_out_w[2][0]),
        .dataA_in(dataA_in_w[2][0]),
        .dataA_out(dataA_out_w[2][0]),
        .r(r_w[2][0])
    );
                    
    // compute_unit(10, 6), (tile(1, 1), unit(2, 1))
                
    assign dataA_in_w[2][1] = dataA_out_w[2-1][1];
                    
    assign data_in_w[2][1] = data_out_w[2-1][1];
                    
    assign op_in_w[2][1] = op_out_w[2][1-1];
    assign inst_op_in_w[2][1] = inst_op_out_w[2][1-1];
    assign dataB_in_w[2][1] = dataB_out_w[2][1-1];
                    
    assign start_in_w[2][1] = start_out_w[2][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(6),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_2_1 (
        .clk(clk),
        .start_in(start_in_w[2][1]),
        .start_out(start_out_w[2][1]),
        .key_data(key_data_w[2][1]),
        .op_in(inst_op_in_w[2][1]),
        .op_out(inst_op_out_w[2][1]),
        .gauss_op_in(op_in_w[2][1]),
        .gauss_op_out(op_out_w[2][1]),
        .data_in(data_in_w[2][1]),
        .data_out(data_out_w[2][1]),
        .dataB_in(dataB_in_w[2][1]),
        .dataB_out(dataB_out_w[2][1]),
        .dataA_in(dataA_in_w[2][1]),
        .dataA_out(dataA_out_w[2][1]),
        .r(r_w[2][1])
    );
                    
    // compute_unit(10, 7), (tile(1, 1), unit(2, 2))
                
    assign dataA_in_w[2][2] = dataA_out_w[2-1][2];
                    
    assign data_in_w[2][2] = data_out_w[2-1][2];
                    
    assign op_in_w[2][2] = op_out_w[2][2-1];
    assign inst_op_in_w[2][2] = inst_op_out_w[2][2-1];
    assign dataB_in_w[2][2] = dataB_out_w[2][2-1];
                    
    assign start_in_w[2][2] = start_out_w[2][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(7),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_2_2 (
        .clk(clk),
        .start_in(start_in_w[2][2]),
        .start_out(start_out_w[2][2]),
        .key_data(key_data_w[2][2]),
        .op_in(inst_op_in_w[2][2]),
        .op_out(inst_op_out_w[2][2]),
        .gauss_op_in(op_in_w[2][2]),
        .gauss_op_out(op_out_w[2][2]),
        .data_in(data_in_w[2][2]),
        .data_out(data_out_w[2][2]),
        .dataB_in(dataB_in_w[2][2]),
        .dataB_out(dataB_out_w[2][2]),
        .dataA_in(dataA_in_w[2][2]),
        .dataA_out(dataA_out_w[2][2]),
        .r(r_w[2][2])
    );
                    
    // compute_unit(10, 8), (tile(1, 1), unit(2, 3))
                
    assign dataA_in_w[2][3] = dataA_out_w[2-1][3];
                    
    assign data_in_w[2][3] = data_out_w[2-1][3];
                    
    assign op_in_w[2][3] = op_out_w[2][3-1];
    assign inst_op_in_w[2][3] = inst_op_out_w[2][3-1];
    assign dataB_in_w[2][3] = dataB_out_w[2][3-1];
                    
    assign start_in_w[2][3] = start_out_w[2][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(8),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_2_3 (
        .clk(clk),
        .start_in(start_in_w[2][3]),
        .start_out(start_out_w[2][3]),
        .key_data(key_data_w[2][3]),
        .op_in(inst_op_in_w[2][3]),
        .op_out(inst_op_out_w[2][3]),
        .gauss_op_in(op_in_w[2][3]),
        .gauss_op_out(op_out_w[2][3]),
        .data_in(data_in_w[2][3]),
        .data_out(data_out_w[2][3]),
        .dataB_in(dataB_in_w[2][3]),
        .dataB_out(dataB_out_w[2][3]),
        .dataA_in(dataA_in_w[2][3]),
        .dataA_out(dataA_out_w[2][3]),
        .r(r_w[2][3])
    );
                    
    // compute_unit(10, 9), (tile(1, 1), unit(2, 4))
                
    assign dataA_in_w[2][4] = dataA_out_w[2-1][4];
                    
    assign data_in_w[2][4] = data_out_w[2-1][4];
                    
    assign op_in_w[2][4] = op_out_w[2][4-1];
    assign inst_op_in_w[2][4] = inst_op_out_w[2][4-1];
    assign dataB_in_w[2][4] = dataB_out_w[2][4-1];
                    
    assign start_in_w[2][4] = start_out_w[2][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(9),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_2_4 (
        .clk(clk),
        .start_in(start_in_w[2][4]),
        .start_out(start_out_w[2][4]),
        .key_data(key_data_w[2][4]),
        .op_in(inst_op_in_w[2][4]),
        .op_out(inst_op_out_w[2][4]),
        .gauss_op_in(op_in_w[2][4]),
        .gauss_op_out(op_out_w[2][4]),
        .data_in(data_in_w[2][4]),
        .data_out(data_out_w[2][4]),
        .dataB_in(dataB_in_w[2][4]),
        .dataB_out(dataB_out_w[2][4]),
        .dataA_in(dataA_in_w[2][4]),
        .dataA_out(dataA_out_w[2][4]),
        .r(r_w[2][4])
    );
                    
    // compute_unit(11, 5), (tile(1, 1), unit(3, 0))
                
    assign dataA_in_w[3][0] = dataA_out_w[3-1][0];
                    
    assign data_in_w[3][0] = data_out_w[3-1][0];
                    
    assign op_in_w[3][0] = gauss_op_in[2*3+1:2*3];
    assign inst_op_in_w[3][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[3][0] = dataB_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign start_in_w[3][0] = start_row[3];
    assign finish_in_w[3] = finish_row[3];
                    
    always @(posedge clk) begin
        start_tmp[3] <= start_row[3-1];
        start_row[3] <= start_tmp[3];
        finish_tmp[3] <= finish_row[3-1];
        finish_row[3] <= finish_tmp[3];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(5),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_3_0 (
        .clk(clk),
        .start_in(start_in_w[3][0]),
        .start_out(start_out_w[3][0]),
        .key_data(key_data_w[3][0]),
        .op_in(inst_op_in_w[3][0]),
        .op_out(inst_op_out_w[3][0]),
        .gauss_op_in(op_in_w[3][0]),
        .gauss_op_out(op_out_w[3][0]),
        .data_in(data_in_w[3][0]),
        .data_out(data_out_w[3][0]),
        .dataB_in(dataB_in_w[3][0]),
        .dataB_out(dataB_out_w[3][0]),
        .dataA_in(dataA_in_w[3][0]),
        .dataA_out(dataA_out_w[3][0]),
        .r(r_w[3][0])
    );
                    
    // compute_unit(11, 6), (tile(1, 1), unit(3, 1))
                
    assign dataA_in_w[3][1] = dataA_out_w[3-1][1];
                    
    assign data_in_w[3][1] = data_out_w[3-1][1];
                    
    assign op_in_w[3][1] = op_out_w[3][1-1];
    assign inst_op_in_w[3][1] = inst_op_out_w[3][1-1];
    assign dataB_in_w[3][1] = dataB_out_w[3][1-1];
                    
    assign start_in_w[3][1] = start_out_w[3][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(6),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_3_1 (
        .clk(clk),
        .start_in(start_in_w[3][1]),
        .start_out(start_out_w[3][1]),
        .key_data(key_data_w[3][1]),
        .op_in(inst_op_in_w[3][1]),
        .op_out(inst_op_out_w[3][1]),
        .gauss_op_in(op_in_w[3][1]),
        .gauss_op_out(op_out_w[3][1]),
        .data_in(data_in_w[3][1]),
        .data_out(data_out_w[3][1]),
        .dataB_in(dataB_in_w[3][1]),
        .dataB_out(dataB_out_w[3][1]),
        .dataA_in(dataA_in_w[3][1]),
        .dataA_out(dataA_out_w[3][1]),
        .r(r_w[3][1])
    );
                    
    // compute_unit(11, 7), (tile(1, 1), unit(3, 2))
                
    assign dataA_in_w[3][2] = dataA_out_w[3-1][2];
                    
    assign data_in_w[3][2] = data_out_w[3-1][2];
                    
    assign op_in_w[3][2] = op_out_w[3][2-1];
    assign inst_op_in_w[3][2] = inst_op_out_w[3][2-1];
    assign dataB_in_w[3][2] = dataB_out_w[3][2-1];
                    
    assign start_in_w[3][2] = start_out_w[3][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(7),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_3_2 (
        .clk(clk),
        .start_in(start_in_w[3][2]),
        .start_out(start_out_w[3][2]),
        .key_data(key_data_w[3][2]),
        .op_in(inst_op_in_w[3][2]),
        .op_out(inst_op_out_w[3][2]),
        .gauss_op_in(op_in_w[3][2]),
        .gauss_op_out(op_out_w[3][2]),
        .data_in(data_in_w[3][2]),
        .data_out(data_out_w[3][2]),
        .dataB_in(dataB_in_w[3][2]),
        .dataB_out(dataB_out_w[3][2]),
        .dataA_in(dataA_in_w[3][2]),
        .dataA_out(dataA_out_w[3][2]),
        .r(r_w[3][2])
    );
                    
    // compute_unit(11, 8), (tile(1, 1), unit(3, 3))
                
    assign dataA_in_w[3][3] = dataA_out_w[3-1][3];
                    
    assign data_in_w[3][3] = data_out_w[3-1][3];
                    
    assign op_in_w[3][3] = op_out_w[3][3-1];
    assign inst_op_in_w[3][3] = inst_op_out_w[3][3-1];
    assign dataB_in_w[3][3] = dataB_out_w[3][3-1];
                    
    assign start_in_w[3][3] = start_out_w[3][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(8),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_3_3 (
        .clk(clk),
        .start_in(start_in_w[3][3]),
        .start_out(start_out_w[3][3]),
        .key_data(key_data_w[3][3]),
        .op_in(inst_op_in_w[3][3]),
        .op_out(inst_op_out_w[3][3]),
        .gauss_op_in(op_in_w[3][3]),
        .gauss_op_out(op_out_w[3][3]),
        .data_in(data_in_w[3][3]),
        .data_out(data_out_w[3][3]),
        .dataB_in(dataB_in_w[3][3]),
        .dataB_out(dataB_out_w[3][3]),
        .dataA_in(dataA_in_w[3][3]),
        .dataA_out(dataA_out_w[3][3]),
        .r(r_w[3][3])
    );
                    
    // compute_unit(11, 9), (tile(1, 1), unit(3, 4))
                
    assign dataA_in_w[3][4] = dataA_out_w[3-1][4];
                    
    assign data_in_w[3][4] = data_out_w[3-1][4];
                    
    assign op_in_w[3][4] = op_out_w[3][4-1];
    assign inst_op_in_w[3][4] = inst_op_out_w[3][4-1];
    assign dataB_in_w[3][4] = dataB_out_w[3][4-1];
                    
    assign start_in_w[3][4] = start_out_w[3][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(9),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_3_4 (
        .clk(clk),
        .start_in(start_in_w[3][4]),
        .start_out(start_out_w[3][4]),
        .key_data(key_data_w[3][4]),
        .op_in(inst_op_in_w[3][4]),
        .op_out(inst_op_out_w[3][4]),
        .gauss_op_in(op_in_w[3][4]),
        .gauss_op_out(op_out_w[3][4]),
        .data_in(data_in_w[3][4]),
        .data_out(data_out_w[3][4]),
        .dataB_in(dataB_in_w[3][4]),
        .dataB_out(dataB_out_w[3][4]),
        .dataA_in(dataA_in_w[3][4]),
        .dataA_out(dataA_out_w[3][4]),
        .r(r_w[3][4])
    );
                    
    // compute_unit(12, 5), (tile(1, 1), unit(4, 0))
                
    assign dataA_in_w[4][0] = dataA_out_w[4-1][0];
                    
    assign data_in_w[4][0] = data_out_w[4-1][0];
                    
    assign op_in_w[4][0] = gauss_op_in[2*4+1:2*4];
    assign inst_op_in_w[4][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[4][0] = dataB_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign start_in_w[4][0] = start_row[4];
    assign finish_in_w[4] = finish_row[4];
                    
    always @(posedge clk) begin
        start_tmp[4] <= start_row[4-1];
        start_row[4] <= start_tmp[4];
        finish_tmp[4] <= finish_row[4-1];
        finish_row[4] <= finish_tmp[4];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(5),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_4_0 (
        .clk(clk),
        .start_in(start_in_w[4][0]),
        .start_out(start_out_w[4][0]),
        .key_data(key_data_w[4][0]),
        .op_in(inst_op_in_w[4][0]),
        .op_out(inst_op_out_w[4][0]),
        .gauss_op_in(op_in_w[4][0]),
        .gauss_op_out(op_out_w[4][0]),
        .data_in(data_in_w[4][0]),
        .data_out(data_out_w[4][0]),
        .dataB_in(dataB_in_w[4][0]),
        .dataB_out(dataB_out_w[4][0]),
        .dataA_in(dataA_in_w[4][0]),
        .dataA_out(dataA_out_w[4][0]),
        .r(r_w[4][0])
    );
                    
    // compute_unit(12, 6), (tile(1, 1), unit(4, 1))
                
    assign dataA_in_w[4][1] = dataA_out_w[4-1][1];
                    
    assign data_in_w[4][1] = data_out_w[4-1][1];
                    
    assign op_in_w[4][1] = op_out_w[4][1-1];
    assign inst_op_in_w[4][1] = inst_op_out_w[4][1-1];
    assign dataB_in_w[4][1] = dataB_out_w[4][1-1];
                    
    assign start_in_w[4][1] = start_out_w[4][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(6),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_4_1 (
        .clk(clk),
        .start_in(start_in_w[4][1]),
        .start_out(start_out_w[4][1]),
        .key_data(key_data_w[4][1]),
        .op_in(inst_op_in_w[4][1]),
        .op_out(inst_op_out_w[4][1]),
        .gauss_op_in(op_in_w[4][1]),
        .gauss_op_out(op_out_w[4][1]),
        .data_in(data_in_w[4][1]),
        .data_out(data_out_w[4][1]),
        .dataB_in(dataB_in_w[4][1]),
        .dataB_out(dataB_out_w[4][1]),
        .dataA_in(dataA_in_w[4][1]),
        .dataA_out(dataA_out_w[4][1]),
        .r(r_w[4][1])
    );
                    
    // compute_unit(12, 7), (tile(1, 1), unit(4, 2))
                
    assign dataA_in_w[4][2] = dataA_out_w[4-1][2];
                    
    assign data_in_w[4][2] = data_out_w[4-1][2];
                    
    assign op_in_w[4][2] = op_out_w[4][2-1];
    assign inst_op_in_w[4][2] = inst_op_out_w[4][2-1];
    assign dataB_in_w[4][2] = dataB_out_w[4][2-1];
                    
    assign start_in_w[4][2] = start_out_w[4][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(7),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_4_2 (
        .clk(clk),
        .start_in(start_in_w[4][2]),
        .start_out(start_out_w[4][2]),
        .key_data(key_data_w[4][2]),
        .op_in(inst_op_in_w[4][2]),
        .op_out(inst_op_out_w[4][2]),
        .gauss_op_in(op_in_w[4][2]),
        .gauss_op_out(op_out_w[4][2]),
        .data_in(data_in_w[4][2]),
        .data_out(data_out_w[4][2]),
        .dataB_in(dataB_in_w[4][2]),
        .dataB_out(dataB_out_w[4][2]),
        .dataA_in(dataA_in_w[4][2]),
        .dataA_out(dataA_out_w[4][2]),
        .r(r_w[4][2])
    );
                    
    // compute_unit(12, 8), (tile(1, 1), unit(4, 3))
                
    assign dataA_in_w[4][3] = dataA_out_w[4-1][3];
                    
    assign data_in_w[4][3] = data_out_w[4-1][3];
                    
    assign op_in_w[4][3] = op_out_w[4][3-1];
    assign inst_op_in_w[4][3] = inst_op_out_w[4][3-1];
    assign dataB_in_w[4][3] = dataB_out_w[4][3-1];
                    
    assign start_in_w[4][3] = start_out_w[4][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(8),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_4_3 (
        .clk(clk),
        .start_in(start_in_w[4][3]),
        .start_out(start_out_w[4][3]),
        .key_data(key_data_w[4][3]),
        .op_in(inst_op_in_w[4][3]),
        .op_out(inst_op_out_w[4][3]),
        .gauss_op_in(op_in_w[4][3]),
        .gauss_op_out(op_out_w[4][3]),
        .data_in(data_in_w[4][3]),
        .data_out(data_out_w[4][3]),
        .dataB_in(dataB_in_w[4][3]),
        .dataB_out(dataB_out_w[4][3]),
        .dataA_in(dataA_in_w[4][3]),
        .dataA_out(dataA_out_w[4][3]),
        .r(r_w[4][3])
    );
                    
    // compute_unit(12, 9), (tile(1, 1), unit(4, 4))
                
    assign dataA_in_w[4][4] = dataA_out_w[4-1][4];
                    
    assign data_in_w[4][4] = data_out_w[4-1][4];
                    
    assign op_in_w[4][4] = op_out_w[4][4-1];
    assign inst_op_in_w[4][4] = inst_op_out_w[4][4-1];
    assign dataB_in_w[4][4] = dataB_out_w[4][4-1];
                    
    assign start_in_w[4][4] = start_out_w[4][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(9),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_4_4 (
        .clk(clk),
        .start_in(start_in_w[4][4]),
        .start_out(start_out_w[4][4]),
        .key_data(key_data_w[4][4]),
        .op_in(inst_op_in_w[4][4]),
        .op_out(inst_op_out_w[4][4]),
        .gauss_op_in(op_in_w[4][4]),
        .gauss_op_out(op_out_w[4][4]),
        .data_in(data_in_w[4][4]),
        .data_out(data_out_w[4][4]),
        .dataB_in(dataB_in_w[4][4]),
        .dataB_out(dataB_out_w[4][4]),
        .dataA_in(dataA_in_w[4][4]),
        .dataA_out(dataA_out_w[4][4]),
        .r(r_w[4][4])
    );
                    
    // compute_unit(13, 5), (tile(1, 1), unit(5, 0))
                
    assign dataA_in_w[5][0] = dataA_out_w[5-1][0];
                    
    assign data_in_w[5][0] = data_out_w[5-1][0];
                    
    assign op_in_w[5][0] = gauss_op_in[2*5+1:2*5];
    assign inst_op_in_w[5][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[5][0] = dataB_in[GF_BIT*5+(GF_BIT-1):GF_BIT*5];
                    
    assign start_in_w[5][0] = start_row[5];
    assign finish_in_w[5] = finish_row[5];
                    
    always @(posedge clk) begin
        start_tmp[5] <= start_row[5-1];
        start_row[5] <= start_tmp[5];
        finish_tmp[5] <= finish_row[5-1];
        finish_row[5] <= finish_tmp[5];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(5),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_5_0 (
        .clk(clk),
        .start_in(start_in_w[5][0]),
        .start_out(start_out_w[5][0]),
        .key_data(key_data_w[5][0]),
        .op_in(inst_op_in_w[5][0]),
        .op_out(inst_op_out_w[5][0]),
        .gauss_op_in(op_in_w[5][0]),
        .gauss_op_out(op_out_w[5][0]),
        .data_in(data_in_w[5][0]),
        .data_out(data_out_w[5][0]),
        .dataB_in(dataB_in_w[5][0]),
        .dataB_out(dataB_out_w[5][0]),
        .dataA_in(dataA_in_w[5][0]),
        .dataA_out(dataA_out_w[5][0]),
        .r(r_w[5][0])
    );
                    
    // compute_unit(13, 6), (tile(1, 1), unit(5, 1))
                
    assign dataA_in_w[5][1] = dataA_out_w[5-1][1];
                    
    assign data_in_w[5][1] = data_out_w[5-1][1];
                    
    assign op_in_w[5][1] = op_out_w[5][1-1];
    assign inst_op_in_w[5][1] = inst_op_out_w[5][1-1];
    assign dataB_in_w[5][1] = dataB_out_w[5][1-1];
                    
    assign start_in_w[5][1] = start_out_w[5][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(6),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_5_1 (
        .clk(clk),
        .start_in(start_in_w[5][1]),
        .start_out(start_out_w[5][1]),
        .key_data(key_data_w[5][1]),
        .op_in(inst_op_in_w[5][1]),
        .op_out(inst_op_out_w[5][1]),
        .gauss_op_in(op_in_w[5][1]),
        .gauss_op_out(op_out_w[5][1]),
        .data_in(data_in_w[5][1]),
        .data_out(data_out_w[5][1]),
        .dataB_in(dataB_in_w[5][1]),
        .dataB_out(dataB_out_w[5][1]),
        .dataA_in(dataA_in_w[5][1]),
        .dataA_out(dataA_out_w[5][1]),
        .r(r_w[5][1])
    );
                    
    // compute_unit(13, 7), (tile(1, 1), unit(5, 2))
                
    assign dataA_in_w[5][2] = dataA_out_w[5-1][2];
                    
    assign data_in_w[5][2] = data_out_w[5-1][2];
                    
    assign op_in_w[5][2] = op_out_w[5][2-1];
    assign inst_op_in_w[5][2] = inst_op_out_w[5][2-1];
    assign dataB_in_w[5][2] = dataB_out_w[5][2-1];
                    
    assign start_in_w[5][2] = start_out_w[5][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(7),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_5_2 (
        .clk(clk),
        .start_in(start_in_w[5][2]),
        .start_out(start_out_w[5][2]),
        .key_data(key_data_w[5][2]),
        .op_in(inst_op_in_w[5][2]),
        .op_out(inst_op_out_w[5][2]),
        .gauss_op_in(op_in_w[5][2]),
        .gauss_op_out(op_out_w[5][2]),
        .data_in(data_in_w[5][2]),
        .data_out(data_out_w[5][2]),
        .dataB_in(dataB_in_w[5][2]),
        .dataB_out(dataB_out_w[5][2]),
        .dataA_in(dataA_in_w[5][2]),
        .dataA_out(dataA_out_w[5][2]),
        .r(r_w[5][2])
    );
                    
    // compute_unit(13, 8), (tile(1, 1), unit(5, 3))
                
    assign dataA_in_w[5][3] = dataA_out_w[5-1][3];
                    
    assign data_in_w[5][3] = data_out_w[5-1][3];
                    
    assign op_in_w[5][3] = op_out_w[5][3-1];
    assign inst_op_in_w[5][3] = inst_op_out_w[5][3-1];
    assign dataB_in_w[5][3] = dataB_out_w[5][3-1];
                    
    assign start_in_w[5][3] = start_out_w[5][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(8),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_5_3 (
        .clk(clk),
        .start_in(start_in_w[5][3]),
        .start_out(start_out_w[5][3]),
        .key_data(key_data_w[5][3]),
        .op_in(inst_op_in_w[5][3]),
        .op_out(inst_op_out_w[5][3]),
        .gauss_op_in(op_in_w[5][3]),
        .gauss_op_out(op_out_w[5][3]),
        .data_in(data_in_w[5][3]),
        .data_out(data_out_w[5][3]),
        .dataB_in(dataB_in_w[5][3]),
        .dataB_out(dataB_out_w[5][3]),
        .dataA_in(dataA_in_w[5][3]),
        .dataA_out(dataA_out_w[5][3]),
        .r(r_w[5][3])
    );
                    
    // compute_unit(13, 9), (tile(1, 1), unit(5, 4))
                
    assign dataA_in_w[5][4] = dataA_out_w[5-1][4];
                    
    assign data_in_w[5][4] = data_out_w[5-1][4];
                    
    assign op_in_w[5][4] = op_out_w[5][4-1];
    assign inst_op_in_w[5][4] = inst_op_out_w[5][4-1];
    assign dataB_in_w[5][4] = dataB_out_w[5][4-1];
                    
    assign start_in_w[5][4] = start_out_w[5][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(9),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_5_4 (
        .clk(clk),
        .start_in(start_in_w[5][4]),
        .start_out(start_out_w[5][4]),
        .key_data(key_data_w[5][4]),
        .op_in(inst_op_in_w[5][4]),
        .op_out(inst_op_out_w[5][4]),
        .gauss_op_in(op_in_w[5][4]),
        .gauss_op_out(op_out_w[5][4]),
        .data_in(data_in_w[5][4]),
        .data_out(data_out_w[5][4]),
        .dataB_in(dataB_in_w[5][4]),
        .dataB_out(dataB_out_w[5][4]),
        .dataA_in(dataA_in_w[5][4]),
        .dataA_out(dataA_out_w[5][4]),
        .r(r_w[5][4])
    );
                    
    // compute_unit(14, 5), (tile(1, 1), unit(6, 0))
                
    assign dataA_in_w[6][0] = dataA_out_w[6-1][0];
                    
    assign data_in_w[6][0] = data_out_w[6-1][0];
                    
    assign op_in_w[6][0] = gauss_op_in[2*6+1:2*6];
    assign inst_op_in_w[6][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[6][0] = dataB_in[GF_BIT*6+(GF_BIT-1):GF_BIT*6];
                    
    assign start_in_w[6][0] = start_row[6];
    assign finish_in_w[6] = finish_row[6];
                    
    always @(posedge clk) begin
        start_tmp[6] <= start_row[6-1];
        start_row[6] <= start_tmp[6];
        finish_tmp[6] <= finish_row[6-1];
        finish_row[6] <= finish_tmp[6];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(5),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_6_0 (
        .clk(clk),
        .start_in(start_in_w[6][0]),
        .start_out(start_out_w[6][0]),
        .key_data(key_data_w[6][0]),
        .op_in(inst_op_in_w[6][0]),
        .op_out(inst_op_out_w[6][0]),
        .gauss_op_in(op_in_w[6][0]),
        .gauss_op_out(op_out_w[6][0]),
        .data_in(data_in_w[6][0]),
        .data_out(data_out_w[6][0]),
        .dataB_in(dataB_in_w[6][0]),
        .dataB_out(dataB_out_w[6][0]),
        .dataA_in(dataA_in_w[6][0]),
        .dataA_out(dataA_out_w[6][0]),
        .r(r_w[6][0])
    );
                    
    // compute_unit(14, 6), (tile(1, 1), unit(6, 1))
                
    assign dataA_in_w[6][1] = dataA_out_w[6-1][1];
                    
    assign data_in_w[6][1] = data_out_w[6-1][1];
                    
    assign op_in_w[6][1] = op_out_w[6][1-1];
    assign inst_op_in_w[6][1] = inst_op_out_w[6][1-1];
    assign dataB_in_w[6][1] = dataB_out_w[6][1-1];
                    
    assign start_in_w[6][1] = start_out_w[6][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(6),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_6_1 (
        .clk(clk),
        .start_in(start_in_w[6][1]),
        .start_out(start_out_w[6][1]),
        .key_data(key_data_w[6][1]),
        .op_in(inst_op_in_w[6][1]),
        .op_out(inst_op_out_w[6][1]),
        .gauss_op_in(op_in_w[6][1]),
        .gauss_op_out(op_out_w[6][1]),
        .data_in(data_in_w[6][1]),
        .data_out(data_out_w[6][1]),
        .dataB_in(dataB_in_w[6][1]),
        .dataB_out(dataB_out_w[6][1]),
        .dataA_in(dataA_in_w[6][1]),
        .dataA_out(dataA_out_w[6][1]),
        .r(r_w[6][1])
    );
                    
    // compute_unit(14, 7), (tile(1, 1), unit(6, 2))
                
    assign dataA_in_w[6][2] = dataA_out_w[6-1][2];
                    
    assign data_in_w[6][2] = data_out_w[6-1][2];
                    
    assign op_in_w[6][2] = op_out_w[6][2-1];
    assign inst_op_in_w[6][2] = inst_op_out_w[6][2-1];
    assign dataB_in_w[6][2] = dataB_out_w[6][2-1];
                    
    assign start_in_w[6][2] = start_out_w[6][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(7),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_6_2 (
        .clk(clk),
        .start_in(start_in_w[6][2]),
        .start_out(start_out_w[6][2]),
        .key_data(key_data_w[6][2]),
        .op_in(inst_op_in_w[6][2]),
        .op_out(inst_op_out_w[6][2]),
        .gauss_op_in(op_in_w[6][2]),
        .gauss_op_out(op_out_w[6][2]),
        .data_in(data_in_w[6][2]),
        .data_out(data_out_w[6][2]),
        .dataB_in(dataB_in_w[6][2]),
        .dataB_out(dataB_out_w[6][2]),
        .dataA_in(dataA_in_w[6][2]),
        .dataA_out(dataA_out_w[6][2]),
        .r(r_w[6][2])
    );
                    
    // compute_unit(14, 8), (tile(1, 1), unit(6, 3))
                
    assign dataA_in_w[6][3] = dataA_out_w[6-1][3];
                    
    assign data_in_w[6][3] = data_out_w[6-1][3];
                    
    assign op_in_w[6][3] = op_out_w[6][3-1];
    assign inst_op_in_w[6][3] = inst_op_out_w[6][3-1];
    assign dataB_in_w[6][3] = dataB_out_w[6][3-1];
                    
    assign start_in_w[6][3] = start_out_w[6][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(8),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_6_3 (
        .clk(clk),
        .start_in(start_in_w[6][3]),
        .start_out(start_out_w[6][3]),
        .key_data(key_data_w[6][3]),
        .op_in(inst_op_in_w[6][3]),
        .op_out(inst_op_out_w[6][3]),
        .gauss_op_in(op_in_w[6][3]),
        .gauss_op_out(op_out_w[6][3]),
        .data_in(data_in_w[6][3]),
        .data_out(data_out_w[6][3]),
        .dataB_in(dataB_in_w[6][3]),
        .dataB_out(dataB_out_w[6][3]),
        .dataA_in(dataA_in_w[6][3]),
        .dataA_out(dataA_out_w[6][3]),
        .r(r_w[6][3])
    );
                    
    // compute_unit(14, 9), (tile(1, 1), unit(6, 4))
                
    assign dataA_in_w[6][4] = dataA_out_w[6-1][4];
                    
    assign data_in_w[6][4] = data_out_w[6-1][4];
                    
    assign op_in_w[6][4] = op_out_w[6][4-1];
    assign inst_op_in_w[6][4] = inst_op_out_w[6][4-1];
    assign dataB_in_w[6][4] = dataB_out_w[6][4-1];
                    
    assign start_in_w[6][4] = start_out_w[6][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(9),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_6_4 (
        .clk(clk),
        .start_in(start_in_w[6][4]),
        .start_out(start_out_w[6][4]),
        .key_data(key_data_w[6][4]),
        .op_in(inst_op_in_w[6][4]),
        .op_out(inst_op_out_w[6][4]),
        .gauss_op_in(op_in_w[6][4]),
        .gauss_op_out(op_out_w[6][4]),
        .data_in(data_in_w[6][4]),
        .data_out(data_out_w[6][4]),
        .dataB_in(dataB_in_w[6][4]),
        .dataB_out(dataB_out_w[6][4]),
        .dataA_in(dataA_in_w[6][4]),
        .dataA_out(dataA_out_w[6][4]),
        .r(r_w[6][4])
    );
                    
    // compute_unit(15, 5), (tile(1, 1), unit(7, 0))
                
    assign dataA_in_w[7][0] = dataA_out_w[7-1][0];
                    
    assign data_in_w[7][0] = data_out_w[7-1][0];
                    
    assign op_in_w[7][0] = gauss_op_in[2*7+1:2*7];
    assign inst_op_in_w[7][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[7][0] = dataB_in[GF_BIT*7+(GF_BIT-1):GF_BIT*7];
                    
    assign start_in_w[7][0] = start_row[7];
    assign finish_in_w[7] = finish_row[7];
                    
    always @(posedge clk) begin
        start_tmp[7] <= start_row[7-1];
        start_row[7] <= start_tmp[7];
        finish_tmp[7] <= finish_row[7-1];
        finish_row[7] <= finish_tmp[7];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(5),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_7_0 (
        .clk(clk),
        .start_in(start_in_w[7][0]),
        .start_out(start_out_w[7][0]),
        .key_data(key_data_w[7][0]),
        .op_in(inst_op_in_w[7][0]),
        .op_out(inst_op_out_w[7][0]),
        .gauss_op_in(op_in_w[7][0]),
        .gauss_op_out(op_out_w[7][0]),
        .data_in(data_in_w[7][0]),
        .data_out(data_out_w[7][0]),
        .dataB_in(dataB_in_w[7][0]),
        .dataB_out(dataB_out_w[7][0]),
        .dataA_in(dataA_in_w[7][0]),
        .dataA_out(dataA_out_w[7][0]),
        .r(r_w[7][0])
    );
                    
    // compute_unit(15, 6), (tile(1, 1), unit(7, 1))
                
    assign dataA_in_w[7][1] = dataA_out_w[7-1][1];
                    
    assign data_in_w[7][1] = data_out_w[7-1][1];
                    
    assign op_in_w[7][1] = op_out_w[7][1-1];
    assign inst_op_in_w[7][1] = inst_op_out_w[7][1-1];
    assign dataB_in_w[7][1] = dataB_out_w[7][1-1];
                    
    assign start_in_w[7][1] = start_out_w[7][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(6),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_7_1 (
        .clk(clk),
        .start_in(start_in_w[7][1]),
        .start_out(start_out_w[7][1]),
        .key_data(key_data_w[7][1]),
        .op_in(inst_op_in_w[7][1]),
        .op_out(inst_op_out_w[7][1]),
        .gauss_op_in(op_in_w[7][1]),
        .gauss_op_out(op_out_w[7][1]),
        .data_in(data_in_w[7][1]),
        .data_out(data_out_w[7][1]),
        .dataB_in(dataB_in_w[7][1]),
        .dataB_out(dataB_out_w[7][1]),
        .dataA_in(dataA_in_w[7][1]),
        .dataA_out(dataA_out_w[7][1]),
        .r(r_w[7][1])
    );
                    
    // compute_unit(15, 7), (tile(1, 1), unit(7, 2))
                
    assign dataA_in_w[7][2] = dataA_out_w[7-1][2];
                    
    assign data_in_w[7][2] = data_out_w[7-1][2];
                    
    assign op_in_w[7][2] = op_out_w[7][2-1];
    assign inst_op_in_w[7][2] = inst_op_out_w[7][2-1];
    assign dataB_in_w[7][2] = dataB_out_w[7][2-1];
                    
    assign start_in_w[7][2] = start_out_w[7][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(7),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_7_2 (
        .clk(clk),
        .start_in(start_in_w[7][2]),
        .start_out(start_out_w[7][2]),
        .key_data(key_data_w[7][2]),
        .op_in(inst_op_in_w[7][2]),
        .op_out(inst_op_out_w[7][2]),
        .gauss_op_in(op_in_w[7][2]),
        .gauss_op_out(op_out_w[7][2]),
        .data_in(data_in_w[7][2]),
        .data_out(data_out_w[7][2]),
        .dataB_in(dataB_in_w[7][2]),
        .dataB_out(dataB_out_w[7][2]),
        .dataA_in(dataA_in_w[7][2]),
        .dataA_out(dataA_out_w[7][2]),
        .r(r_w[7][2])
    );
                    
    // compute_unit(15, 8), (tile(1, 1), unit(7, 3))
                
    assign dataA_in_w[7][3] = dataA_out_w[7-1][3];
                    
    assign data_in_w[7][3] = data_out_w[7-1][3];
                    
    assign op_in_w[7][3] = op_out_w[7][3-1];
    assign inst_op_in_w[7][3] = inst_op_out_w[7][3-1];
    assign dataB_in_w[7][3] = dataB_out_w[7][3-1];
                    
    assign start_in_w[7][3] = start_out_w[7][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(8),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_7_3 (
        .clk(clk),
        .start_in(start_in_w[7][3]),
        .start_out(start_out_w[7][3]),
        .key_data(key_data_w[7][3]),
        .op_in(inst_op_in_w[7][3]),
        .op_out(inst_op_out_w[7][3]),
        .gauss_op_in(op_in_w[7][3]),
        .gauss_op_out(op_out_w[7][3]),
        .data_in(data_in_w[7][3]),
        .data_out(data_out_w[7][3]),
        .dataB_in(dataB_in_w[7][3]),
        .dataB_out(dataB_out_w[7][3]),
        .dataA_in(dataA_in_w[7][3]),
        .dataA_out(dataA_out_w[7][3]),
        .r(r_w[7][3])
    );
                    
    // compute_unit(15, 9), (tile(1, 1), unit(7, 4))
                
    assign dataA_in_w[7][4] = dataA_out_w[7-1][4];
                    
    assign data_in_w[7][4] = data_out_w[7-1][4];
                    
    assign op_in_w[7][4] = op_out_w[7][4-1];
    assign inst_op_in_w[7][4] = inst_op_out_w[7][4-1];
    assign dataB_in_w[7][4] = dataB_out_w[7][4-1];
                    
    assign start_in_w[7][4] = start_out_w[7][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(9),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(1),
        .NUM_PROC_COL(3)
    ) B_proc_7_4 (
        .clk(clk),
        .start_in(start_in_w[7][4]),
        .start_out(start_out_w[7][4]),
        .key_data(key_data_w[7][4]),
        .op_in(inst_op_in_w[7][4]),
        .op_out(inst_op_out_w[7][4]),
        .gauss_op_in(op_in_w[7][4]),
        .gauss_op_out(op_out_w[7][4]),
        .data_in(data_in_w[7][4]),
        .data_out(data_out_w[7][4]),
        .dataB_in(dataB_in_w[7][4]),
        .dataB_out(dataB_out_w[7][4]),
        .dataA_in(dataA_in_w[7][4]),
        .dataA_out(dataA_out_w[7][4]),
        .r(r_w[7][4])
    );
                    
    generate
        for (i = 0; i < COL; i=i+1) begin
            for (j = 0; j < GF_BIT; j=j+1) begin
                assign data_out[i*GF_BIT+j] = data_out_w[ROW-1][i][j];
            end
        end
    endgenerate
        
    generate
        for (i = 0; i < ROW; i=i+1) begin
            assign gauss_op_out[2*i+1:2*i] = op_out_w[i][COL-1];
            assign dataB_out[GF_BIT*i+(GF_BIT-1):GF_BIT*i] = dataB_out_w[i][COL-1];
        end
    endgenerate
        
    wire [2-1:0] is_one;
            
                        assign is_one[0] = (r_w[0][3] == 1); // current_row = 8, current_col = 8
                        
                        assign is_one[1] = (r_w[1][4] == 1); // current_row = 9, current_col = 9
                        
    assign r_A_and = &is_one;
            
    reg start_out_tmp;
    reg finish_out_tmp;
    always @(posedge clk) begin
        start_out_tmp  <= start_row[ROW-1];
        finish_out_tmp <= finish_row[ROW-1];
        start_out      <= start_out_tmp;
        finish_out     <= finish_out_tmp;
    end

endmodule
        
// row = 8, col = 6
module tile_1_2#(
    parameter N = 16,
    parameter GF_BIT = 8,
    parameter OP_SIZE = 22,
    parameter ROW = 8,
    parameter COL = 6
)(
    input wire                      clk,
    input wire                      rst_n,
    input wire        [OP_SIZE-1:0] op_in,        // decide which operations
    input wire     [GF_BIT*COL-1:0] dataA_in,     // for mat_mul, load
    input wire          [2*ROW-1:0] gauss_op_in,  // for gauss
    input wire     [GF_BIT*ROW-1:0] dataB_in,     // for gauss
    input wire     [GF_BIT*COL-1:0] data_in,      // for gauss, store (not used in first row)
    input wire                      start_in, 
    input wire                      finish_in,
    output wire         [2*ROW-1:0] gauss_op_out, // for gauss
    output wire    [GF_BIT*ROW-1:0] dataB_out,    // for gauss
    output wire    [GF_BIT*COL-1:0] data_out,     // for gauss, store
    output reg                      start_out,
    output reg                      finish_out,
    output wire                     r_A_and
);
    
    localparam TILE_ROW_IDX = 1;
    localparam TILE_COL_IDX = 2;
    localparam NUM_PROC_COL = 3;
    localparam BANK = 5; 

    genvar i, j, k;
    integer n, m;

    wire                  start_in_w[0:ROW-1][0:COL-1];
    wire                 start_out_w[0:ROW-1][0:COL-1];
    wire                 finish_in_w[0:ROW-1];
    wire                finish_out_w[0:ROW-1];
    wire         [3:0]  inst_op_in_w[0:ROW-1][0:COL-1];
    wire         [3:0] inst_op_out_w[0:ROW-1][0:COL-1];
    wire         [1:0]       op_in_w[0:ROW-1][0:COL-1];
    wire         [1:0]      op_out_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    dataB_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]   dataB_out_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]           r_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]     data_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    dataA_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]   dataA_out_w[0:ROW-1][0:COL-1];
    reg   [GF_BIT-1:0]     data_in_r[1:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    data_out_w[0:ROW-1][0:COL-1];

    reg [ROW-1 : 1] start_tmp;
    reg [ROW-1 : 1] start_row;
    
    reg [ROW-1 : 1] finish_tmp;
    reg [ROW-1 : 1] finish_row;
    
    reg functionA_dup;
    always @(posedge clk) begin
        functionA_dup <= op_in[17];
    end

    wire [GF_BIT*8*BANK-1:0] key_data;
    wire          [GF_BIT-1:0] key_data_w[0:ROW-1][0:COL-1];
    wire                       key_wren;
    wire      [GF_BIT*ROW-1:0] key_write_data;
    generate
        if (GF_BIT*8 != 0) begin: key_mem
            assign key_wren = op_in[14];
            bram16Kx4 #(
                .WIDTH(GF_BIT*8),
                .DELAY(1)
            ) mem_inst (
                .clock (clk),
                .data (key_write_data),
                .address (op_in[14-1:0]),
                .wren (key_wren),
                .q (key_data)
            );
            for (j = 0; j < ROW; j=j+1) begin
                for (k = 0; k < BANK; k=k+1) begin
                    assign key_data_w[j][k] = (j < 8) ? key_data[(j+k*8)*GF_BIT+:GF_BIT] : 0; // load from
                end
                assign key_write_data[j*GF_BIT+:GF_BIT] = r_w[j][0];                        // write to
            end
        end else begin
            for (j = 0; j < ROW; j=j+1) begin
                for (k = 0; k < BANK; k=k+1) begin
                    assign key_data_w[j][k] = 0; // load from
                end
            end
        end
    endgenerate

    // always@(posedge clk) begin
    //     if ((op_in[OP_SIZE-1:OP_SIZE-4] == 7)) begin
    //         $display("_____________________________________________");
    //         $display("| 1_2, 8, 6");
    //         $display("| dataA_in: %x,  dataB_in: %x, addr: %d, key_data: %x, key_write_data: %x, key_wren: %d", dataA_in, dataB_in, op_in[14-1:0], key_data, key_write_data, key_wren);
    //         $display("|____________________________________________");
    //     end
    // end
        
    // compute_unit(8, 10), (tile(1, 2), unit(0, 0))
                
    assign dataA_in_w[0][0] = dataA_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign data_in_w[0][0] = data_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign op_in_w[0][0] = gauss_op_in[2*0+1:2*0];
    assign inst_op_in_w[0][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[0][0] = dataB_in[GF_BIT*0+(GF_BIT-1):GF_BIT*0];
                    
    assign start_in_w[0][0] = start_in;
    assign finish_in_w[0] = finish_in;
                    
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(10),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_0_0 (
        .clk(clk),
        .start_in(start_in_w[0][0]),
        .start_out(start_out_w[0][0]),
        .key_data(key_data_w[0][0]),
        .op_in(inst_op_in_w[0][0]),
        .op_out(inst_op_out_w[0][0]),
        .gauss_op_in(op_in_w[0][0]),
        .gauss_op_out(op_out_w[0][0]),
        .data_in(data_in_w[0][0]),
        .data_out(data_out_w[0][0]),
        .dataB_in(dataB_in_w[0][0]),
        .dataB_out(dataB_out_w[0][0]),
        .dataA_in(dataA_in_w[0][0]),
        .dataA_out(dataA_out_w[0][0]),
        .r(r_w[0][0])
    );
                    
    // compute_unit(8, 11), (tile(1, 2), unit(0, 1))
                
    assign dataA_in_w[0][1] = dataA_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign data_in_w[0][1] = data_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign op_in_w[0][1] = op_out_w[0][1-1];
    assign inst_op_in_w[0][1] = inst_op_out_w[0][1-1];
    assign dataB_in_w[0][1] = dataB_out_w[0][1-1];
                    
    assign start_in_w[0][1] = start_out_w[0][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(11),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_0_1 (
        .clk(clk),
        .start_in(start_in_w[0][1]),
        .start_out(start_out_w[0][1]),
        .key_data(key_data_w[0][1]),
        .op_in(inst_op_in_w[0][1]),
        .op_out(inst_op_out_w[0][1]),
        .gauss_op_in(op_in_w[0][1]),
        .gauss_op_out(op_out_w[0][1]),
        .data_in(data_in_w[0][1]),
        .data_out(data_out_w[0][1]),
        .dataB_in(dataB_in_w[0][1]),
        .dataB_out(dataB_out_w[0][1]),
        .dataA_in(dataA_in_w[0][1]),
        .dataA_out(dataA_out_w[0][1]),
        .r(r_w[0][1])
    );
                    
    // compute_unit(8, 12), (tile(1, 2), unit(0, 2))
                
    assign dataA_in_w[0][2] = dataA_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign data_in_w[0][2] = data_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign op_in_w[0][2] = op_out_w[0][2-1];
    assign inst_op_in_w[0][2] = inst_op_out_w[0][2-1];
    assign dataB_in_w[0][2] = dataB_out_w[0][2-1];
                    
    assign start_in_w[0][2] = start_out_w[0][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(12),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_0_2 (
        .clk(clk),
        .start_in(start_in_w[0][2]),
        .start_out(start_out_w[0][2]),
        .key_data(key_data_w[0][2]),
        .op_in(inst_op_in_w[0][2]),
        .op_out(inst_op_out_w[0][2]),
        .gauss_op_in(op_in_w[0][2]),
        .gauss_op_out(op_out_w[0][2]),
        .data_in(data_in_w[0][2]),
        .data_out(data_out_w[0][2]),
        .dataB_in(dataB_in_w[0][2]),
        .dataB_out(dataB_out_w[0][2]),
        .dataA_in(dataA_in_w[0][2]),
        .dataA_out(dataA_out_w[0][2]),
        .r(r_w[0][2])
    );
                    
    // compute_unit(8, 13), (tile(1, 2), unit(0, 3))
                
    assign dataA_in_w[0][3] = dataA_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign data_in_w[0][3] = data_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign op_in_w[0][3] = op_out_w[0][3-1];
    assign inst_op_in_w[0][3] = inst_op_out_w[0][3-1];
    assign dataB_in_w[0][3] = dataB_out_w[0][3-1];
                    
    assign start_in_w[0][3] = start_out_w[0][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(13),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_0_3 (
        .clk(clk),
        .start_in(start_in_w[0][3]),
        .start_out(start_out_w[0][3]),
        .key_data(key_data_w[0][3]),
        .op_in(inst_op_in_w[0][3]),
        .op_out(inst_op_out_w[0][3]),
        .gauss_op_in(op_in_w[0][3]),
        .gauss_op_out(op_out_w[0][3]),
        .data_in(data_in_w[0][3]),
        .data_out(data_out_w[0][3]),
        .dataB_in(dataB_in_w[0][3]),
        .dataB_out(dataB_out_w[0][3]),
        .dataA_in(dataA_in_w[0][3]),
        .dataA_out(dataA_out_w[0][3]),
        .r(r_w[0][3])
    );
                    
    // compute_unit(8, 14), (tile(1, 2), unit(0, 4))
                
    assign dataA_in_w[0][4] = dataA_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign data_in_w[0][4] = data_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign op_in_w[0][4] = op_out_w[0][4-1];
    assign inst_op_in_w[0][4] = inst_op_out_w[0][4-1];
    assign dataB_in_w[0][4] = dataB_out_w[0][4-1];
                    
    assign start_in_w[0][4] = start_out_w[0][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(14),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_0_4 (
        .clk(clk),
        .start_in(start_in_w[0][4]),
        .start_out(start_out_w[0][4]),
        .key_data(key_data_w[0][4]),
        .op_in(inst_op_in_w[0][4]),
        .op_out(inst_op_out_w[0][4]),
        .gauss_op_in(op_in_w[0][4]),
        .gauss_op_out(op_out_w[0][4]),
        .data_in(data_in_w[0][4]),
        .data_out(data_out_w[0][4]),
        .dataB_in(dataB_in_w[0][4]),
        .dataB_out(dataB_out_w[0][4]),
        .dataA_in(dataA_in_w[0][4]),
        .dataA_out(dataA_out_w[0][4]),
        .r(r_w[0][4])
    );
                    
    // compute_unit(8, 15), (tile(1, 2), unit(0, 5))
                
    assign dataA_in_w[0][5] = dataA_in[GF_BIT*5+(GF_BIT-1):GF_BIT*5];
                    
    assign data_in_w[0][5] = data_in[GF_BIT*5+(GF_BIT-1):GF_BIT*5];
                    
    assign op_in_w[0][5] = op_out_w[0][5-1];
    assign inst_op_in_w[0][5] = inst_op_out_w[0][5-1];
    assign dataB_in_w[0][5] = dataB_out_w[0][5-1];
                    
    assign start_in_w[0][5] = start_out_w[0][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(8),
        .COL_IDX(15),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_0_5 (
        .clk(clk),
        .start_in(start_in_w[0][5]),
        .start_out(start_out_w[0][5]),
        .key_data(key_data_w[0][5]),
        .op_in(inst_op_in_w[0][5]),
        .op_out(inst_op_out_w[0][5]),
        .gauss_op_in(op_in_w[0][5]),
        .gauss_op_out(op_out_w[0][5]),
        .data_in(data_in_w[0][5]),
        .data_out(data_out_w[0][5]),
        .dataB_in(dataB_in_w[0][5]),
        .dataB_out(dataB_out_w[0][5]),
        .dataA_in(dataA_in_w[0][5]),
        .dataA_out(dataA_out_w[0][5]),
        .r(r_w[0][5])
    );
                    
    // compute_unit(9, 10), (tile(1, 2), unit(1, 0))
                
    assign dataA_in_w[1][0] = dataA_out_w[1-1][0];
                    
    assign data_in_w[1][0] = data_out_w[1-1][0];
                    
    assign op_in_w[1][0] = gauss_op_in[2*1+1:2*1];
    assign inst_op_in_w[1][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[1][0] = dataB_in[GF_BIT*1+(GF_BIT-1):GF_BIT*1];
                    
    assign start_in_w[1][0] = start_row[1];
    assign finish_in_w[1] = finish_row[1];
                    
    always @(posedge clk) begin
        start_tmp[1] <= start_in;
        start_row[1] <= start_tmp[1];
        finish_tmp[1] <= finish_in;
        finish_row[1] <= finish_tmp[1];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(10),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_1_0 (
        .clk(clk),
        .start_in(start_in_w[1][0]),
        .start_out(start_out_w[1][0]),
        .key_data(key_data_w[1][0]),
        .op_in(inst_op_in_w[1][0]),
        .op_out(inst_op_out_w[1][0]),
        .gauss_op_in(op_in_w[1][0]),
        .gauss_op_out(op_out_w[1][0]),
        .data_in(data_in_w[1][0]),
        .data_out(data_out_w[1][0]),
        .dataB_in(dataB_in_w[1][0]),
        .dataB_out(dataB_out_w[1][0]),
        .dataA_in(dataA_in_w[1][0]),
        .dataA_out(dataA_out_w[1][0]),
        .r(r_w[1][0])
    );
                    
    // compute_unit(9, 11), (tile(1, 2), unit(1, 1))
                
    assign dataA_in_w[1][1] = dataA_out_w[1-1][1];
                    
    assign data_in_w[1][1] = data_out_w[1-1][1];
                    
    assign op_in_w[1][1] = op_out_w[1][1-1];
    assign inst_op_in_w[1][1] = inst_op_out_w[1][1-1];
    assign dataB_in_w[1][1] = dataB_out_w[1][1-1];
                    
    assign start_in_w[1][1] = start_out_w[1][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(11),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_1_1 (
        .clk(clk),
        .start_in(start_in_w[1][1]),
        .start_out(start_out_w[1][1]),
        .key_data(key_data_w[1][1]),
        .op_in(inst_op_in_w[1][1]),
        .op_out(inst_op_out_w[1][1]),
        .gauss_op_in(op_in_w[1][1]),
        .gauss_op_out(op_out_w[1][1]),
        .data_in(data_in_w[1][1]),
        .data_out(data_out_w[1][1]),
        .dataB_in(dataB_in_w[1][1]),
        .dataB_out(dataB_out_w[1][1]),
        .dataA_in(dataA_in_w[1][1]),
        .dataA_out(dataA_out_w[1][1]),
        .r(r_w[1][1])
    );
                    
    // compute_unit(9, 12), (tile(1, 2), unit(1, 2))
                
    assign dataA_in_w[1][2] = dataA_out_w[1-1][2];
                    
    assign data_in_w[1][2] = data_out_w[1-1][2];
                    
    assign op_in_w[1][2] = op_out_w[1][2-1];
    assign inst_op_in_w[1][2] = inst_op_out_w[1][2-1];
    assign dataB_in_w[1][2] = dataB_out_w[1][2-1];
                    
    assign start_in_w[1][2] = start_out_w[1][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(12),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_1_2 (
        .clk(clk),
        .start_in(start_in_w[1][2]),
        .start_out(start_out_w[1][2]),
        .key_data(key_data_w[1][2]),
        .op_in(inst_op_in_w[1][2]),
        .op_out(inst_op_out_w[1][2]),
        .gauss_op_in(op_in_w[1][2]),
        .gauss_op_out(op_out_w[1][2]),
        .data_in(data_in_w[1][2]),
        .data_out(data_out_w[1][2]),
        .dataB_in(dataB_in_w[1][2]),
        .dataB_out(dataB_out_w[1][2]),
        .dataA_in(dataA_in_w[1][2]),
        .dataA_out(dataA_out_w[1][2]),
        .r(r_w[1][2])
    );
                    
    // compute_unit(9, 13), (tile(1, 2), unit(1, 3))
                
    assign dataA_in_w[1][3] = dataA_out_w[1-1][3];
                    
    assign data_in_w[1][3] = data_out_w[1-1][3];
                    
    assign op_in_w[1][3] = op_out_w[1][3-1];
    assign inst_op_in_w[1][3] = inst_op_out_w[1][3-1];
    assign dataB_in_w[1][3] = dataB_out_w[1][3-1];
                    
    assign start_in_w[1][3] = start_out_w[1][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(13),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_1_3 (
        .clk(clk),
        .start_in(start_in_w[1][3]),
        .start_out(start_out_w[1][3]),
        .key_data(key_data_w[1][3]),
        .op_in(inst_op_in_w[1][3]),
        .op_out(inst_op_out_w[1][3]),
        .gauss_op_in(op_in_w[1][3]),
        .gauss_op_out(op_out_w[1][3]),
        .data_in(data_in_w[1][3]),
        .data_out(data_out_w[1][3]),
        .dataB_in(dataB_in_w[1][3]),
        .dataB_out(dataB_out_w[1][3]),
        .dataA_in(dataA_in_w[1][3]),
        .dataA_out(dataA_out_w[1][3]),
        .r(r_w[1][3])
    );
                    
    // compute_unit(9, 14), (tile(1, 2), unit(1, 4))
                
    assign dataA_in_w[1][4] = dataA_out_w[1-1][4];
                    
    assign data_in_w[1][4] = data_out_w[1-1][4];
                    
    assign op_in_w[1][4] = op_out_w[1][4-1];
    assign inst_op_in_w[1][4] = inst_op_out_w[1][4-1];
    assign dataB_in_w[1][4] = dataB_out_w[1][4-1];
                    
    assign start_in_w[1][4] = start_out_w[1][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(14),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_1_4 (
        .clk(clk),
        .start_in(start_in_w[1][4]),
        .start_out(start_out_w[1][4]),
        .key_data(key_data_w[1][4]),
        .op_in(inst_op_in_w[1][4]),
        .op_out(inst_op_out_w[1][4]),
        .gauss_op_in(op_in_w[1][4]),
        .gauss_op_out(op_out_w[1][4]),
        .data_in(data_in_w[1][4]),
        .data_out(data_out_w[1][4]),
        .dataB_in(dataB_in_w[1][4]),
        .dataB_out(dataB_out_w[1][4]),
        .dataA_in(dataA_in_w[1][4]),
        .dataA_out(dataA_out_w[1][4]),
        .r(r_w[1][4])
    );
                    
    // compute_unit(9, 15), (tile(1, 2), unit(1, 5))
                
    assign dataA_in_w[1][5] = dataA_out_w[1-1][5];
                    
    assign data_in_w[1][5] = data_out_w[1-1][5];
                    
    assign op_in_w[1][5] = op_out_w[1][5-1];
    assign inst_op_in_w[1][5] = inst_op_out_w[1][5-1];
    assign dataB_in_w[1][5] = dataB_out_w[1][5-1];
                    
    assign start_in_w[1][5] = start_out_w[1][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(9),
        .COL_IDX(15),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_1_5 (
        .clk(clk),
        .start_in(start_in_w[1][5]),
        .start_out(start_out_w[1][5]),
        .key_data(key_data_w[1][5]),
        .op_in(inst_op_in_w[1][5]),
        .op_out(inst_op_out_w[1][5]),
        .gauss_op_in(op_in_w[1][5]),
        .gauss_op_out(op_out_w[1][5]),
        .data_in(data_in_w[1][5]),
        .data_out(data_out_w[1][5]),
        .dataB_in(dataB_in_w[1][5]),
        .dataB_out(dataB_out_w[1][5]),
        .dataA_in(dataA_in_w[1][5]),
        .dataA_out(dataA_out_w[1][5]),
        .r(r_w[1][5])
    );
                    
    // compute_unit(10, 10), (tile(1, 2), unit(2, 0))
                
    assign dataA_in_w[2][0] = dataA_out_w[2-1][0];
                    
    assign data_in_w[2][0] = data_out_w[2-1][0];
                    
    assign op_in_w[2][0] = gauss_op_in[2*2+1:2*2];
    assign inst_op_in_w[2][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[2][0] = dataB_in[GF_BIT*2+(GF_BIT-1):GF_BIT*2];
                    
    assign start_in_w[2][0] = start_row[2];
    assign finish_in_w[2] = finish_row[2];
                    
    always @(posedge clk) begin
        start_tmp[2] <= start_row[2-1];
        start_row[2] <= start_tmp[2];
        finish_tmp[2] <= finish_row[2-1];
        finish_row[2] <= finish_tmp[2];
    end
                        
    processor_ABC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(10),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) AB_proc_2_0 (
        .clk(clk),
        .start_in(start_in_w[2][0]),
        .start_out(start_out_w[2][0]),
        .finish_in(finish_in_w[2]),
        .finish_out(finish_out_w[2]),
        .key_data(key_data_w[2][0]),
        .op_in(inst_op_in_w[2][0]),
        .op_out(inst_op_out_w[2][0]),
        .gauss_op_in(op_in_w[2][0]),
        .gauss_op_out(op_out_w[2][0]),
        .data_in(data_in_w[2][0]),
        .data_out(data_out_w[2][0]),
        .dataB_in(dataB_in_w[2][0]),
        .dataB_out(dataB_out_w[2][0]),
        .dataA_in(dataA_in_w[2][0]),
        .dataA_out(dataA_out_w[2][0]),
        .r(r_w[2][0]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(10, 11), (tile(1, 2), unit(2, 1))
                
    assign dataA_in_w[2][1] = dataA_out_w[2-1][1];
                    
    assign data_in_w[2][1] = data_out_w[2-1][1];
                    
    assign op_in_w[2][1] = op_out_w[2][1-1];
    assign inst_op_in_w[2][1] = inst_op_out_w[2][1-1];
    assign dataB_in_w[2][1] = dataB_out_w[2][1-1];
                    
    assign start_in_w[2][1] = start_out_w[2][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(11),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_2_1 (
        .clk(clk),
        .start_in(start_in_w[2][1]),
        .start_out(start_out_w[2][1]),
        .key_data(key_data_w[2][1]),
        .op_in(inst_op_in_w[2][1]),
        .op_out(inst_op_out_w[2][1]),
        .gauss_op_in(op_in_w[2][1]),
        .gauss_op_out(op_out_w[2][1]),
        .data_in(data_in_w[2][1]),
        .data_out(data_out_w[2][1]),
        .dataB_in(dataB_in_w[2][1]),
        .dataB_out(dataB_out_w[2][1]),
        .dataA_in(dataA_in_w[2][1]),
        .dataA_out(dataA_out_w[2][1]),
        .r(r_w[2][1])
    );
                    
    // compute_unit(10, 12), (tile(1, 2), unit(2, 2))
                
    assign dataA_in_w[2][2] = dataA_out_w[2-1][2];
                    
    assign data_in_w[2][2] = data_out_w[2-1][2];
                    
    assign op_in_w[2][2] = op_out_w[2][2-1];
    assign inst_op_in_w[2][2] = inst_op_out_w[2][2-1];
    assign dataB_in_w[2][2] = dataB_out_w[2][2-1];
                    
    assign start_in_w[2][2] = start_out_w[2][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(12),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_2_2 (
        .clk(clk),
        .start_in(start_in_w[2][2]),
        .start_out(start_out_w[2][2]),
        .key_data(key_data_w[2][2]),
        .op_in(inst_op_in_w[2][2]),
        .op_out(inst_op_out_w[2][2]),
        .gauss_op_in(op_in_w[2][2]),
        .gauss_op_out(op_out_w[2][2]),
        .data_in(data_in_w[2][2]),
        .data_out(data_out_w[2][2]),
        .dataB_in(dataB_in_w[2][2]),
        .dataB_out(dataB_out_w[2][2]),
        .dataA_in(dataA_in_w[2][2]),
        .dataA_out(dataA_out_w[2][2]),
        .r(r_w[2][2])
    );
                    
    // compute_unit(10, 13), (tile(1, 2), unit(2, 3))
                
    assign dataA_in_w[2][3] = dataA_out_w[2-1][3];
                    
    assign data_in_w[2][3] = data_out_w[2-1][3];
                    
    assign op_in_w[2][3] = op_out_w[2][3-1];
    assign inst_op_in_w[2][3] = inst_op_out_w[2][3-1];
    assign dataB_in_w[2][3] = dataB_out_w[2][3-1];
                    
    assign start_in_w[2][3] = start_out_w[2][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(13),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_2_3 (
        .clk(clk),
        .start_in(start_in_w[2][3]),
        .start_out(start_out_w[2][3]),
        .key_data(key_data_w[2][3]),
        .op_in(inst_op_in_w[2][3]),
        .op_out(inst_op_out_w[2][3]),
        .gauss_op_in(op_in_w[2][3]),
        .gauss_op_out(op_out_w[2][3]),
        .data_in(data_in_w[2][3]),
        .data_out(data_out_w[2][3]),
        .dataB_in(dataB_in_w[2][3]),
        .dataB_out(dataB_out_w[2][3]),
        .dataA_in(dataA_in_w[2][3]),
        .dataA_out(dataA_out_w[2][3]),
        .r(r_w[2][3])
    );
                    
    // compute_unit(10, 14), (tile(1, 2), unit(2, 4))
                
    assign dataA_in_w[2][4] = dataA_out_w[2-1][4];
                    
    assign data_in_w[2][4] = data_out_w[2-1][4];
                    
    assign op_in_w[2][4] = op_out_w[2][4-1];
    assign inst_op_in_w[2][4] = inst_op_out_w[2][4-1];
    assign dataB_in_w[2][4] = dataB_out_w[2][4-1];
                    
    assign start_in_w[2][4] = start_out_w[2][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(14),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_2_4 (
        .clk(clk),
        .start_in(start_in_w[2][4]),
        .start_out(start_out_w[2][4]),
        .key_data(key_data_w[2][4]),
        .op_in(inst_op_in_w[2][4]),
        .op_out(inst_op_out_w[2][4]),
        .gauss_op_in(op_in_w[2][4]),
        .gauss_op_out(op_out_w[2][4]),
        .data_in(data_in_w[2][4]),
        .data_out(data_out_w[2][4]),
        .dataB_in(dataB_in_w[2][4]),
        .dataB_out(dataB_out_w[2][4]),
        .dataA_in(dataA_in_w[2][4]),
        .dataA_out(dataA_out_w[2][4]),
        .r(r_w[2][4])
    );
                    
    // compute_unit(10, 15), (tile(1, 2), unit(2, 5))
                
    assign dataA_in_w[2][5] = dataA_out_w[2-1][5];
                    
    assign data_in_w[2][5] = data_out_w[2-1][5];
                    
    assign op_in_w[2][5] = op_out_w[2][5-1];
    assign inst_op_in_w[2][5] = inst_op_out_w[2][5-1];
    assign dataB_in_w[2][5] = dataB_out_w[2][5-1];
                    
    assign start_in_w[2][5] = start_out_w[2][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(10),
        .COL_IDX(15),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_2_5 (
        .clk(clk),
        .start_in(start_in_w[2][5]),
        .start_out(start_out_w[2][5]),
        .key_data(key_data_w[2][5]),
        .op_in(inst_op_in_w[2][5]),
        .op_out(inst_op_out_w[2][5]),
        .gauss_op_in(op_in_w[2][5]),
        .gauss_op_out(op_out_w[2][5]),
        .data_in(data_in_w[2][5]),
        .data_out(data_out_w[2][5]),
        .dataB_in(dataB_in_w[2][5]),
        .dataB_out(dataB_out_w[2][5]),
        .dataA_in(dataA_in_w[2][5]),
        .dataA_out(dataA_out_w[2][5]),
        .r(r_w[2][5])
    );
                    
    // compute_unit(11, 10), (tile(1, 2), unit(3, 0))
                
    assign dataA_in_w[3][0] = dataA_out_w[3-1][0];
                    
    assign data_in_w[3][0] = data_out_w[3-1][0];
                    
    assign op_in_w[3][0] = gauss_op_in[2*3+1:2*3];
    assign inst_op_in_w[3][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[3][0] = dataB_in[GF_BIT*3+(GF_BIT-1):GF_BIT*3];
                    
    assign start_in_w[3][0] = start_row[3];
    assign finish_in_w[3] = finish_row[3];
                    
    always @(posedge clk) begin
        start_tmp[3] <= start_row[3-1];
        start_row[3] <= start_tmp[3];
        finish_tmp[3] <= finish_row[3-1];
        finish_row[3] <= finish_tmp[3];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(10),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_3_0 (
        .clk(clk),
        .start_in(start_in_w[3][0]),
        .start_out(start_out_w[3][0]),
        .key_data(key_data_w[3][0]),
        .op_in(inst_op_in_w[3][0]),
        .op_out(inst_op_out_w[3][0]),
        .gauss_op_in(op_in_w[3][0]),
        .gauss_op_out(op_out_w[3][0]),
        .data_in(data_in_w[3][0]),
        .data_out(data_out_w[3][0]),
        .dataB_in(dataB_in_w[3][0]),
        .dataB_out(dataB_out_w[3][0]),
        .dataA_in(dataA_in_w[3][0]),
        .dataA_out(dataA_out_w[3][0]),
        .r(r_w[3][0])
    );
                    
    // compute_unit(11, 11), (tile(1, 2), unit(3, 1))
                
    assign dataA_in_w[3][1] = dataA_out_w[3-1][1];
                    
    assign data_in_w[3][1] = data_out_w[3-1][1];
                    
    assign op_in_w[3][1] = op_out_w[3][1-1];
    assign inst_op_in_w[3][1] = inst_op_out_w[3][1-1];
    assign dataB_in_w[3][1] = dataB_out_w[3][1-1];
                    
    assign start_in_w[3][1] = start_out_w[3][1-1];
                    
    processor_AB #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(11),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) AB_proc_3_1 (
        .clk(clk),
        .start_in(start_in_w[3][1]),
        .start_out(start_out_w[3][1]),
        .finish_in(finish_in_w[3]),
        .finish_out(finish_out_w[3]),
        .key_data(key_data_w[3][1]),
        .op_in(inst_op_in_w[3][1]),
        .op_out(inst_op_out_w[3][1]),
        .gauss_op_in(op_in_w[3][1]),
        .gauss_op_out(op_out_w[3][1]),
        .data_in(data_in_w[3][1]),
        .data_out(data_out_w[3][1]),
        .dataB_in(dataB_in_w[3][1]),
        .dataB_out(dataB_out_w[3][1]),
        .dataA_in(dataA_in_w[3][1]),
        .dataA_out(dataA_out_w[3][1]),
        .r(r_w[3][1]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(11, 12), (tile(1, 2), unit(3, 2))
                
    assign dataA_in_w[3][2] = dataA_out_w[3-1][2];
                    
    assign data_in_w[3][2] = data_out_w[3-1][2];
                    
    assign op_in_w[3][2] = op_out_w[3][2-1];
    assign inst_op_in_w[3][2] = inst_op_out_w[3][2-1];
    assign dataB_in_w[3][2] = dataB_out_w[3][2-1];
                    
    assign start_in_w[3][2] = start_out_w[3][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(12),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_3_2 (
        .clk(clk),
        .start_in(start_in_w[3][2]),
        .start_out(start_out_w[3][2]),
        .key_data(key_data_w[3][2]),
        .op_in(inst_op_in_w[3][2]),
        .op_out(inst_op_out_w[3][2]),
        .gauss_op_in(op_in_w[3][2]),
        .gauss_op_out(op_out_w[3][2]),
        .data_in(data_in_w[3][2]),
        .data_out(data_out_w[3][2]),
        .dataB_in(dataB_in_w[3][2]),
        .dataB_out(dataB_out_w[3][2]),
        .dataA_in(dataA_in_w[3][2]),
        .dataA_out(dataA_out_w[3][2]),
        .r(r_w[3][2])
    );
                    
    // compute_unit(11, 13), (tile(1, 2), unit(3, 3))
                
    assign dataA_in_w[3][3] = dataA_out_w[3-1][3];
                    
    assign data_in_w[3][3] = data_out_w[3-1][3];
                    
    assign op_in_w[3][3] = op_out_w[3][3-1];
    assign inst_op_in_w[3][3] = inst_op_out_w[3][3-1];
    assign dataB_in_w[3][3] = dataB_out_w[3][3-1];
                    
    assign start_in_w[3][3] = start_out_w[3][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(13),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_3_3 (
        .clk(clk),
        .start_in(start_in_w[3][3]),
        .start_out(start_out_w[3][3]),
        .key_data(key_data_w[3][3]),
        .op_in(inst_op_in_w[3][3]),
        .op_out(inst_op_out_w[3][3]),
        .gauss_op_in(op_in_w[3][3]),
        .gauss_op_out(op_out_w[3][3]),
        .data_in(data_in_w[3][3]),
        .data_out(data_out_w[3][3]),
        .dataB_in(dataB_in_w[3][3]),
        .dataB_out(dataB_out_w[3][3]),
        .dataA_in(dataA_in_w[3][3]),
        .dataA_out(dataA_out_w[3][3]),
        .r(r_w[3][3])
    );
                    
    // compute_unit(11, 14), (tile(1, 2), unit(3, 4))
                
    assign dataA_in_w[3][4] = dataA_out_w[3-1][4];
                    
    assign data_in_w[3][4] = data_out_w[3-1][4];
                    
    assign op_in_w[3][4] = op_out_w[3][4-1];
    assign inst_op_in_w[3][4] = inst_op_out_w[3][4-1];
    assign dataB_in_w[3][4] = dataB_out_w[3][4-1];
                    
    assign start_in_w[3][4] = start_out_w[3][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(14),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_3_4 (
        .clk(clk),
        .start_in(start_in_w[3][4]),
        .start_out(start_out_w[3][4]),
        .key_data(key_data_w[3][4]),
        .op_in(inst_op_in_w[3][4]),
        .op_out(inst_op_out_w[3][4]),
        .gauss_op_in(op_in_w[3][4]),
        .gauss_op_out(op_out_w[3][4]),
        .data_in(data_in_w[3][4]),
        .data_out(data_out_w[3][4]),
        .dataB_in(dataB_in_w[3][4]),
        .dataB_out(dataB_out_w[3][4]),
        .dataA_in(dataA_in_w[3][4]),
        .dataA_out(dataA_out_w[3][4]),
        .r(r_w[3][4])
    );
                    
    // compute_unit(11, 15), (tile(1, 2), unit(3, 5))
                
    assign dataA_in_w[3][5] = dataA_out_w[3-1][5];
                    
    assign data_in_w[3][5] = data_out_w[3-1][5];
                    
    assign op_in_w[3][5] = op_out_w[3][5-1];
    assign inst_op_in_w[3][5] = inst_op_out_w[3][5-1];
    assign dataB_in_w[3][5] = dataB_out_w[3][5-1];
                    
    assign start_in_w[3][5] = start_out_w[3][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(11),
        .COL_IDX(15),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_3_5 (
        .clk(clk),
        .start_in(start_in_w[3][5]),
        .start_out(start_out_w[3][5]),
        .key_data(key_data_w[3][5]),
        .op_in(inst_op_in_w[3][5]),
        .op_out(inst_op_out_w[3][5]),
        .gauss_op_in(op_in_w[3][5]),
        .gauss_op_out(op_out_w[3][5]),
        .data_in(data_in_w[3][5]),
        .data_out(data_out_w[3][5]),
        .dataB_in(dataB_in_w[3][5]),
        .dataB_out(dataB_out_w[3][5]),
        .dataA_in(dataA_in_w[3][5]),
        .dataA_out(dataA_out_w[3][5]),
        .r(r_w[3][5])
    );
                    
    // compute_unit(12, 10), (tile(1, 2), unit(4, 0))
                
    assign dataA_in_w[4][0] = dataA_out_w[4-1][0];
                    
    assign data_in_w[4][0] = data_out_w[4-1][0];
                    
    assign op_in_w[4][0] = gauss_op_in[2*4+1:2*4];
    assign inst_op_in_w[4][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[4][0] = dataB_in[GF_BIT*4+(GF_BIT-1):GF_BIT*4];
                    
    assign start_in_w[4][0] = start_row[4];
    assign finish_in_w[4] = finish_row[4];
                    
    always @(posedge clk) begin
        start_tmp[4] <= start_row[4-1];
        start_row[4] <= start_tmp[4];
        finish_tmp[4] <= finish_row[4-1];
        finish_row[4] <= finish_tmp[4];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(10),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_4_0 (
        .clk(clk),
        .start_in(start_in_w[4][0]),
        .start_out(start_out_w[4][0]),
        .key_data(key_data_w[4][0]),
        .op_in(inst_op_in_w[4][0]),
        .op_out(inst_op_out_w[4][0]),
        .gauss_op_in(op_in_w[4][0]),
        .gauss_op_out(op_out_w[4][0]),
        .data_in(data_in_w[4][0]),
        .data_out(data_out_w[4][0]),
        .dataB_in(dataB_in_w[4][0]),
        .dataB_out(dataB_out_w[4][0]),
        .dataA_in(dataA_in_w[4][0]),
        .dataA_out(dataA_out_w[4][0]),
        .r(r_w[4][0])
    );
                    
    // compute_unit(12, 11), (tile(1, 2), unit(4, 1))
                
    assign dataA_in_w[4][1] = dataA_out_w[4-1][1];
                    
    assign data_in_w[4][1] = data_out_w[4-1][1];
                    
    assign op_in_w[4][1] = op_out_w[4][1-1];
    assign inst_op_in_w[4][1] = inst_op_out_w[4][1-1];
    assign dataB_in_w[4][1] = dataB_out_w[4][1-1];
                    
    assign start_in_w[4][1] = start_out_w[4][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(11),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_4_1 (
        .clk(clk),
        .start_in(start_in_w[4][1]),
        .start_out(start_out_w[4][1]),
        .key_data(key_data_w[4][1]),
        .op_in(inst_op_in_w[4][1]),
        .op_out(inst_op_out_w[4][1]),
        .gauss_op_in(op_in_w[4][1]),
        .gauss_op_out(op_out_w[4][1]),
        .data_in(data_in_w[4][1]),
        .data_out(data_out_w[4][1]),
        .dataB_in(dataB_in_w[4][1]),
        .dataB_out(dataB_out_w[4][1]),
        .dataA_in(dataA_in_w[4][1]),
        .dataA_out(dataA_out_w[4][1]),
        .r(r_w[4][1])
    );
                    
    // compute_unit(12, 12), (tile(1, 2), unit(4, 2))
                
    assign dataA_in_w[4][2] = dataA_out_w[4-1][2];
                    
    assign data_in_w[4][2] = data_out_w[4-1][2];
                    
    assign op_in_w[4][2] = op_out_w[4][2-1];
    assign inst_op_in_w[4][2] = inst_op_out_w[4][2-1];
    assign dataB_in_w[4][2] = dataB_out_w[4][2-1];
                    
    assign start_in_w[4][2] = start_out_w[4][2-1];
                    
    processor_AB #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(12),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) AB_proc_4_2 (
        .clk(clk),
        .start_in(start_in_w[4][2]),
        .start_out(start_out_w[4][2]),
        .finish_in(finish_in_w[4]),
        .finish_out(finish_out_w[4]),
        .key_data(key_data_w[4][2]),
        .op_in(inst_op_in_w[4][2]),
        .op_out(inst_op_out_w[4][2]),
        .gauss_op_in(op_in_w[4][2]),
        .gauss_op_out(op_out_w[4][2]),
        .data_in(data_in_w[4][2]),
        .data_out(data_out_w[4][2]),
        .dataB_in(dataB_in_w[4][2]),
        .dataB_out(dataB_out_w[4][2]),
        .dataA_in(dataA_in_w[4][2]),
        .dataA_out(dataA_out_w[4][2]),
        .r(r_w[4][2]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(12, 13), (tile(1, 2), unit(4, 3))
                
    assign dataA_in_w[4][3] = dataA_out_w[4-1][3];
                    
    assign data_in_w[4][3] = data_out_w[4-1][3];
                    
    assign op_in_w[4][3] = op_out_w[4][3-1];
    assign inst_op_in_w[4][3] = inst_op_out_w[4][3-1];
    assign dataB_in_w[4][3] = dataB_out_w[4][3-1];
                    
    assign start_in_w[4][3] = start_out_w[4][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(13),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_4_3 (
        .clk(clk),
        .start_in(start_in_w[4][3]),
        .start_out(start_out_w[4][3]),
        .key_data(key_data_w[4][3]),
        .op_in(inst_op_in_w[4][3]),
        .op_out(inst_op_out_w[4][3]),
        .gauss_op_in(op_in_w[4][3]),
        .gauss_op_out(op_out_w[4][3]),
        .data_in(data_in_w[4][3]),
        .data_out(data_out_w[4][3]),
        .dataB_in(dataB_in_w[4][3]),
        .dataB_out(dataB_out_w[4][3]),
        .dataA_in(dataA_in_w[4][3]),
        .dataA_out(dataA_out_w[4][3]),
        .r(r_w[4][3])
    );
                    
    // compute_unit(12, 14), (tile(1, 2), unit(4, 4))
                
    assign dataA_in_w[4][4] = dataA_out_w[4-1][4];
                    
    assign data_in_w[4][4] = data_out_w[4-1][4];
                    
    assign op_in_w[4][4] = op_out_w[4][4-1];
    assign inst_op_in_w[4][4] = inst_op_out_w[4][4-1];
    assign dataB_in_w[4][4] = dataB_out_w[4][4-1];
                    
    assign start_in_w[4][4] = start_out_w[4][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(14),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_4_4 (
        .clk(clk),
        .start_in(start_in_w[4][4]),
        .start_out(start_out_w[4][4]),
        .key_data(key_data_w[4][4]),
        .op_in(inst_op_in_w[4][4]),
        .op_out(inst_op_out_w[4][4]),
        .gauss_op_in(op_in_w[4][4]),
        .gauss_op_out(op_out_w[4][4]),
        .data_in(data_in_w[4][4]),
        .data_out(data_out_w[4][4]),
        .dataB_in(dataB_in_w[4][4]),
        .dataB_out(dataB_out_w[4][4]),
        .dataA_in(dataA_in_w[4][4]),
        .dataA_out(dataA_out_w[4][4]),
        .r(r_w[4][4])
    );
                    
    // compute_unit(12, 15), (tile(1, 2), unit(4, 5))
                
    assign dataA_in_w[4][5] = dataA_out_w[4-1][5];
                    
    assign data_in_w[4][5] = data_out_w[4-1][5];
                    
    assign op_in_w[4][5] = op_out_w[4][5-1];
    assign inst_op_in_w[4][5] = inst_op_out_w[4][5-1];
    assign dataB_in_w[4][5] = dataB_out_w[4][5-1];
                    
    assign start_in_w[4][5] = start_out_w[4][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(12),
        .COL_IDX(15),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_4_5 (
        .clk(clk),
        .start_in(start_in_w[4][5]),
        .start_out(start_out_w[4][5]),
        .key_data(key_data_w[4][5]),
        .op_in(inst_op_in_w[4][5]),
        .op_out(inst_op_out_w[4][5]),
        .gauss_op_in(op_in_w[4][5]),
        .gauss_op_out(op_out_w[4][5]),
        .data_in(data_in_w[4][5]),
        .data_out(data_out_w[4][5]),
        .dataB_in(dataB_in_w[4][5]),
        .dataB_out(dataB_out_w[4][5]),
        .dataA_in(dataA_in_w[4][5]),
        .dataA_out(dataA_out_w[4][5]),
        .r(r_w[4][5])
    );
                    
    // compute_unit(13, 10), (tile(1, 2), unit(5, 0))
                
    assign dataA_in_w[5][0] = dataA_out_w[5-1][0];
                    
    assign data_in_w[5][0] = data_out_w[5-1][0];
                    
    assign op_in_w[5][0] = gauss_op_in[2*5+1:2*5];
    assign inst_op_in_w[5][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[5][0] = dataB_in[GF_BIT*5+(GF_BIT-1):GF_BIT*5];
                    
    assign start_in_w[5][0] = start_row[5];
    assign finish_in_w[5] = finish_row[5];
                    
    always @(posedge clk) begin
        start_tmp[5] <= start_row[5-1];
        start_row[5] <= start_tmp[5];
        finish_tmp[5] <= finish_row[5-1];
        finish_row[5] <= finish_tmp[5];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(10),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_5_0 (
        .clk(clk),
        .start_in(start_in_w[5][0]),
        .start_out(start_out_w[5][0]),
        .key_data(key_data_w[5][0]),
        .op_in(inst_op_in_w[5][0]),
        .op_out(inst_op_out_w[5][0]),
        .gauss_op_in(op_in_w[5][0]),
        .gauss_op_out(op_out_w[5][0]),
        .data_in(data_in_w[5][0]),
        .data_out(data_out_w[5][0]),
        .dataB_in(dataB_in_w[5][0]),
        .dataB_out(dataB_out_w[5][0]),
        .dataA_in(dataA_in_w[5][0]),
        .dataA_out(dataA_out_w[5][0]),
        .r(r_w[5][0])
    );
                    
    // compute_unit(13, 11), (tile(1, 2), unit(5, 1))
                
    assign dataA_in_w[5][1] = dataA_out_w[5-1][1];
                    
    assign data_in_w[5][1] = data_out_w[5-1][1];
                    
    assign op_in_w[5][1] = op_out_w[5][1-1];
    assign inst_op_in_w[5][1] = inst_op_out_w[5][1-1];
    assign dataB_in_w[5][1] = dataB_out_w[5][1-1];
                    
    assign start_in_w[5][1] = start_out_w[5][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(11),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_5_1 (
        .clk(clk),
        .start_in(start_in_w[5][1]),
        .start_out(start_out_w[5][1]),
        .key_data(key_data_w[5][1]),
        .op_in(inst_op_in_w[5][1]),
        .op_out(inst_op_out_w[5][1]),
        .gauss_op_in(op_in_w[5][1]),
        .gauss_op_out(op_out_w[5][1]),
        .data_in(data_in_w[5][1]),
        .data_out(data_out_w[5][1]),
        .dataB_in(dataB_in_w[5][1]),
        .dataB_out(dataB_out_w[5][1]),
        .dataA_in(dataA_in_w[5][1]),
        .dataA_out(dataA_out_w[5][1]),
        .r(r_w[5][1])
    );
                    
    // compute_unit(13, 12), (tile(1, 2), unit(5, 2))
                
    assign dataA_in_w[5][2] = dataA_out_w[5-1][2];
                    
    assign data_in_w[5][2] = data_out_w[5-1][2];
                    
    assign op_in_w[5][2] = op_out_w[5][2-1];
    assign inst_op_in_w[5][2] = inst_op_out_w[5][2-1];
    assign dataB_in_w[5][2] = dataB_out_w[5][2-1];
                    
    assign start_in_w[5][2] = start_out_w[5][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(12),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_5_2 (
        .clk(clk),
        .start_in(start_in_w[5][2]),
        .start_out(start_out_w[5][2]),
        .key_data(key_data_w[5][2]),
        .op_in(inst_op_in_w[5][2]),
        .op_out(inst_op_out_w[5][2]),
        .gauss_op_in(op_in_w[5][2]),
        .gauss_op_out(op_out_w[5][2]),
        .data_in(data_in_w[5][2]),
        .data_out(data_out_w[5][2]),
        .dataB_in(dataB_in_w[5][2]),
        .dataB_out(dataB_out_w[5][2]),
        .dataA_in(dataA_in_w[5][2]),
        .dataA_out(dataA_out_w[5][2]),
        .r(r_w[5][2])
    );
                    
    // compute_unit(13, 13), (tile(1, 2), unit(5, 3))
                
    assign dataA_in_w[5][3] = dataA_out_w[5-1][3];
                    
    assign data_in_w[5][3] = data_out_w[5-1][3];
                    
    assign op_in_w[5][3] = op_out_w[5][3-1];
    assign inst_op_in_w[5][3] = inst_op_out_w[5][3-1];
    assign dataB_in_w[5][3] = dataB_out_w[5][3-1];
                    
    assign start_in_w[5][3] = start_out_w[5][3-1];
                    
    processor_AB #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(13),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) AB_proc_5_3 (
        .clk(clk),
        .start_in(start_in_w[5][3]),
        .start_out(start_out_w[5][3]),
        .finish_in(finish_in_w[5]),
        .finish_out(finish_out_w[5]),
        .key_data(key_data_w[5][3]),
        .op_in(inst_op_in_w[5][3]),
        .op_out(inst_op_out_w[5][3]),
        .gauss_op_in(op_in_w[5][3]),
        .gauss_op_out(op_out_w[5][3]),
        .data_in(data_in_w[5][3]),
        .data_out(data_out_w[5][3]),
        .dataB_in(dataB_in_w[5][3]),
        .dataB_out(dataB_out_w[5][3]),
        .dataA_in(dataA_in_w[5][3]),
        .dataA_out(dataA_out_w[5][3]),
        .r(r_w[5][3]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(13, 14), (tile(1, 2), unit(5, 4))
                
    assign dataA_in_w[5][4] = dataA_out_w[5-1][4];
                    
    assign data_in_w[5][4] = data_out_w[5-1][4];
                    
    assign op_in_w[5][4] = op_out_w[5][4-1];
    assign inst_op_in_w[5][4] = inst_op_out_w[5][4-1];
    assign dataB_in_w[5][4] = dataB_out_w[5][4-1];
                    
    assign start_in_w[5][4] = start_out_w[5][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(14),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_5_4 (
        .clk(clk),
        .start_in(start_in_w[5][4]),
        .start_out(start_out_w[5][4]),
        .key_data(key_data_w[5][4]),
        .op_in(inst_op_in_w[5][4]),
        .op_out(inst_op_out_w[5][4]),
        .gauss_op_in(op_in_w[5][4]),
        .gauss_op_out(op_out_w[5][4]),
        .data_in(data_in_w[5][4]),
        .data_out(data_out_w[5][4]),
        .dataB_in(dataB_in_w[5][4]),
        .dataB_out(dataB_out_w[5][4]),
        .dataA_in(dataA_in_w[5][4]),
        .dataA_out(dataA_out_w[5][4]),
        .r(r_w[5][4])
    );
                    
    // compute_unit(13, 15), (tile(1, 2), unit(5, 5))
                
    assign dataA_in_w[5][5] = dataA_out_w[5-1][5];
                    
    assign data_in_w[5][5] = data_out_w[5-1][5];
                    
    assign op_in_w[5][5] = op_out_w[5][5-1];
    assign inst_op_in_w[5][5] = inst_op_out_w[5][5-1];
    assign dataB_in_w[5][5] = dataB_out_w[5][5-1];
                    
    assign start_in_w[5][5] = start_out_w[5][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(13),
        .COL_IDX(15),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_5_5 (
        .clk(clk),
        .start_in(start_in_w[5][5]),
        .start_out(start_out_w[5][5]),
        .key_data(key_data_w[5][5]),
        .op_in(inst_op_in_w[5][5]),
        .op_out(inst_op_out_w[5][5]),
        .gauss_op_in(op_in_w[5][5]),
        .gauss_op_out(op_out_w[5][5]),
        .data_in(data_in_w[5][5]),
        .data_out(data_out_w[5][5]),
        .dataB_in(dataB_in_w[5][5]),
        .dataB_out(dataB_out_w[5][5]),
        .dataA_in(dataA_in_w[5][5]),
        .dataA_out(dataA_out_w[5][5]),
        .r(r_w[5][5])
    );
                    
    // compute_unit(14, 10), (tile(1, 2), unit(6, 0))
                
    assign dataA_in_w[6][0] = dataA_out_w[6-1][0];
                    
    assign data_in_w[6][0] = data_out_w[6-1][0];
                    
    assign op_in_w[6][0] = gauss_op_in[2*6+1:2*6];
    assign inst_op_in_w[6][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[6][0] = dataB_in[GF_BIT*6+(GF_BIT-1):GF_BIT*6];
                    
    assign start_in_w[6][0] = start_row[6];
    assign finish_in_w[6] = finish_row[6];
                    
    always @(posedge clk) begin
        start_tmp[6] <= start_row[6-1];
        start_row[6] <= start_tmp[6];
        finish_tmp[6] <= finish_row[6-1];
        finish_row[6] <= finish_tmp[6];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(10),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_6_0 (
        .clk(clk),
        .start_in(start_in_w[6][0]),
        .start_out(start_out_w[6][0]),
        .key_data(key_data_w[6][0]),
        .op_in(inst_op_in_w[6][0]),
        .op_out(inst_op_out_w[6][0]),
        .gauss_op_in(op_in_w[6][0]),
        .gauss_op_out(op_out_w[6][0]),
        .data_in(data_in_w[6][0]),
        .data_out(data_out_w[6][0]),
        .dataB_in(dataB_in_w[6][0]),
        .dataB_out(dataB_out_w[6][0]),
        .dataA_in(dataA_in_w[6][0]),
        .dataA_out(dataA_out_w[6][0]),
        .r(r_w[6][0])
    );
                    
    // compute_unit(14, 11), (tile(1, 2), unit(6, 1))
                
    assign dataA_in_w[6][1] = dataA_out_w[6-1][1];
                    
    assign data_in_w[6][1] = data_out_w[6-1][1];
                    
    assign op_in_w[6][1] = op_out_w[6][1-1];
    assign inst_op_in_w[6][1] = inst_op_out_w[6][1-1];
    assign dataB_in_w[6][1] = dataB_out_w[6][1-1];
                    
    assign start_in_w[6][1] = start_out_w[6][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(11),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_6_1 (
        .clk(clk),
        .start_in(start_in_w[6][1]),
        .start_out(start_out_w[6][1]),
        .key_data(key_data_w[6][1]),
        .op_in(inst_op_in_w[6][1]),
        .op_out(inst_op_out_w[6][1]),
        .gauss_op_in(op_in_w[6][1]),
        .gauss_op_out(op_out_w[6][1]),
        .data_in(data_in_w[6][1]),
        .data_out(data_out_w[6][1]),
        .dataB_in(dataB_in_w[6][1]),
        .dataB_out(dataB_out_w[6][1]),
        .dataA_in(dataA_in_w[6][1]),
        .dataA_out(dataA_out_w[6][1]),
        .r(r_w[6][1])
    );
                    
    // compute_unit(14, 12), (tile(1, 2), unit(6, 2))
                
    assign dataA_in_w[6][2] = dataA_out_w[6-1][2];
                    
    assign data_in_w[6][2] = data_out_w[6-1][2];
                    
    assign op_in_w[6][2] = op_out_w[6][2-1];
    assign inst_op_in_w[6][2] = inst_op_out_w[6][2-1];
    assign dataB_in_w[6][2] = dataB_out_w[6][2-1];
                    
    assign start_in_w[6][2] = start_out_w[6][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(12),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_6_2 (
        .clk(clk),
        .start_in(start_in_w[6][2]),
        .start_out(start_out_w[6][2]),
        .key_data(key_data_w[6][2]),
        .op_in(inst_op_in_w[6][2]),
        .op_out(inst_op_out_w[6][2]),
        .gauss_op_in(op_in_w[6][2]),
        .gauss_op_out(op_out_w[6][2]),
        .data_in(data_in_w[6][2]),
        .data_out(data_out_w[6][2]),
        .dataB_in(dataB_in_w[6][2]),
        .dataB_out(dataB_out_w[6][2]),
        .dataA_in(dataA_in_w[6][2]),
        .dataA_out(dataA_out_w[6][2]),
        .r(r_w[6][2])
    );
                    
    // compute_unit(14, 13), (tile(1, 2), unit(6, 3))
                
    assign dataA_in_w[6][3] = dataA_out_w[6-1][3];
                    
    assign data_in_w[6][3] = data_out_w[6-1][3];
                    
    assign op_in_w[6][3] = op_out_w[6][3-1];
    assign inst_op_in_w[6][3] = inst_op_out_w[6][3-1];
    assign dataB_in_w[6][3] = dataB_out_w[6][3-1];
                    
    assign start_in_w[6][3] = start_out_w[6][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(13),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_6_3 (
        .clk(clk),
        .start_in(start_in_w[6][3]),
        .start_out(start_out_w[6][3]),
        .key_data(key_data_w[6][3]),
        .op_in(inst_op_in_w[6][3]),
        .op_out(inst_op_out_w[6][3]),
        .gauss_op_in(op_in_w[6][3]),
        .gauss_op_out(op_out_w[6][3]),
        .data_in(data_in_w[6][3]),
        .data_out(data_out_w[6][3]),
        .dataB_in(dataB_in_w[6][3]),
        .dataB_out(dataB_out_w[6][3]),
        .dataA_in(dataA_in_w[6][3]),
        .dataA_out(dataA_out_w[6][3]),
        .r(r_w[6][3])
    );
                    
    // compute_unit(14, 14), (tile(1, 2), unit(6, 4))
                
    assign dataA_in_w[6][4] = dataA_out_w[6-1][4];
                    
    assign data_in_w[6][4] = data_out_w[6-1][4];
                    
    assign op_in_w[6][4] = op_out_w[6][4-1];
    assign inst_op_in_w[6][4] = inst_op_out_w[6][4-1];
    assign dataB_in_w[6][4] = dataB_out_w[6][4-1];
                    
    assign start_in_w[6][4] = start_out_w[6][4-1];
                    
    processor_AB #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(14),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) AB_proc_6_4 (
        .clk(clk),
        .start_in(start_in_w[6][4]),
        .start_out(start_out_w[6][4]),
        .finish_in(finish_in_w[6]),
        .finish_out(finish_out_w[6]),
        .key_data(key_data_w[6][4]),
        .op_in(inst_op_in_w[6][4]),
        .op_out(inst_op_out_w[6][4]),
        .gauss_op_in(op_in_w[6][4]),
        .gauss_op_out(op_out_w[6][4]),
        .data_in(data_in_w[6][4]),
        .data_out(data_out_w[6][4]),
        .dataB_in(dataB_in_w[6][4]),
        .dataB_out(dataB_out_w[6][4]),
        .dataA_in(dataA_in_w[6][4]),
        .dataA_out(dataA_out_w[6][4]),
        .r(r_w[6][4]),
        .functionA(functionA_dup)
    );
                    
    // compute_unit(14, 15), (tile(1, 2), unit(6, 5))
                
    assign dataA_in_w[6][5] = dataA_out_w[6-1][5];
                    
    assign data_in_w[6][5] = data_out_w[6-1][5];
                    
    assign op_in_w[6][5] = op_out_w[6][5-1];
    assign inst_op_in_w[6][5] = inst_op_out_w[6][5-1];
    assign dataB_in_w[6][5] = dataB_out_w[6][5-1];
                    
    assign start_in_w[6][5] = start_out_w[6][5-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(14),
        .COL_IDX(15),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_6_5 (
        .clk(clk),
        .start_in(start_in_w[6][5]),
        .start_out(start_out_w[6][5]),
        .key_data(key_data_w[6][5]),
        .op_in(inst_op_in_w[6][5]),
        .op_out(inst_op_out_w[6][5]),
        .gauss_op_in(op_in_w[6][5]),
        .gauss_op_out(op_out_w[6][5]),
        .data_in(data_in_w[6][5]),
        .data_out(data_out_w[6][5]),
        .dataB_in(dataB_in_w[6][5]),
        .dataB_out(dataB_out_w[6][5]),
        .dataA_in(dataA_in_w[6][5]),
        .dataA_out(dataA_out_w[6][5]),
        .r(r_w[6][5])
    );
                    
    // compute_unit(15, 10), (tile(1, 2), unit(7, 0))
                
    assign dataA_in_w[7][0] = dataA_out_w[7-1][0];
                    
    assign data_in_w[7][0] = data_out_w[7-1][0];
                    
    assign op_in_w[7][0] = gauss_op_in[2*7+1:2*7];
    assign inst_op_in_w[7][0] = op_in[OP_SIZE-1:OP_SIZE-4];
    assign dataB_in_w[7][0] = dataB_in[GF_BIT*7+(GF_BIT-1):GF_BIT*7];
                    
    assign start_in_w[7][0] = start_row[7];
    assign finish_in_w[7] = finish_row[7];
                    
    always @(posedge clk) begin
        start_tmp[7] <= start_row[7-1];
        start_row[7] <= start_tmp[7];
        finish_tmp[7] <= finish_row[7-1];
        finish_row[7] <= finish_tmp[7];
    end
                        
    processor_BC #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(10),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_7_0 (
        .clk(clk),
        .start_in(start_in_w[7][0]),
        .start_out(start_out_w[7][0]),
        .key_data(key_data_w[7][0]),
        .op_in(inst_op_in_w[7][0]),
        .op_out(inst_op_out_w[7][0]),
        .gauss_op_in(op_in_w[7][0]),
        .gauss_op_out(op_out_w[7][0]),
        .data_in(data_in_w[7][0]),
        .data_out(data_out_w[7][0]),
        .dataB_in(dataB_in_w[7][0]),
        .dataB_out(dataB_out_w[7][0]),
        .dataA_in(dataA_in_w[7][0]),
        .dataA_out(dataA_out_w[7][0]),
        .r(r_w[7][0])
    );
                    
    // compute_unit(15, 11), (tile(1, 2), unit(7, 1))
                
    assign dataA_in_w[7][1] = dataA_out_w[7-1][1];
                    
    assign data_in_w[7][1] = data_out_w[7-1][1];
                    
    assign op_in_w[7][1] = op_out_w[7][1-1];
    assign inst_op_in_w[7][1] = inst_op_out_w[7][1-1];
    assign dataB_in_w[7][1] = dataB_out_w[7][1-1];
                    
    assign start_in_w[7][1] = start_out_w[7][1-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(11),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_7_1 (
        .clk(clk),
        .start_in(start_in_w[7][1]),
        .start_out(start_out_w[7][1]),
        .key_data(key_data_w[7][1]),
        .op_in(inst_op_in_w[7][1]),
        .op_out(inst_op_out_w[7][1]),
        .gauss_op_in(op_in_w[7][1]),
        .gauss_op_out(op_out_w[7][1]),
        .data_in(data_in_w[7][1]),
        .data_out(data_out_w[7][1]),
        .dataB_in(dataB_in_w[7][1]),
        .dataB_out(dataB_out_w[7][1]),
        .dataA_in(dataA_in_w[7][1]),
        .dataA_out(dataA_out_w[7][1]),
        .r(r_w[7][1])
    );
                    
    // compute_unit(15, 12), (tile(1, 2), unit(7, 2))
                
    assign dataA_in_w[7][2] = dataA_out_w[7-1][2];
                    
    assign data_in_w[7][2] = data_out_w[7-1][2];
                    
    assign op_in_w[7][2] = op_out_w[7][2-1];
    assign inst_op_in_w[7][2] = inst_op_out_w[7][2-1];
    assign dataB_in_w[7][2] = dataB_out_w[7][2-1];
                    
    assign start_in_w[7][2] = start_out_w[7][2-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(12),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_7_2 (
        .clk(clk),
        .start_in(start_in_w[7][2]),
        .start_out(start_out_w[7][2]),
        .key_data(key_data_w[7][2]),
        .op_in(inst_op_in_w[7][2]),
        .op_out(inst_op_out_w[7][2]),
        .gauss_op_in(op_in_w[7][2]),
        .gauss_op_out(op_out_w[7][2]),
        .data_in(data_in_w[7][2]),
        .data_out(data_out_w[7][2]),
        .dataB_in(dataB_in_w[7][2]),
        .dataB_out(dataB_out_w[7][2]),
        .dataA_in(dataA_in_w[7][2]),
        .dataA_out(dataA_out_w[7][2]),
        .r(r_w[7][2])
    );
                    
    // compute_unit(15, 13), (tile(1, 2), unit(7, 3))
                
    assign dataA_in_w[7][3] = dataA_out_w[7-1][3];
                    
    assign data_in_w[7][3] = data_out_w[7-1][3];
                    
    assign op_in_w[7][3] = op_out_w[7][3-1];
    assign inst_op_in_w[7][3] = inst_op_out_w[7][3-1];
    assign dataB_in_w[7][3] = dataB_out_w[7][3-1];
                    
    assign start_in_w[7][3] = start_out_w[7][3-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(13),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_7_3 (
        .clk(clk),
        .start_in(start_in_w[7][3]),
        .start_out(start_out_w[7][3]),
        .key_data(key_data_w[7][3]),
        .op_in(inst_op_in_w[7][3]),
        .op_out(inst_op_out_w[7][3]),
        .gauss_op_in(op_in_w[7][3]),
        .gauss_op_out(op_out_w[7][3]),
        .data_in(data_in_w[7][3]),
        .data_out(data_out_w[7][3]),
        .dataB_in(dataB_in_w[7][3]),
        .dataB_out(dataB_out_w[7][3]),
        .dataA_in(dataA_in_w[7][3]),
        .dataA_out(dataA_out_w[7][3]),
        .r(r_w[7][3])
    );
                    
    // compute_unit(15, 14), (tile(1, 2), unit(7, 4))
                
    assign dataA_in_w[7][4] = dataA_out_w[7-1][4];
                    
    assign data_in_w[7][4] = data_out_w[7-1][4];
                    
    assign op_in_w[7][4] = op_out_w[7][4-1];
    assign inst_op_in_w[7][4] = inst_op_out_w[7][4-1];
    assign dataB_in_w[7][4] = dataB_out_w[7][4-1];
                    
    assign start_in_w[7][4] = start_out_w[7][4-1];
                    
    processor_B #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(14),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) B_proc_7_4 (
        .clk(clk),
        .start_in(start_in_w[7][4]),
        .start_out(start_out_w[7][4]),
        .key_data(key_data_w[7][4]),
        .op_in(inst_op_in_w[7][4]),
        .op_out(inst_op_out_w[7][4]),
        .gauss_op_in(op_in_w[7][4]),
        .gauss_op_out(op_out_w[7][4]),
        .data_in(data_in_w[7][4]),
        .data_out(data_out_w[7][4]),
        .dataB_in(dataB_in_w[7][4]),
        .dataB_out(dataB_out_w[7][4]),
        .dataA_in(dataA_in_w[7][4]),
        .dataA_out(dataA_out_w[7][4]),
        .r(r_w[7][4])
    );
                    
    // compute_unit(15, 15), (tile(1, 2), unit(7, 5))
                
    assign dataA_in_w[7][5] = dataA_out_w[7-1][5];
                    
    assign data_in_w[7][5] = data_out_w[7-1][5];
                    
    assign op_in_w[7][5] = op_out_w[7][5-1];
    assign inst_op_in_w[7][5] = inst_op_out_w[7][5-1];
    assign dataB_in_w[7][5] = dataB_out_w[7][5-1];
                    
    assign start_in_w[7][5] = start_out_w[7][5-1];
                    
    processor_AB #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN(3),
        .ROW_IDX(15),
        .COL_IDX(15),
        .TILE_ROW_IDX(1),
        .TILE_COL_IDX(2),
        .NUM_PROC_COL(3)
    ) AB_proc_7_5 (
        .clk(clk),
        .start_in(start_in_w[7][5]),
        .start_out(start_out_w[7][5]),
        .finish_in(finish_in_w[7]),
        .finish_out(finish_out_w[7]),
        .key_data(key_data_w[7][5]),
        .op_in(inst_op_in_w[7][5]),
        .op_out(inst_op_out_w[7][5]),
        .gauss_op_in(op_in_w[7][5]),
        .gauss_op_out(op_out_w[7][5]),
        .data_in(data_in_w[7][5]),
        .data_out(data_out_w[7][5]),
        .dataB_in(dataB_in_w[7][5]),
        .dataB_out(dataB_out_w[7][5]),
        .dataA_in(dataA_in_w[7][5]),
        .dataA_out(dataA_out_w[7][5]),
        .r(r_w[7][5]),
        .functionA(functionA_dup)
    );
                    
    generate
        for (i = 0; i < COL; i=i+1) begin
            for (j = 0; j < GF_BIT; j=j+1) begin
                assign data_out[i*GF_BIT+j] = data_out_w[ROW-1][i][j];
            end
        end
    endgenerate
        
    generate
        for (i = 0; i < ROW; i=i+1) begin
            assign gauss_op_out[2*i+1:2*i] = op_out_w[i][COL-1];
            assign dataB_out[GF_BIT*i+(GF_BIT-1):GF_BIT*i] = dataB_out_w[i][COL-1];
        end
    endgenerate
        
    wire [6-1:0] is_one;
            
                        assign is_one[0] = (r_w[2][0] == 1); // current_row = 10, current_col = 10
                        
                        assign is_one[1] = (r_w[3][1] == 1); // current_row = 11, current_col = 11
                        
                        assign is_one[2] = (r_w[4][2] == 1); // current_row = 12, current_col = 12
                        
                        assign is_one[3] = (r_w[5][3] == 1); // current_row = 13, current_col = 13
                        
                        assign is_one[4] = (r_w[6][4] == 1); // current_row = 14, current_col = 14
                        
                        assign is_one[5] = (r_w[7][5] == 1); // current_row = 15, current_col = 15
                        
    assign r_A_and = &is_one;
            
    reg start_out_tmp;
    reg finish_out_tmp;
    always @(posedge clk) begin
        start_out_tmp  <= start_row[ROW-1];
        finish_out_tmp <= finish_row[ROW-1];
        start_out      <= start_out_tmp;
        finish_out     <= finish_out_tmp;
    end

endmodule
        
module matrix_processor#(
    parameter N = 16,
    parameter GF_BIT = 8,
    parameter OP_SIZE = 22
)(
    input wire                                  clk,
    input wire                                  rst_n,
    input wire                    [OP_SIZE-1:0] op_in,
    input wire                        [2*N-1:0] gauss_op_in,
    input wire                   [GF_BIT*N-1:0] dataA_in,
    input wire                   [GF_BIT*N-1:0] dataB_in,
    output reg                   [GF_BIT*N-1:0] data_out,
    output reg                   [GF_BIT*N-1:0] dataB_out,
    output reg                        [2*N-1:0] gauss_op_out,
    output reg                                  r_A_and
);

    // tile_row: 1
    reg [OP_SIZE-1:0] op_buffer_1;
    reg [GF_BIT*N-1:0] dataA_buffer_1;
    reg [GF_BIT*16-1:0] dataB_buffer_1;
    reg [2*16-1:0] gauss_op_buffer_1;
    
    wire        [OP_SIZE-1:0] op_buffer_1_0_r;
    wire [GF_BIT*N-1:0] dataA_buffer_1_0_r;
    wire [GF_BIT*8-1:0] dataB_buffer_1_0_r;
    wire [2*8-1:0] gauss_op_buffer_1_0_r;
    
    buffering#(
        .SIZE(OP_SIZE),
        .DELAY(1)
    ) op_buffer_1_0 (clk, op_buffer_1, op_buffer_1_0_r);

    buffering#(
        .SIZE(GF_BIT*N),
        .DELAY(1)
    ) dataA_buffer_1_0 (clk, dataA_buffer_1, dataA_buffer_1_0_r);

    buffering#(
        .SIZE(GF_BIT*8),
        .DELAY(1)
    ) dataB_buffer_1_0 (clk, dataB_buffer_1[GF_BIT*16-1:GF_BIT*(16-8)], dataB_buffer_1_0_r);

    buffering#(
        .SIZE(2*8),
        .DELAY(1)
    ) gauss_op_buffer_1_0 (clk, gauss_op_buffer_1[2*16-1:2*(16-8)], gauss_op_buffer_1_0_r);
    
    // tile_row: 0
    reg [OP_SIZE-1:0] op_buffer_0;
    reg [GF_BIT*N-1:0] dataA_buffer_0;
    reg [GF_BIT*8-1:0] dataB_buffer_0;
    reg [2*8-1:0] gauss_op_buffer_0;
    
    wire        [OP_SIZE-1:0] op_buffer_0_0_r;
    wire [GF_BIT*N-1:0] dataA_buffer_0_0_r;
    wire [GF_BIT*8-1:0] dataB_buffer_0_0_r;
    wire [2*8-1:0] gauss_op_buffer_0_0_r;
    
    buffering#(
        .SIZE(OP_SIZE),
        .DELAY(0)
    ) op_buffer_0_0 (clk, op_buffer_0, op_buffer_0_0_r);

    buffering#(
        .SIZE(GF_BIT*N),
        .DELAY(0)
    ) dataA_buffer_0_0 (clk, dataA_buffer_0, dataA_buffer_0_0_r);

    buffering#(
        .SIZE(GF_BIT*8),
        .DELAY(0)
    ) dataB_buffer_0_0 (clk, dataB_buffer_0[GF_BIT*8-1:GF_BIT*(8-8)], dataB_buffer_0_0_r);

    buffering#(
        .SIZE(2*8),
        .DELAY(0)
    ) gauss_op_buffer_0_0 (clk, gauss_op_buffer_0[2*8-1:2*(8-8)], gauss_op_buffer_0_0_r);
    
    always @(posedge clk) begin
        op_buffer_1       <= op_in;
        dataA_buffer_1    <= dataA_in;
        dataB_buffer_1    <= dataB_in;
        gauss_op_buffer_1 <= gauss_op_in;
    end

    always @(posedge clk) begin
        op_buffer_0       <= op_buffer_1;
        dataA_buffer_0    <= dataA_buffer_1;
        dataB_buffer_0    <= dataB_buffer_1[GF_BIT*8-1:0];
        gauss_op_buffer_0 <= gauss_op_buffer_1[2*8-1:0];
    end
    
    
    wire [1-1:0] r_A_and_0_0_w;
    reg r_A_and_0_0_r;
    always @(posedge clk) begin
        r_A_and_0_0_r <= &r_A_and_0_0_w;
    end
        
    wire         [OP_SIZE-1:0] op_buffer_0_0_w = op_buffer_0_0_r;
    wire [GF_BIT*5-1:0] dataA_buffer_0_0_w = dataA_buffer_0_0_r[(0+5)*GF_BIT-1:0*GF_BIT];
    
    wire      [2*8-1:0]  gauss_op_out_0_0_w;
    wire  [GF_BIT*8-1:0] dataB_out_0_0_w;
    wire [GF_BIT*5-1:0] data_out_0_0_w;
    wire                       start_out_0_0_w;
    wire                       finish_out_0_0_w;
    tile_0_0#(
        .N(N),
        .GF_BIT(GF_BIT),
        .OP_SIZE(OP_SIZE),
        .ROW(8),
        .COL(5)
    ) p_0_0 (
        .clk(clk),
        .rst_n(rst_n),
        .op_in(op_buffer_0_0_w),
        .dataA_in(dataA_buffer_0_0_w),
        .gauss_op_in(gauss_op_buffer_0_0_r),
        .dataB_in(dataB_buffer_0_0_r),
        .data_in(dataA_buffer_0_0_w),
        .start_in(op_buffer_0_0_w[15]),
        .finish_in(op_buffer_0_0_w[16]),
        .gauss_op_out(gauss_op_out_0_0_w),
        .dataB_out(dataB_out_0_0_w),
        .data_out(data_out_0_0_w),
        .start_out(start_out_0_0_w),
        .finish_out(finish_out_0_0_w),
        .r_A_and(r_A_and_0_0_w[0])
    );
            
    wire [1-1:0] r_A_and_1_0_w;
    reg r_A_and_1_0_r;
    always @(posedge clk) begin
        r_A_and_1_0_r <= &r_A_and_1_0_w;
    end
        
    wire         [OP_SIZE-1:0] op_buffer_1_0_w = op_buffer_1_0_r;
    wire [GF_BIT*5-1:0] dataA_buffer_1_0_w = dataA_buffer_1_0_r[(0+5)*GF_BIT-1:0*GF_BIT];
    
    wire      [2*8-1:0]  gauss_op_out_1_0_w;
    wire  [GF_BIT*8-1:0] dataB_out_1_0_w;
    wire [GF_BIT*5-1:0] data_out_1_0_w;
    wire                       start_out_1_0_w;
    wire                       finish_out_1_0_w;
    tile_1_0#(
        .N(N),
        .GF_BIT(GF_BIT),
        .OP_SIZE(OP_SIZE),
        .ROW(8),
        .COL(5)
    ) p_1_0 (
        .clk(clk),
        .rst_n(rst_n),
        .op_in(op_buffer_1_0_w),
        .dataA_in(dataA_buffer_1_0_w),
        .gauss_op_in(gauss_op_buffer_1_0_r),
        .dataB_in(dataB_buffer_1_0_r),
        .data_in(data_out_0_0_w),
        .start_in(start_out_0_0_w),
        .finish_in(finish_out_0_0_w),
        .gauss_op_out(gauss_op_out_1_0_w),
        .dataB_out(dataB_out_1_0_w),
        .data_out(data_out_1_0_w),
        .start_out(start_out_1_0_w),
        .finish_out(finish_out_1_0_w),
        .r_A_and(r_A_and_1_0_w[0])
    );
            
    wire [1-1:0] r_A_and_0_1_w;
    reg r_A_and_0_1_r;
    always @(posedge clk) begin
        r_A_and_0_1_r <= &r_A_and_0_1_w;
    end
        
    reg [OP_SIZE-1:0]      op_buffer_0_1_r;
    reg [GF_BIT*11-1:0] dataA_buffer_0_1_r;
    reg [GF_BIT*8-1:0] dataB_buffer_0_1_r;
    reg      [2*8-1:0] gauss_op_buffer_0_1_r;
    always @(posedge clk) begin
        op_buffer_0_1_r    <= op_buffer_0_0_r;
        dataA_buffer_0_1_r <= dataA_buffer_0_0_r[(11+5)*GF_BIT-1:5*GF_BIT];
        dataB_buffer_0_1_r <= dataB_out_0_0_w;
        gauss_op_buffer_0_1_r <= gauss_op_out_0_0_w;
    end
            
    wire         [OP_SIZE-1:0] op_buffer_0_1_w = op_buffer_0_1_r;
    wire [GF_BIT*5-1:0] dataA_buffer_0_1_w = dataA_buffer_0_1_r[(0+5)*GF_BIT-1:0*GF_BIT];
    
    wire      [2*8-1:0]  gauss_op_out_0_1_w;
    wire  [GF_BIT*8-1:0] dataB_out_0_1_w;
    wire [GF_BIT*5-1:0] data_out_0_1_w;
    wire                       start_out_0_1_w;
    wire                       finish_out_0_1_w;
    tile_0_1#(
        .N(N),
        .GF_BIT(GF_BIT),
        .OP_SIZE(OP_SIZE),
        .ROW(8),
        .COL(5)
    ) p_0_1 (
        .clk(clk),
        .rst_n(rst_n),
        .op_in(op_buffer_0_1_w),
        .dataA_in(dataA_buffer_0_1_w),
        .gauss_op_in(gauss_op_buffer_0_1_r),
        .dataB_in(dataB_buffer_0_1_r),
        .data_in(dataA_buffer_0_1_w),
        .start_in(op_buffer_0_1_w[15]),
        .finish_in(op_buffer_0_1_w[16]),
        .gauss_op_out(gauss_op_out_0_1_w),
        .dataB_out(dataB_out_0_1_w),
        .data_out(data_out_0_1_w),
        .start_out(start_out_0_1_w),
        .finish_out(finish_out_0_1_w),
        .r_A_and(r_A_and_0_1_w[0])
    );
            
    wire [1-1:0] r_A_and_1_1_w;
    reg r_A_and_1_1_r;
    always @(posedge clk) begin
        r_A_and_1_1_r <= &r_A_and_1_1_w;
    end
        
    reg [OP_SIZE-1:0]      op_buffer_1_1_r;
    reg [GF_BIT*11-1:0] dataA_buffer_1_1_r;
    reg [GF_BIT*8-1:0] dataB_buffer_1_1_r;
    reg      [2*8-1:0] gauss_op_buffer_1_1_r;
    always @(posedge clk) begin
        op_buffer_1_1_r    <= op_buffer_1_0_r;
        dataA_buffer_1_1_r <= dataA_buffer_1_0_r[(11+5)*GF_BIT-1:5*GF_BIT];
        dataB_buffer_1_1_r <= dataB_out_1_0_w;
        gauss_op_buffer_1_1_r <= gauss_op_out_1_0_w;
    end
            
    wire         [OP_SIZE-1:0] op_buffer_1_1_w = op_buffer_1_1_r;
    wire [GF_BIT*5-1:0] dataA_buffer_1_1_w = dataA_buffer_1_1_r[(0+5)*GF_BIT-1:0*GF_BIT];
    
    wire      [2*8-1:0]  gauss_op_out_1_1_w;
    wire  [GF_BIT*8-1:0] dataB_out_1_1_w;
    wire [GF_BIT*5-1:0] data_out_1_1_w;
    wire                       start_out_1_1_w;
    wire                       finish_out_1_1_w;
    tile_1_1#(
        .N(N),
        .GF_BIT(GF_BIT),
        .OP_SIZE(OP_SIZE),
        .ROW(8),
        .COL(5)
    ) p_1_1 (
        .clk(clk),
        .rst_n(rst_n),
        .op_in(op_buffer_1_1_w),
        .dataA_in(dataA_buffer_1_1_w),
        .gauss_op_in(gauss_op_buffer_1_1_r),
        .dataB_in(dataB_buffer_1_1_r),
        .data_in(data_out_0_1_w),
        .start_in(start_out_0_1_w),
        .finish_in(finish_out_0_1_w),
        .gauss_op_out(gauss_op_out_1_1_w),
        .dataB_out(dataB_out_1_1_w),
        .data_out(data_out_1_1_w),
        .start_out(start_out_1_1_w),
        .finish_out(finish_out_1_1_w),
        .r_A_and(r_A_and_1_1_w[0])
    );
            
    wire [1-1:0] r_A_and_0_2_w;
    reg r_A_and_0_2_r;
    always @(posedge clk) begin
        r_A_and_0_2_r <= &r_A_and_0_2_w;
    end
        
    reg [OP_SIZE-1:0]      op_buffer_0_2_r;
    reg [GF_BIT*6-1:0] dataA_buffer_0_2_r;
    reg [GF_BIT*8-1:0] dataB_buffer_0_2_r;
    reg      [2*8-1:0] gauss_op_buffer_0_2_r;
    always @(posedge clk) begin
        op_buffer_0_2_r    <= op_buffer_0_1_r;
        dataA_buffer_0_2_r <= dataA_buffer_0_1_r[(6+5)*GF_BIT-1:5*GF_BIT];
        dataB_buffer_0_2_r <= dataB_out_0_1_w;
        gauss_op_buffer_0_2_r <= gauss_op_out_0_1_w;
    end
            
    wire         [OP_SIZE-1:0] op_buffer_0_2_w = op_buffer_0_2_r;
    wire [GF_BIT*6-1:0] dataA_buffer_0_2_w = dataA_buffer_0_2_r[(0+6)*GF_BIT-1:0*GF_BIT];
    
    wire      [2*8-1:0]  gauss_op_out_0_2_w;
    wire  [GF_BIT*8-1:0] dataB_out_0_2_w;
    wire [GF_BIT*6-1:0] data_out_0_2_w;
    wire                       start_out_0_2_w;
    wire                       finish_out_0_2_w;
    tile_0_2#(
        .N(N),
        .GF_BIT(GF_BIT),
        .OP_SIZE(OP_SIZE),
        .ROW(8),
        .COL(6)
    ) p_0_2 (
        .clk(clk),
        .rst_n(rst_n),
        .op_in(op_buffer_0_2_w),
        .dataA_in(dataA_buffer_0_2_w),
        .gauss_op_in(gauss_op_buffer_0_2_r),
        .dataB_in(dataB_buffer_0_2_r),
        .data_in(dataA_buffer_0_2_w),
        .start_in(op_buffer_0_2_w[15]),
        .finish_in(op_buffer_0_2_w[16]),
        .gauss_op_out(gauss_op_out_0_2_w),
        .dataB_out(dataB_out_0_2_w),
        .data_out(data_out_0_2_w),
        .start_out(start_out_0_2_w),
        .finish_out(finish_out_0_2_w),
        .r_A_and(r_A_and_0_2_w[0])
    );
            
    wire [1-1:0] r_A_and_1_2_w;
    reg r_A_and_1_2_r;
    always @(posedge clk) begin
        r_A_and_1_2_r <= &r_A_and_1_2_w;
    end
        
    reg [OP_SIZE-1:0]      op_buffer_1_2_r;
    reg [GF_BIT*6-1:0] dataA_buffer_1_2_r;
    reg [GF_BIT*8-1:0] dataB_buffer_1_2_r;
    reg      [2*8-1:0] gauss_op_buffer_1_2_r;
    always @(posedge clk) begin
        op_buffer_1_2_r    <= op_buffer_1_1_r;
        dataA_buffer_1_2_r <= dataA_buffer_1_1_r[(6+5)*GF_BIT-1:5*GF_BIT];
        dataB_buffer_1_2_r <= dataB_out_1_1_w;
        gauss_op_buffer_1_2_r <= gauss_op_out_1_1_w;
    end
            
    wire         [OP_SIZE-1:0] op_buffer_1_2_w = op_buffer_1_2_r;
    wire [GF_BIT*6-1:0] dataA_buffer_1_2_w = dataA_buffer_1_2_r[(0+6)*GF_BIT-1:0*GF_BIT];
    
    wire      [2*8-1:0]  gauss_op_out_1_2_w;
    wire  [GF_BIT*8-1:0] dataB_out_1_2_w;
    wire [GF_BIT*6-1:0] data_out_1_2_w;
    wire                       start_out_1_2_w;
    wire                       finish_out_1_2_w;
    tile_1_2#(
        .N(N),
        .GF_BIT(GF_BIT),
        .OP_SIZE(OP_SIZE),
        .ROW(8),
        .COL(6)
    ) p_1_2 (
        .clk(clk),
        .rst_n(rst_n),
        .op_in(op_buffer_1_2_w),
        .dataA_in(dataA_buffer_1_2_w),
        .gauss_op_in(gauss_op_buffer_1_2_r),
        .dataB_in(dataB_buffer_1_2_r),
        .data_in(data_out_0_2_w),
        .start_in(start_out_0_2_w),
        .finish_in(finish_out_0_2_w),
        .gauss_op_out(gauss_op_out_1_2_w),
        .dataB_out(dataB_out_1_2_w),
        .data_out(data_out_1_2_w),
        .start_out(start_out_1_2_w),
        .finish_out(finish_out_1_2_w),
        .r_A_and(r_A_and_1_2_w[0])
    );
            
    wire r_A_and_0_0_tmp;
    buffering#(
        .SIZE(1),
        .DELAY(0)
    ) r_A_and_0_0_r_inst (clk, r_A_and_0_0_r, r_A_and_0_0_tmp);
        
    wire r_A_and_0_0_tmp2 = r_A_and_0_0_tmp;
            
    wire r_A_and_0_1_tmp;
    buffering#(
        .SIZE(1),
        .DELAY(0)
    ) r_A_and_0_1_r_inst (clk, r_A_and_0_1_r, r_A_and_0_1_tmp);
        
    wire r_A_and_0_1_tmp2 = r_A_and_0_1_tmp;
            
    wire r_A_and_0_2_tmp;
    buffering#(
        .SIZE(1),
        .DELAY(0)
    ) r_A_and_0_2_r_inst (clk, r_A_and_0_2_r, r_A_and_0_2_tmp);
        
    wire r_A_and_0_2_tmp2 = r_A_and_0_2_tmp;
            
    wire r_A_and_1_0_tmp;
    buffering#(
        .SIZE(1),
        .DELAY(1)
    ) r_A_and_1_0_r_inst (clk, r_A_and_1_0_r, r_A_and_1_0_tmp);
        
    reg r_A_and_1_0_tmp2;
    always @(posedge clk) begin
        r_A_and_1_0_tmp2 <= r_A_and_0_0_tmp2 & r_A_and_1_0_tmp;
    end
        
    wire r_A_and_1_1_tmp;
    buffering#(
        .SIZE(1),
        .DELAY(1)
    ) r_A_and_1_1_r_inst (clk, r_A_and_1_1_r, r_A_and_1_1_tmp);
        
    reg r_A_and_1_1_tmp2;
    always @(posedge clk) begin
        r_A_and_1_1_tmp2 <= r_A_and_0_1_tmp2 & r_A_and_1_1_tmp;
    end
        
    wire r_A_and_1_2_tmp;
    buffering#(
        .SIZE(1),
        .DELAY(1)
    ) r_A_and_1_2_r_inst (clk, r_A_and_1_2_r, r_A_and_1_2_tmp);
        
    reg r_A_and_1_2_tmp2;
    always @(posedge clk) begin
        r_A_and_1_2_tmp2 <= r_A_and_0_2_tmp2 & r_A_and_1_2_tmp;
    end
        
    wire [GF_BIT*5-1:0] data_out_buffer_0_w;
    wire [GF_BIT*5-1:0] data_out_buffer_0_r;
    buffering#(
        .SIZE(GF_BIT*5),
        .DELAY(4)
    ) data_out_0_inst (clk, data_out_buffer_0_w, data_out_buffer_0_r);
    
    wire r_A_and_1_0_tmp2_r;
    buffering#(
        .SIZE(1),
        .DELAY(4)
    ) r_A_and_1_0_inst (clk, r_A_and_1_0_tmp2, r_A_and_1_0_tmp2_r);
    
    assign data_out_buffer_0_w[(0+5)*GF_BIT-1:0*GF_BIT] = data_out_1_0_w;
        
    wire [GF_BIT*5-1:0] data_out_buffer_1_w;
    wire [GF_BIT*5-1:0] data_out_buffer_1_r;
    buffering#(
        .SIZE(GF_BIT*5),
        .DELAY(2)
    ) data_out_1_inst (clk, data_out_buffer_1_w, data_out_buffer_1_r);
    
    wire r_A_and_1_1_tmp2_r;
    buffering#(
        .SIZE(1),
        .DELAY(2)
    ) r_A_and_1_1_inst (clk, r_A_and_1_1_tmp2, r_A_and_1_1_tmp2_r);
    
    assign data_out_buffer_1_w[(0+5)*GF_BIT-1:0*GF_BIT] = data_out_1_1_w;
        
    wire [GF_BIT*6-1:0] data_out_buffer_2_w;
    wire [GF_BIT*6-1:0] data_out_buffer_2_r;
    buffering#(
        .SIZE(GF_BIT*6),
        .DELAY(0)
    ) data_out_2_inst (clk, data_out_buffer_2_w, data_out_buffer_2_r);
    
    wire r_A_and_1_2_tmp2_r;
    buffering#(
        .SIZE(1),
        .DELAY(0)
    ) r_A_and_1_2_inst (clk, r_A_and_1_2_tmp2, r_A_and_1_2_tmp2_r);
    
    assign data_out_buffer_2_w[(0+6)*GF_BIT-1:0*GF_BIT] = data_out_1_2_w;
        
    wire [GF_BIT*6-1:0] combined_data_out_2 = data_out_buffer_2_r;
    wire combined_r_A_and_2 = r_A_and_1_2_tmp2_r;
        
    wire [GF_BIT*11-1:0] combined_data_out_1;
    reg [GF_BIT*6-1:0] buffer_last_data_out_1;
    always @(posedge clk) begin
        buffer_last_data_out_1 <= combined_data_out_2;
    end
    assign combined_data_out_1 = {buffer_last_data_out_1, data_out_buffer_1_r};
    
    reg combined_r_A_and_1;
    always @(posedge clk) begin
        combined_r_A_and_1 <= r_A_and_1_1_tmp2_r & combined_r_A_and_2;
    end
    
    wire [GF_BIT*16-1:0] combined_data_out_0;
    reg [GF_BIT*11-1:0] buffer_last_data_out_0;
    always @(posedge clk) begin
        buffer_last_data_out_0 <= combined_data_out_1;
    end
    assign combined_data_out_0 = {buffer_last_data_out_0, data_out_buffer_0_r};
    
    reg combined_r_A_and_0;
    always @(posedge clk) begin
        combined_r_A_and_0 <= r_A_and_1_0_tmp2_r & combined_r_A_and_1;
    end
    
    wire [GF_BIT*8-1:0] dataB_out_buffer_0_r;
    buffering#(
        .SIZE(GF_BIT*8),
        .DELAY(1)
    ) dataB_out_buffer_0_inst (clk, dataB_out_0_2_w, dataB_out_buffer_0_r);

    wire [2*8-1:0] gauss_op_out_buffer_0_r;
    buffering#(
        .SIZE(2*8),
        .DELAY(1)
    ) gauss_op_out_buffer_0_inst (clk, gauss_op_out_0_2_w, gauss_op_out_buffer_0_r);
    
    wire [GF_BIT*8-1:0] dataB_out_buffer_1_r;
    buffering#(
        .SIZE(GF_BIT*8),
        .DELAY(2)
    ) dataB_out_buffer_1_inst (clk, dataB_out_1_2_w, dataB_out_buffer_1_r);

    wire [2*8-1:0] gauss_op_out_buffer_1_r;
    buffering#(
        .SIZE(2*8),
        .DELAY(2)
    ) gauss_op_out_buffer_1_inst (clk, gauss_op_out_1_2_w, gauss_op_out_buffer_1_r);
    
    wire [GF_BIT*8-1:0] combined_dataB_out_0 = dataB_out_buffer_0_r;
    wire [2*8-1:0] combined_gauss_op_out_0 = gauss_op_out_buffer_0_r;
        
    wire [GF_BIT*16-1:0] combined_dataB_out_1;
    reg [GF_BIT*8-1:0] buffer_last_dataB_out_1;
    always @(posedge clk) begin
        buffer_last_dataB_out_1 <= combined_dataB_out_0;
    end
    assign combined_dataB_out_1 = {dataB_out_buffer_1_r, buffer_last_dataB_out_1};

    wire [2*16-1:0] combined_gauss_op_out_1;
    reg [2*8-1:0] buffer_last_gauss_op_out_1;
    always @(posedge clk) begin
        buffer_last_gauss_op_out_1 <= combined_gauss_op_out_0;
    end
    assign combined_gauss_op_out_1 = {gauss_op_out_buffer_1_r, buffer_last_gauss_op_out_1};
    
    wire [GF_BIT*N-1:0] dataB_final_buffer_r;
    buffering#(
        .SIZE(GF_BIT*N),
        .DELAY(2)
    ) dataB_final_buffer_inst (clk, combined_dataB_out_1, dataB_final_buffer_r);

    wire [2*N-1:0] gauss_op_final_buffer_r;
    buffering#(
        .SIZE(2*N),
        .DELAY(2)
    ) gauss_op_final_buffer_inst (clk, combined_gauss_op_out_1, gauss_op_final_buffer_r);

    always @(posedge clk) begin
        data_out     <= combined_data_out_0;
        r_A_and      <= combined_r_A_and_0;
        dataB_out    <= dataB_final_buffer_r;
        gauss_op_out <= gauss_op_final_buffer_r;
    end

endmodule
