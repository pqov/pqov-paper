module gfaes_to_gft_16 (
  input  [3:0] a,
  output [3:0] c );

  wire [3:0] wc;
  assign wc[0] = a[0];
  assign wc[1] = a[2]^a[3];
  assign wc[2] = a[1]^a[2]^a[3];
  assign wc[3] = a[3];

  assign c = wc;
endmodule

module gft_to_gfaes_16 (
  input  [3:0] a,
  output [3:0] c );

  wire [3:0] wc;
  assign wc[0] = a[0];
  assign wc[1] = a[1]^a[2];
  assign wc[2] = a[1]^a[3];
  assign wc[3] = a[3];

  assign c = wc;
endmodule

module gfaes_to_gft_256 (
  input  [7:0] a,
  output [7:0] c );

  wire [7:0] wc;
  assign wc[0] = a[0]^a[1];
  assign wc[1] = a[2]^a[4]^a[5];
  assign wc[2] = a[2]^a[3]^a[4]^a[7];
  assign wc[3] = a[3]^a[5]^a[6];
  assign wc[4] = a[4]^a[5]^a[6];
  assign wc[5] = a[2]^a[3];
  assign wc[6] = a[1]^a[2]^a[3]^a[4]^a[6]^a[7];
  assign wc[7] = a[5]^a[7];

  assign c = wc;
endmodule

module gft_to_gfaes_256 (
  input  [7:0] a,
  output [7:0] c);

  wire [7:0] wc;
  assign wc[0] = a[0]^a[4]^a[5]^a[6]^a[7];
  assign wc[1] = a[4]^a[5]^a[6]^a[7];
  assign wc[2] = a[1]^a[2]^a[5]^a[7];
  assign wc[3] = a[1]^a[2]^a[7];
  assign wc[4] = a[1]^a[2]^a[3]^a[4]^a[7];
  assign wc[5] = a[1]^a[3]^a[4]^a[5];
  assign wc[6] = a[2]^a[4]^a[5]^a[7];
  assign wc[7] = a[1]^a[3]^a[4]^a[5]^a[7];

  assign c = wc;
endmodule