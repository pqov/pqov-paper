`timescale 1ns/100ps

// ===================================================================
// 
// tb_TRNG.v
// --------------
// The testbench of the TRNG. This illustrates the usage of the TRNG.
//
// Author: Bo-Yuan Peng
// Copyright (c) 2020,
//     National Taiwan University and Academia Sinica, Taiwan.
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
// ===================================================================

module tb_TRNG;

    localparam CLK_PERIOD_HALF = 5;
    localparam CLK_PERIOD = CLK_PERIOD_HALF * 2;

    reg             CLK;
    wire    [63:0]  TRN;

    initial begin
        CLK = 1'b0;
    end
    
    always begin
        #(CLK_PERIOD_HALF);
        CLK = ~CLK;
    end

    TRNG trng0 ( .clk(CLK), .TRN(TRN) );

    initial begin
        #(256 * CLK_PERIOD);
        $finish;
    end

    initial begin
        $dumpfile("tb_TRNG.vcd");
        $dumpvars;
    end

endmodule

