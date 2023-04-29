`include "define.v"
module processor_B #(
    parameter GF_BIT  = 4,
    parameter OP_CODE_LEN = 4
)(
    input  wire                   clk,
    input  wire                   start_in,
    output wire                   start_out,
    input  wire      [GF_BIT-1:0] key_data,
    input  wire [OP_CODE_LEN-1:0] op_in,
    output wire [OP_CODE_LEN-1:0] op_out,
    input  wire             [1:0] gauss_op_in,
    output wire             [1:0] gauss_op_out,
    input  wire      [GF_BIT-1:0] data_in,
    output wire      [GF_BIT-1:0] data_out,
    input  wire      [GF_BIT-1:0] dataB_in,
    output wire      [GF_BIT-1:0] dataB_out,
    input  wire      [GF_BIT-1:0] dataA_in,
    output wire      [GF_BIT-1:0] dataA_out,
    output reg       [GF_BIT-1:0] r
);

    wire [GF_BIT-1:0] mul_o, mul_a;
    reg [GF_BIT-1:0] mul_b; 
    assign mul_a = dataB_in;
    
    // MUL_MAT:        op_in = 1000, gauss_op_in = 00    -> 00
    // EVAL/CALC_LIN:  op_in = 1010, gauss_op_in = 11    -> 01
    // GAUSS (10):     op_in = 1110, gauss_op_in = 10    -> 10 // 00 don't care
    // GAUSS (others): op_in = 1110, gauss_op_in = 11/01 -> 11 
    always @(*) begin
        case({gauss_op_in[0]})
            0: mul_b = r;
            1: mul_b = data_in;
        endcase
    end
    generate
        if (GF_BIT == 4) begin
`ifdef USE_TOWER_FIELD
            mul16_Tower u_mul(mul_o, mul_a, mul_b);
`else
            mul16_AES u_mul(mul_o, mul_a, mul_b);
`endif
        end else if (GF_BIT == 8) begin
`ifdef USE_TOWER_FIELD
            mul256_Tower u_mul(mul_o, mul_a, mul_b);
`else
            mul256_AES u_mul(mul_o, mul_a, mul_b);
`endif
        end
    endgenerate
  
    wire [GF_BIT-1:0] add_o;
    assign add_o = mul_o ^ data_in;

    
    wire [GF_BIT-1:0] r_reg;
    assign r_reg = (start_in || gauss_op_in == 2'b01) ? mul_o :
                    r;

    always @(posedge clk) begin
        r      <= r_reg;
    end

    wire [GF_BIT-1:0] data_out_w;
    reg [GF_BIT-1:0] data_out_r;
    assign data_out_w = start_in       ? 0 : 
                        gauss_op_in == 2'b00 ? data_in : // pass
                        gauss_op_in == 2'b10 ? add_o :   // add
                        r;
    always @(posedge clk) begin
        data_out_r <= data_out_w;
    end
    assign data_out = data_out_r;

    assign start_out = start_in;
    assign gauss_op_out = gauss_op_in;
    assign dataB_out = dataB_in;

    // assign dataA_out = dataA_in;
    assign op_out = op_in;
endmodule

