`timescale 1ns / 1ps
`define CYCLE  10.0
`define HCYCLE (`CYCLE/2)

module test_mul;
	reg clk;
    reg rst_n;
    always # (`HCYCLE) clk = ~clk;

    localparam GF_BIT = 8;

    reg [GF_BIT-1:0] data_a, data_b;
    reg [GF_BIT-1:0] out1, out2;
    integer n;

    wire [GF_BIT-1:0] gfaes_to_gft_in_1, gfaes_to_gft_out_1;
    wire [GF_BIT-1:0] gfaes_to_gft_in_2, gfaes_to_gft_out_2;
    wire [GF_BIT-1:0] gft_to_gfaes_in, gft_to_gfaes_out;
    wire [GF_BIT-1:0] inv_AES_in, inv_AES_out;
    wire [GF_BIT-1:0] inv_TOWER_in, inv_TOWER_out;
    wire [GF_BIT-1:0] o_mul_AES, a_mul_AES, b_mul_AES;
    wire [GF_BIT-1:0] o_mul_TOWER, a_mul_TOWER, b_mul_TOWER;
    generate
    	if (GF_BIT == 4) begin
    		gfaes_to_gft_16 u1_gfaes_to_gft_16(gfaes_to_gft_in_1, gfaes_to_gft_out_1);
    		gfaes_to_gft_16 u2_gfaes_to_gft_16(gfaes_to_gft_in_2, gfaes_to_gft_out_2);
    		gft_to_gfaes_16 u_gft_to_gfaes_16(gft_to_gfaes_in, gft_to_gfaes_out);
    		inv16_AES u_inv16_AES(inv_AES_in, inv_AES_out);
    		inv16_Tower u_inv16_TOWER(inv_TOWER_in, inv_TOWER_out);
    		mul16_AES u_mul16_AES(o_mul_AES, a_mul_AES, b_mul_AES);
    		mul16_Tower u_mul16_TOWER(o_mul_TOWER, a_mul_TOWER, b_mul_TOWER);
    		
    	end else if (GF_BIT == 8) begin
    		gfaes_to_gft_256 u1_gfaes_to_gft_256(gfaes_to_gft_in_1, gfaes_to_gft_out_1);
    		gfaes_to_gft_256 u2_gfaes_to_gft_256(gfaes_to_gft_in_2, gfaes_to_gft_out_2);
    		gft_to_gfaes_256 u_gft_to_gfaes_256(gft_to_gfaes_in, gft_to_gfaes_out);
    		inv256_AES u_inv256_AES(inv_AES_in, inv_AES_out);
    		inv256_Tower u_inv256_TOWER(inv_TOWER_in, inv_TOWER_out);
    		mul256_AES u_mul256_AES(o_mul_AES, a_mul_AES, b_mul_AES);
    		mul256_Tower u_mul256_TOWER(o_mul_TOWER, a_mul_TOWER, b_mul_TOWER);
    	end
    	assign inv_AES_in = data_a;
		assign a_mul_AES = inv_AES_out;
		assign b_mul_AES = data_b;
		assign gfaes_to_gft_in_1 = data_a;
		assign gfaes_to_gft_in_2 = data_b;
		assign inv_TOWER_in = gfaes_to_gft_out_1;
		assign a_mul_TOWER = inv_TOWER_out;
		assign b_mul_TOWER = gfaes_to_gft_out_2;
		assign gft_to_gfaes_in = o_mul_TOWER;
    	always @(posedge clk) begin
    		out1 <= gft_to_gfaes_out;
    		out2 <= o_mul_AES;
    	end
    endgenerate

    initial begin
    	clk = 0;
    	#((10) * `CYCLE)

    	for (n = 0; n < 1000; n=n+1) begin
			data_a = $urandom;
    		data_b = $urandom;
    		#(1 * `CYCLE);
    		if (out1 != out2) begin
    			$display("Results differ, (data_a=%x, data_b=%x, out1=%x, out2=%x)", data_a, data_b, out1, out2);
    			$finish;
    		end
    		#(1 * `CYCLE);
    	end

    	$display("Correct");
    	$finish;
    end

endmodule