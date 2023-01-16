module aes_ctr_drbg (
    input wire          clk,
    input wire          rst_n,

    input wire          update,
    output wire         ready,
    output wire         shouldreset,
    output reg  [127:0] randombits
);

    parameter   AES_MODE    = 1'b0;
                // 1'b0: 128-bit key mode; 1'b1: 256-bit mode
    localparam  AES_KEYSIZE = AES_MODE ? 256 : 128;

    localparam  SIN_RESET       = 4'b0000;
    localparam  SIN_WAITKEY     = 4'b0001;
    localparam  SIN_KEYINIT     = 4'b0010;
    localparam  SIN_WAITIV      = 4'b0011;
    localparam  SIN_IVINIT      = 4'b0100;
    localparam  SIN_WAITAES     = 4'b0101;
    localparam  SIN_WRESULT     = 4'b0110;
    localparam  SIN_VPLUS       = 4'b0111;
    localparam  SIN_WAITKEY2    = 4'b1001;
    localparam  SIN_KEYINIT2    = 4'b1010;

    wire        [63:0]              trn0;
    wire        [63:0]              trn1;

    reg                             aes_init;
    reg                             aes_next;
    wire                            aes_ready;
    reg         [AES_KEYSIZE-1:0]   aes_key;
    reg         [127:0]             aes_ptext;
    wire        [127:0]             aes_ptextplus;
    wire        [127:0]             aes_ctext;

    reg         [48:0]              reseedcounter;
    wire        [48:0]              reseedcounterplus;

    reg         [3:0]               state;
    reg         [3:0]               state_next;
    reg         [6:0]               scounter;
    wire        [6:0]               scounterminus;
    reg         [6:0]               scounter_next;

    reg         [127:0]             rb_pool [7:0];
    reg         [8:0]               ra;
    reg         [8:0]               wa;

    function queuefull;
        input [8:0] WA, RA;

        begin
            if( WA[7:0] == RA[7:0] && WA[8] != RA[8] ) begin
                queuefull = 1'b1;
            end else begin
                queuefull = 1'b0;
            end
        end
    endfunction

    generate
        aes_core core0 (
                    .clk(clk),
                    .reset_n(rst_n),

                    .init(aes_init),
                    .next(aes_next),
                    .ready(aes_ready),

                    .key(AES_MODE ? aes_key : { aes_key, 128'b0 }),
                    .keylen(AES_MODE),

                    .block(aes_ptext),
                    .result(aes_ctext)
                );
    endgenerate

    assign ready = (wa != ra);
    assign shouldreset = reseedcounter[48];

    assign aes_ptextplus = { aes_ptext[127:64], aes_ptext[63:0] + 64'd1 };
    assign reseedcounterplus = reseedcounter[48] ?
                               reseedcounter : (reseedcounter + 49'd1) ;
    assign scounterminus = scounter + 7'h7f; // -1

    always @ (posedge clk) begin
        if(!rst_n) begin
            state <= SIN_RESET;
            scounter <= 7'd0;
        end else begin
            state <= state_next;
            scounter <= scounter_next;
        end
    end

    generate
        always @ (*) begin
            case (state)
                SIN_RESET: begin
                    state_next = SIN_WAITKEY;
                    scounter_next = 7'd64;
                end
                SIN_WAITKEY: begin
                    if(scounter == 7'd0) begin
                        state_next = SIN_KEYINIT;
                        scounter_next = 7'd0;
                    end else begin
                        state_next = state;
                        scounter_next = scounterminus;
                    end
                end
                SIN_KEYINIT: begin
                    if(AES_MODE) state_next = SIN_WAITKEY2; else state_next = SIN_WAITIV;
                    scounter_next = 7'd64;
                end
                SIN_WAITKEY2: begin
                    if(scounter == 7'd0) begin
                        state_next = SIN_KEYINIT2;
                        scounter_next = 7'd0;
                    end else begin
                        state_next = state;
                        scounter_next = scounterminus;
                    end
                end
                SIN_KEYINIT2: begin
                    state_next = SIN_WAITIV;
                    scounter_next = 7'd64;
                end
                SIN_WAITIV: begin
                    if(scounter == 7'd0) begin
                        state_next = SIN_IVINIT;
                        scounter_next = 7'd0;
                    end else begin
                        state_next = state;
                        scounter_next = scounterminus;
                    end
                end
                SIN_IVINIT: begin
                    state_next = SIN_WAITAES;
                    scounter_next = 7'd64;
                end
                SIN_WAITAES: begin
                    if(scounter == 7'd0) begin
                        state_next = SIN_WRESULT;
                        scounter_next = 7'd0;
                    end else begin
                        state_next = state;
                        scounter_next = scounterminus;
                    end
                end
                SIN_WRESULT: begin
                    if(!queuefull(wa, ra)) begin
                        state_next = SIN_VPLUS;
                        scounter_next = 7'd0;
                    end else begin
                        state_next = state;
                        scounter_next = scounterminus;
                    end
                end
                SIN_VPLUS: begin
                    state_next= SIN_WAITAES;
                    scounter_next = 7'd64;
                end
                //default: begin
                //    state_next = SIN_RESET;
                //    scounter_next = 7'd0;
                //end
            endcase
        end

        always @ (posedge clk) begin
            if(!rst_n) begin
                aes_init <= 1'b0;
                aes_key <= AES_MODE ? 256'b0 : 128'b0;
            end else begin
                if(state == SIN_WAITKEY && state_next == SIN_KEYINIT) begin
                    aes_init <= 1'b1;
                    if(AES_MODE) aes_key[255:128] <= { trn0, trn1 }; else aes_key <= { trn0, trn1 };
                end else if(state == SIN_WAITKEY2 && state_next == SIN_KEYINIT2) begin
                    aes_init <= 1'b1;
                    aes_key[127:0] <= { trn0, trn1 };
                end else begin
                    aes_init <= 1'b0;
                    //aes_key <= aes_key;
                end
            end
        end
    endgenerate

    always @ (posedge clk) begin
        if(!rst_n) begin
            aes_next <= 1'b0;
            aes_ptext <= 128'b0;
            reseedcounter <= 49'd0;
        end else begin
            if(state == SIN_WAITIV && state_next == SIN_IVINIT) begin
                aes_next <= 1'b1;
                aes_ptext <= { trn0, trn1 };
                reseedcounter <= reseedcounterplus;
            end else if (state == SIN_WRESULT && state_next == SIN_VPLUS) begin
                aes_next <= 1'b1;
                aes_ptext <= aes_ptextplus;
                reseedcounter <= reseedcounterplus;
            end else begin
                aes_next <= 1'b0;
                // aes_ptext <= aes_ptext;
                // reseedcounter <= reseedcounter;
            end
        end
    end

    always @ (posedge clk) begin
        if(!rst_n) begin
            wa <= 9'h0;
        end else begin
            if(state == SIN_WRESULT && state_next == SIN_VPLUS) begin
                rb_pool[wa[7:0]] <= aes_ctext;
                wa <= wa + 9'd1;
            end
        end
    end

    always @ (posedge clk) begin
        if(!rst_n) begin
            ra <= 9'h0;
            randombits <= 128'b0;
        end else begin
            if(ready && update) begin
                ra <= ra + 9'd1;
                randombits <= rb_pool[ra[7:0]];
            end
        end
    end

endmodule

