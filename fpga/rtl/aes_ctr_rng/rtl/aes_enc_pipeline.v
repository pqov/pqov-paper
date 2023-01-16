//======================================================================
//
// aes_encipher_block.v
// --------------------
// The AES encipher round. A pure combinational module that implements
// the initial round, main round and final round logic for
// enciper operations.
//
//
// Author: Joachim Strombergson
// Copyright (c) 2013, 2014, Secworks Sweden AB
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or
// without modification, are permitted provided that the following
// conditions are met:
//
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//======================================================================

module aes_encipher_block_pipe #(
    parameter AES_ROUND_NUM = 10
)(
    input wire            clk,
    input wire            reset_n,
    input wire            next,
    input wire            keylen,
    output wire [3 : 0]   round,
    input wire [127 : 0]  round_key,
    output wire [31 : 0]  sboxw0,
    output wire [31 : 0]  sboxw1,
    output wire [31 : 0]  sboxw2,
    output wire [31 : 0]  sboxw3,
    input wire  [31 : 0]  new_sboxw0,
    input wire  [31 : 0]  new_sboxw1,
    input wire  [31 : 0]  new_sboxw2,
    input wire  [31 : 0]  new_sboxw3,
    input wire [127 : 0]  block,
    output reg [127 : 0]  new_block,
    output wire           ready,
    input wire     [3:0]  aes_round
);

  parameter AES_PIPELINED_STAGE = AES_ROUND_NUM+1;
  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
  localparam AES_128_BIT_KEY = 1'h0;
  localparam AES_256_BIT_KEY = 1'h1;

  localparam AES128_ROUNDS = 4'ha;
  localparam AES256_ROUNDS = 4'he;

  localparam NO_UPDATE    = 2'h0;
  localparam INIT_UPDATE  = 2'h1;
  localparam MAIN_UPDATE  = 2'h2;
  localparam FINAL_UPDATE = 2'h3;

  localparam CTRL_IDLE  = 2'h0;
  localparam CTRL_INIT  = 2'h1;
  localparam CTRL_MAIN  = 2'h2;
  localparam CTRL_FINAL = 2'h3;


  //----------------------------------------------------------------
  // Round functions with sub functions.
  //----------------------------------------------------------------
  function [7 : 0] gm2(input [7 : 0] op);
    begin
      gm2 = {op[6 : 0], 1'b0} ^ (8'h1b & {8{op[7]}});
    end
  endfunction // gm2

  function [7 : 0] gm3(input [7 : 0] op);
    begin
      gm3 = gm2(op) ^ op;
    end
  endfunction // gm3

  function [31 : 0] mixw(input [31 : 0] w);
    reg [7 : 0] b0, b1, b2, b3;
    reg [7 : 0] mb0, mb1, mb2, mb3;
    begin
      b0 = w[31 : 24];
      b1 = w[23 : 16];
      b2 = w[15 : 08];
      b3 = w[07 : 00];

      mb0 = gm2(b0) ^ gm3(b1) ^ b2      ^ b3;
      mb1 = b0      ^ gm2(b1) ^ gm3(b2) ^ b3;
      mb2 = b0      ^ b1      ^ gm2(b2) ^ gm3(b3);
      mb3 = gm3(b0) ^ b1      ^ b2      ^ gm2(b3);

      mixw = {mb0, mb1, mb2, mb3};
    end
  endfunction // mixw

  function [127 : 0] mixcolumns(input [127 : 0] data);
    reg [31 : 0] w0, w1, w2, w3;
    reg [31 : 0] ws0, ws1, ws2, ws3;
    begin
      w0 = data[127 : 096];
      w1 = data[095 : 064];
      w2 = data[063 : 032];
      w3 = data[031 : 000];

      ws0 = mixw(w0);
      ws1 = mixw(w1);
      ws2 = mixw(w2);
      ws3 = mixw(w3);

      mixcolumns = {ws0, ws1, ws2, ws3};
    end
  endfunction // mixcolumns

  function [127 : 0] shiftrows(input [127 : 0] data);
    reg [31 : 0] w0, w1, w2, w3;
    reg [31 : 0] ws0, ws1, ws2, ws3;
    begin
      w0 = data[127 : 096];
      w1 = data[095 : 064];
      w2 = data[063 : 032];
      w3 = data[031 : 000];

      ws0 = {w0[31 : 24], w1[23 : 16], w2[15 : 08], w3[07 : 00]};
      ws1 = {w1[31 : 24], w2[23 : 16], w3[15 : 08], w0[07 : 00]};
      ws2 = {w2[31 : 24], w3[23 : 16], w0[15 : 08], w1[07 : 00]};
      ws3 = {w3[31 : 24], w0[23 : 16], w1[15 : 08], w2[07 : 00]};

      shiftrows = {ws0, ws1, ws2, ws3};
    end
  endfunction // shiftrows

  function [127 : 0] addroundkey(input [127 : 0] data, input [127 : 0] rkey);
    begin
      addroundkey = data ^ rkey;
    end
  endfunction // addroundkey


  //----------------------------------------------------------------
  // Registers including update variables and write enable.
  //----------------------------------------------------------------
  
  reg [3 : 0]   round_ctr_reg;
  reg [3 : 0]   round_ctr_new;
  reg           round_ctr_we;
  reg           round_ctr_rst;
  reg           round_ctr_inc;

  reg [127 : 0] block_new;
  reg [31 : 0]  block_w0_reg;
  reg [31 : 0]  block_w1_reg;
  reg [31 : 0]  block_w2_reg;
  reg [31 : 0]  block_w3_reg;
  reg           block_w0_we;
  reg           block_w1_we;
  reg           block_w2_we;
  reg           block_w3_we;

  reg           ready_we;

  reg [1 : 0]   enc_ctrl_reg;
  reg [1 : 0]   enc_ctrl_new;
  reg           enc_ctrl_we;


  //----------------------------------------------------------------
  // Concurrent connectivity for ports etc.
  //----------------------------------------------------------------
  
  reg [3:0] aes_round_r;
  always @(posedge clk) begin
      aes_round_r <= aes_round;
  end


  //----------------------------------------------------------------
  // round_logic
  //
  // The logic needed to implement init, main and final rounds.
  //----------------------------------------------------------------
  
  reg [127:0] temp_round_key[0:AES_PIPELINED_STAGE-1];
  reg [127:0]     temp_block[0:AES_PIPELINED_STAGE-1];
  reg               next_reg[0:AES_PIPELINED_STAGE-1];
  reg [127:0] addkey_init_block;
  reg [127:0] addkey_main_block[1:AES_PIPELINED_STAGE-2];
  reg [127 : 0] addkey_final_block;
  wire [31:0] sbox_out0[1:AES_PIPELINED_STAGE-1];
  wire [31:0] sbox_out1[1:AES_PIPELINED_STAGE-1];
  wire [31:0] sbox_out2[1:AES_PIPELINED_STAGE-1];
  wire [31:0] sbox_out3[1:AES_PIPELINED_STAGE-1];
  

  integer n;
  always @(posedge clk) begin
    temp_block[0] <= addkey_init_block;
    for (n = 1; n < AES_PIPELINED_STAGE-1; n=n+1) begin
      temp_block[n] <= addkey_main_block[n];
    end
    temp_block[AES_PIPELINED_STAGE-1] <= addkey_final_block;
    
    next_reg[0] <= next;
    for (n = 1; n < AES_PIPELINED_STAGE; n=n+1) begin
      next_reg[n] <= next_reg[n-1];
    end
    for (n = 0; n < AES_PIPELINED_STAGE; n=n+1) begin
      temp_round_key[n] <= (round_ctr_reg == n) ? round_key : temp_round_key[n];
    end
  end

  // First round
  always @*
  begin
      addkey_init_block  = addroundkey(block, temp_round_key[0]);
  end 

  // Middle rounds
  generate
    genvar i;
    for (i = 1; i < AES_PIPELINED_STAGE-1; i=i+1) begin
      always @*
      begin: middle_round
          reg [127 : 0] old_block, shiftrows_block, mixcolumns_block;

          old_block             = {sbox_out0[i], sbox_out1[i], sbox_out2[i], sbox_out3[i]};
          shiftrows_block       = shiftrows(old_block);
          mixcolumns_block      = mixcolumns(shiftrows_block);
          addkey_main_block[i]  = addroundkey(mixcolumns_block, temp_round_key[i]);
      end 
    end
    for (i = 0; i < AES_PIPELINED_STAGE-1; i=i+1) begin
      aes_sbox sbox_inst0(.sboxw(temp_block[i][127:96]), .new_sboxw(sbox_out0[i+1]));
      aes_sbox sbox_inst1(.sboxw(temp_block[i][ 95:64]), .new_sboxw(sbox_out1[i+1]));
      aes_sbox sbox_inst2(.sboxw(temp_block[i][ 63:32]), .new_sboxw(sbox_out2[i+1]));
      aes_sbox sbox_inst3(.sboxw(temp_block[i][ 31: 0]), .new_sboxw(sbox_out3[i+1]));
    end
  endgenerate

  // Last round
  assign sboxw0     = temp_block[AES_PIPELINED_STAGE-2][127:96];
  assign sboxw1     = temp_block[AES_PIPELINED_STAGE-2][ 95:64];
  assign sboxw2     = temp_block[AES_PIPELINED_STAGE-2][ 63:32];
  assign sboxw3     = temp_block[AES_PIPELINED_STAGE-2][ 31: 0];
  always @*
  begin: last_round
      reg [127 : 0] old_block, shiftrows_block;
      
      old_block          = {new_sboxw0, new_sboxw1, new_sboxw2, new_sboxw3};
      shiftrows_block    = shiftrows(old_block);
      addkey_final_block = addroundkey(shiftrows_block, temp_round_key[AES_PIPELINED_STAGE-1]);
  end 
  assign round     = round_ctr_reg;
  always @(posedge clk) begin
    new_block <= {temp_block[AES_PIPELINED_STAGE-1][127:96], temp_block[AES_PIPELINED_STAGE-1][95:64], 
                 temp_block[AES_PIPELINED_STAGE-1][63:32], temp_block[AES_PIPELINED_STAGE-1][31:0]};
  end
  assign ready     = next_reg[AES_PIPELINED_STAGE-1];


  //----------------------------------------------------------------
  // round_ctr
  //
  // The round counter with reset and increase logic.
  //----------------------------------------------------------------
  always @ (posedge clk or negedge reset_n)
    begin: reg_update
      if (!reset_n)
        begin
          round_ctr_reg <= 4'h0;
        end
      else
        begin
          round_ctr_reg <= round_ctr_reg == AES_PIPELINED_STAGE ? 0 : round_ctr_reg+1;
        end
    end // reg_update

    // always @(posedge clk) begin
    //   $display("Input block: %x", block);
    //   for (n = 0; n < AES_PIPELINED_STAGE; n=n+1) begin
        
    //       $display("AES pipeline: %x %x %x %d", temp_block[n], temp_round_key[n], addkey_main_block[n], next_reg[n]);

    //   end
    // end

endmodule // aes_encipher_block

//======================================================================
// EOF aes_encipher_block.v
//======================================================================
