`include "define.v"
module processor_BCD #(
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
    
    reg [GF_BIT-1:0] r_rep;

    wire [GF_BIT-1:0] mul_o, mul_a;
    wire [GF_BIT-1:0] mul_b; 
    assign mul_a = (op_in == 7) ? key_data : dataB_in;
    assign mul_b = (op_in == 1) ? (gauss_op_in[0] ? data_in : r) : dataA_in;
    
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
    assign r_reg = (op_in == 5 || op_in == 4) ? dataB_in : 
                   (op_in == 6 || op_in == 9 || op_in == 7) ? add_o :
                   (op_in == 3) ? key_data :
                   (op_in == 8) ? data_in :
                   (op_in == 1) ? 
                   ((start_in || gauss_op_in == 2'b01) ? mul_o :
                   r) : r;

    always @(posedge clk) begin
        r      <= r_reg;
        r_rep  <= r_reg;
    end

    wire [GF_BIT-1:0] data_out_w;
    reg [GF_BIT-1:0] data_out_r;
    assign data_out_w = start_in       ? 0 : 
                        gauss_op_in == 2'b00 ? data_in : // pass
                        gauss_op_in == 2'b10 ? add_o :   // add
                        r_rep;
    always @(posedge clk) begin
        data_out_r <= data_out_w;
    end
    assign data_out = (op_in == 8) ? r_rep : data_out_r;

    assign start_out = start_in;
    assign gauss_op_out = gauss_op_in;
    assign dataB_out = (op_in == 5 || op_in == 4) ? r_rep : dataB_in;

    assign dataA_out = dataA_in;
    assign op_out = op_in;
endmodule

