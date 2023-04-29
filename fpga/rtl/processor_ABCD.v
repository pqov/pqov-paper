`include "define.v"
module processor_ABCD #(
    parameter GF_BIT  = 4,
    parameter OP_CODE_LEN = 4
)(
    input  wire                   clk,
    input  wire                   start_in,
    output wire                   start_out,
    input  wire                   finish_in,
    output wire                   finish_out,
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
    output reg       [GF_BIT-1:0] r,
    input  wire                   functionA
);
    
    reg [GF_BIT-1:0] r_rep;

    wire [GF_BIT-1:0] inv_out;
    generate
        if (GF_BIT == 4) begin
`ifdef USE_TOWER_FIELD
            inv16_Tower u_inv(data_in, inv_out);
`else
            inv16_AES u_inv(data_in, inv_out);
`endif
        end else if (GF_BIT == 8) begin
`ifdef USE_TOWER_FIELD
            inv256_Tower u_inv(data_in, inv_out);
`else
            inv256_AES u_inv(data_in, inv_out);
`endif
        end
    endgenerate

    wire [GF_BIT-1:0] mul_o, mul_a;
    wire [GF_BIT-1:0] mul_b; 
    assign mul_a = dataB_in;
    
    // MUL_RAND_SIG:   op_in = 0110, gauss_op_in = 00    -> 00
    // EVAL/CALC_LIN:  op_in = 0100, gauss_op_in = 11    -> 01
    // GAUSS (10):     op_in = 0001, gauss_op_in = 10    -> 10 // 00 don't care
    // GAUSS (others): op_in = 0001, gauss_op_in = 11/01 -> 11 
    assign mul_b = (op_in == 6) ? dataA_in :
                   (op_in == 4) ? key_data :
                   (op_in == 1) ? (gauss_op_in[0] ? data_in : r) : dataA_in;
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
    wire [GF_BIT-1:0] add_b = (gauss_op_in[1]) ? data_in : r; // d+r*dataB (add)
    assign add_o = mul_o ^ add_b;

    
    wire [GF_BIT-1:0] r_reg;
    assign r_reg = (op_in == 5) ? dataB_in : 
                   (op_in == 4 || op_in == 6 || op_in == 9) ? add_o :
                   (op_in == 3) ? key_data :
                   (op_in == 8) ? data_in :
                   (op_in == 1) ?
                   (functionA ? 
                  (data_in != 0 ? 1 : 
                  (start_in ? 0 : r)) : 
                  ((start_in || gauss_op_in == 2'b01) ? mul_o :
                   r)) : r;
    always @(posedge clk) begin
        r      <= r_reg;
        r_rep  <= r_reg;
    end
 
    wire [GF_BIT-1:0] data_out_w;
    reg [GF_BIT-1:0] data_out_r;
    assign data_out_w = functionA ? (finish_in ? r_rep : 0) : 
                       (start_in       ? 0 : 
                        gauss_op_in == 2'b00 ? data_in : // pass
                        gauss_op_in == 2'b10 ? add_o :   // add
                        r_rep);
    always @(posedge clk) begin
        data_out_r <= data_out_w;
    end
    assign data_out = (op_in == 8) ? r_rep : data_out_r;

    assign finish_out = finish_in;
    assign start_out = start_in;
    assign gauss_op_out = (!functionA) ? gauss_op_in : 
                          (start_in     ? 2'b11 : 
                          (finish_in    ? 2'b01 :
                          ((data_in==0) ? 2'b00 : 
                          ((r_rep==0)   ? 2'b01 : 2'b10))));
    assign dataB_out = (op_in == 5) ? r_rep :
                       (op_in == 6) ? dataB_in :
                       !functionA ? dataB_in :
                        (gauss_op_out == 2'b10 ? data_in : inv_out);

    assign dataA_out = dataA_in;
    assign op_out = op_in;
endmodule