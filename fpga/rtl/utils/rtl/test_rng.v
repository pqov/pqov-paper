module test_rng (
    rst,
    clk,
    update,
    TRN
);
    input               rst;
    input               clk;
    input               update;
    output  [127:0]     TRN;
    

    reg [31:0] counter_w[0:31];
    reg [127:0] TRN_r;
    reg [31:0] counter[0:31];
    integer n;
    always @ (posedge clk or negedge rst) begin
        if (~rst) begin
            for (n = 0; n < 32; n=n+1) 
                counter[n] <= n*1234;
            TRN_r <= 0;
        end else begin
            for (n = 0; n < 32; n=n+1) 
                counter[n] <= counter_w[n];
            TRN_r <= update ? {counter_w[31][3:0], counter_w[30][3:0], counter_w[29][3:0], counter_w[28][3:0],
                               counter_w[27][3:0], counter_w[26][3:0], counter_w[25][3:0], counter_w[24][3:0],
                               counter_w[23][3:0], counter_w[22][3:0], counter_w[21][3:0], counter_w[20][3:0],
                               counter_w[19][3:0], counter_w[18][3:0], counter_w[17][3:0], counter_w[16][3:0],
                               counter_w[15][3:0], counter_w[14][3:0], counter_w[13][3:0], counter_w[12][3:0],
                               counter_w[11][3:0], counter_w[10][3:0], counter_w[ 9][3:0], counter_w[ 8][3:0],
                               counter_w[ 7][3:0], counter_w[ 6][3:0], counter_w[ 5][3:0], counter_w[ 4][3:0],
                               counter_w[ 3][3:0], counter_w[ 2][3:0], counter_w[ 1][3:0], counter_w[ 0][3:0]} : TRN_r;
        end
    end
    always @(*) begin
        for (n = 0; n < 32; n=n+1)
            counter_w[n] = (update) ? ((counter[n][31:8])+n+((counter[n][7:0]))) : counter[n];
    end

    assign TRN = TRN_r;
endmodule