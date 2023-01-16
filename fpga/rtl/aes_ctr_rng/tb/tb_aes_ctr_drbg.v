`timescale 1ns/100ps

// ===================================================================
// 
// tb_aes_ctr_drbg.v
// -----------------
// The testbench for AES based CTR-DRBG. This illustrates the usage
// of the DRBG implementation.
//
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

module tb_aes_ctr_drbg;

    parameter AES_MODE = 1;

    localparam CLK_PERIOD_HALF = 5;
    localparam CLK_PERIOD = CLK_PERIOD_HALF * 2;

    reg             CLK;
    reg             rst_n;
    reg             update;
    wire            ready;
    wire            shouldreset;
    wire    [127:0] randombits;

    initial begin
        CLK = 1'b0;
    end
    
    always begin
        #(CLK_PERIOD_HALF);
        CLK = ~CLK;
    end

    aes_ctr_drbg rng0 (
                    .clk(CLK),
                    .rst_n(rst_n),
                    .update(update),
                    .ready(ready),
                    .shouldreset(shouldreset),
                    .randombits(randombits)
                );

    integer i0;

    initial begin
        rst_n = 1'b1;
        update = 1'b0;

        #(2 * CLK_PERIOD);

        rst_n = 1'b0;

        #(2 * CLK_PERIOD);

        rst_n = 1'b1;

        #(1000 * CLK_PERIOD);

        for(i0 = 0 ; i0 < 256; i0 = i0 + 1) begin
            wait (ready);
            #(5 * CLK_PERIOD);
            update = 1'b1;
            #(CLK_PERIOD);
            update = 1'b0;

            #(5 * CLK_PERIOD);
        end

        $finish;
    end

    initial begin
        $dumpfile("tb_aes_ctr_drbg.vcd");
        $dumpvars;
    end

endmodule

