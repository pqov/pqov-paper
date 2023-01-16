module TRNG (
	clk,
	TRN
);

    input 				clk;
    output 	[63:0] 	    TRN;
    
    wire	[31:0]		W0;
    wire	[31:0]		W1;
    wire	[31:0]		W2;
    reg		[31:0]		R;
    wire	[30:0]		W;
    reg		[63:0]		TRN;
    
    assign W1 = ~W0;
    assign W2 = ~W1;
    assign W0 = ~W2;
    
    assign W[0] = W[1] ^ W[2];
    
    assign W[1] = W[3] ^ W[4];
    assign W[2] = W[5] ^ W[6];
    
    assign W[3] = W[7] ^ W[8];
    assign W[4] = W[9] ^ W[10];
    assign W[5] = W[11] ^ W[12];
    assign W[6] = W[13] ^ W[14];
    
    assign W[7] = W[15] ^ W[16];
    assign W[8] = W[17] ^ W[18];
    assign W[9] = W[19] ^ W[20];
    assign W[10] = W[21] ^ W[22];
    assign W[11] = W[23] ^ W[24];
    assign W[12] = W[25] ^ W[26];
    assign W[13] = W[27] ^ W[28];
    assign W[14] = W[29] ^ W[30];
    
    assign W[15] = R[0] ^ R[1];
    assign W[16] = R[2] ^ R[3];
    assign W[17] = R[4] ^ R[5];
    assign W[18] = R[6] ^ R[7];
    assign W[19] = R[8] ^ R[9];
    assign W[20] = R[10] ^ R[11];
    assign W[21] = R[12] ^ R[13];
    assign W[22] = R[14] ^ R[15];
    assign W[23] = R[16] ^ R[17];
    assign W[24] = R[18] ^ R[19];
    assign W[25] = R[20] ^ R[21];
    assign W[26] = R[22] ^ R[23];
    assign W[27] = R[24] ^ R[25];
    assign W[28] = R[26] ^ R[27];
    assign W[29] = R[28] ^ R[29];
    assign W[30] = R[30] ^ R[31];
    
    always @ (posedge clk) begin
`ifdef SIMULATION
        R <= $random;
`else
    	R <= W2;
`endif
    	TRN <= {TRN[62:0], W[0]};
    end

endmodule

