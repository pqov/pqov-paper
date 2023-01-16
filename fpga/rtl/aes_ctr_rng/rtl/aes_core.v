//======================================================================
//
// aes.core.v
// ----------
// The AES core. This core supports key size of 128, and 256 bits.
// Most of the functionality is within the submodules.
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
`include "define.v"
module aes_core#(
  parameter AES_ROUND_NUM = 10
)(
  input wire            clk,
  input wire            reset_n,
  input wire            init,
  input wire            next,
  output wire           ready,
  input wire [255 : 0]  key,
  input wire            keylen,
  input wire [127 : 0]  block,
  output wire [127 : 0] result,
  output reg            result_valid,
  input wire [3:0]      aes_round
);




  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
  localparam CTRL_IDLE  = 2'h0;
  localparam CTRL_INIT  = 2'h1;
  localparam CTRL_NEXT  = 2'h2;


  //----------------------------------------------------------------
  // Registers including update variables and write enable.
  //----------------------------------------------------------------
  reg [1 : 0] aes_core_ctrl_reg;
  reg [1 : 0] aes_core_ctrl_new;
  reg         aes_core_ctrl_we;

  reg         result_valid_reg;
  reg         result_valid_new;
  reg         result_valid_we;

  reg         ready_reg;
  reg         ready_new;
  reg         ready_we;


  //----------------------------------------------------------------
  // Wires.
  //----------------------------------------------------------------
  reg            init_state;

  wire [127 : 0] round_key;
  wire           key_ready;

  reg            enc_next;
  wire [3 : 0]   enc_round_nr;
  wire [127 : 0] enc_new_block;
  wire           enc_ready;
  wire [31 : 0]  enc_sboxw0;
  wire [31 : 0]  enc_sboxw1;
  wire [31 : 0]  enc_sboxw2;
  wire [31 : 0]  enc_sboxw3;

  reg [127 : 0]  muxed_new_block;
  reg [3 : 0]    muxed_round_nr;
  reg            muxed_ready;

  wire [31 : 0]  keymem_sboxw;

  reg [31 : 0]   muxed_sboxw0;
  reg [31 : 0]   muxed_sboxw1;
  reg [31 : 0]   muxed_sboxw2;
  reg [31 : 0]   muxed_sboxw3;
  wire [31 : 0]  new_sboxw0;
  wire [31 : 0]  new_sboxw1;
  wire [31 : 0]  new_sboxw2;
  wire [31 : 0]  new_sboxw3;

  reg [3:0] aes_round_r;
  always @(posedge clk) begin
      aes_round_r <= aes_round;
  end

  //----------------------------------------------------------------
  // Instantiations.
  //----------------------------------------------------------------
`ifdef USE_PIPELINED_AES
  aes_encipher_block_pipe #(
                   .AES_ROUND_NUM(AES_ROUND_NUM)
                  ) enc_block (
                   .clk(clk),
                   .reset_n(reset_n),
                   .next(enc_next),
                   .keylen(keylen),
                   .round(enc_round_nr),
                   .round_key(round_key),
                   .sboxw0(enc_sboxw0),
                   .sboxw1(enc_sboxw1),
                   .sboxw2(enc_sboxw2),
                   .sboxw3(enc_sboxw3),
                   .new_sboxw0(new_sboxw0),
                   .new_sboxw1(new_sboxw1),
                   .new_sboxw2(new_sboxw2),
                   .new_sboxw3(new_sboxw3),
                   .block(block),
                   .new_block(enc_new_block),
                   .ready(enc_ready),
                   .aes_round(aes_round_r)
                  );
`else
  aes_encipher_block enc_block (
                   .clk(clk),
                   .reset_n(reset_n),
                   .next(enc_next),
                   .keylen(keylen),
                   .round(enc_round_nr),
                   .round_key(round_key),
                   .sboxw0(enc_sboxw0),
                   .sboxw1(enc_sboxw1),
                   .sboxw2(enc_sboxw2),
                   .sboxw3(enc_sboxw3),
                   .new_sboxw0(new_sboxw0),
                   .new_sboxw1(new_sboxw1),
                   .new_sboxw2(new_sboxw2),
                   .new_sboxw3(new_sboxw3),
                   .block(block),
                   .new_block(enc_new_block),
                   .ready(enc_ready),
                   .aes_round(aes_round_r)
                  );
`endif
  


  aes_key_mem keymem(
                     .clk(clk),
                     .reset_n(reset_n),

                     .key(key),
                     .keylen(keylen),
                     .init(init),

                     .round(muxed_round_nr),
                     .round_key(round_key),
                     .ready(key_ready),

                     .sboxw(keymem_sboxw),
                     .new_sboxw(new_sboxw0),
                     .aes_round(aes_round_r)
                    );


  aes_sbox sbox_inst0(.sboxw(muxed_sboxw0), .new_sboxw(new_sboxw0));
  aes_sbox sbox_inst1(.sboxw(muxed_sboxw1), .new_sboxw(new_sboxw1));
  aes_sbox sbox_inst2(.sboxw(muxed_sboxw2), .new_sboxw(new_sboxw2));
  aes_sbox sbox_inst3(.sboxw(muxed_sboxw3), .new_sboxw(new_sboxw3));


  //----------------------------------------------------------------
  // Concurrent connectivity for ports etc.
  //----------------------------------------------------------------
  assign ready        = ready_new || ready_reg; // early ready
  assign result       = muxed_new_block;
  always @(posedge clk) begin
    if (!reset_n)
      result_valid <= 0;
    else
      result_valid <= enc_ready;
  end


  //----------------------------------------------------------------
  // reg_update
  //
  // Update functionality for all registers in the core.
  // All registers are positive edge triggered with asynchronous
  // active low reset. All registers have write enable.
  //----------------------------------------------------------------
  always @ (posedge clk or negedge reset_n)
    begin: reg_update
      if (!reset_n)
        begin
          result_valid_reg  <= 1'b0;
          ready_reg         <= 1'b1;
          aes_core_ctrl_reg <= CTRL_IDLE;
        end
      else
        begin
          if (result_valid_we)
            result_valid_reg <= result_valid_new;

          if (ready_we)
            ready_reg <= ready_new;

          if (aes_core_ctrl_we)
            aes_core_ctrl_reg <= aes_core_ctrl_new;
        end
    end // reg_update


  //----------------------------------------------------------------
  // sbox_mux
  //
  // Controls which of the encipher datapath or the key memory
  // that gets access to the sbox.
  //----------------------------------------------------------------
  always @*
    begin : sbox_mux
      if (init_state)
        begin
          muxed_sboxw0 = keymem_sboxw;
        end
      else
        begin
          muxed_sboxw0 = enc_sboxw0;
        end
        muxed_sboxw1 = enc_sboxw1;
        muxed_sboxw2 = enc_sboxw2;
        muxed_sboxw3 = enc_sboxw3;
    end // sbox_mux


  //----------------------------------------------------------------
  // encdex_mux
  //
  // Controls which of the datapaths that get the next signal, have
  // access to the memory as well as the block processing result.
  //----------------------------------------------------------------
  always @*
    begin : encdec_mux
      enc_next = 1'b0;
      enc_next        = next;
      muxed_round_nr  = enc_round_nr;
      muxed_new_block = enc_new_block;
      muxed_ready     = enc_ready;
    end // encdec_mux


  //----------------------------------------------------------------
  // aes_core_ctrl
  //
  // Control FSM for aes core. Basically tracks if we are in
  // key init, encipher or decipher modes and connects the
  // different submodules to shared resources and interface ports.
  //----------------------------------------------------------------
  always @*
    begin : aes_core_ctrl
      init_state        = 1'b0;
      ready_new         = 1'b0;
      ready_we          = 1'b0;
      result_valid_new  = 1'b0;
      result_valid_we   = 1'b0;
      aes_core_ctrl_new = CTRL_IDLE;
      aes_core_ctrl_we  = 1'b0;

      case (aes_core_ctrl_reg)
        CTRL_IDLE:
          begin
            if (init)
              begin
                init_state        = 1'b1;
                ready_new         = 1'b0;
                ready_we          = 1'b1;
                result_valid_new  = 1'b0;
                result_valid_we   = 1'b1;
                aes_core_ctrl_new = CTRL_INIT;
                aes_core_ctrl_we  = 1'b1;
              end
            else if (next)
              begin
                init_state        = 1'b0;
                ready_new         = 1'b0;
                ready_we          = 1'b1;
                result_valid_new  = 1'b0;
                result_valid_we   = 1'b1;
                aes_core_ctrl_new = CTRL_NEXT;
                aes_core_ctrl_we  = 1'b1;
              end
          end

        CTRL_INIT:
          begin
            init_state = 1'b1;

            if (key_ready)
              begin
                ready_new         = 1'b1;
                ready_we          = 1'b1;
                aes_core_ctrl_new = CTRL_IDLE;
                aes_core_ctrl_we  = 1'b1;
              end
          end

        CTRL_NEXT:
          begin
            init_state = 1'b0;

            if (muxed_ready)
              begin
                ready_new         = 1'b1;
                ready_we          = 1'b1;
                result_valid_new  = 1'b1;
                result_valid_we   = 1'b1;
                aes_core_ctrl_new = CTRL_IDLE;
                aes_core_ctrl_we  = 1'b1;
             end
          end

        default:
          begin

          end
      endcase // case (aes_core_ctrl_reg)

    end // aes_core_ctrl
endmodule // aes_core

//======================================================================
// EOF aes_core.v
//======================================================================
