module buffering#(
    parameter SIZE = 8,
    parameter DELAY = 0
)(
    input             clk,
    input  [SIZE-1:0] i_wire,
    output [SIZE-1:0] o_wire
);
    generate
        genvar i;
        if (DELAY == 0) begin
            assign o_wire = i_wire;
        end else begin
            reg [SIZE-1:0] buffer[0:DELAY-1];
            for (i = 0; i < DELAY; i=i+1) begin
                if (i == 0) begin
                    always @(posedge clk) begin
                        buffer[i] <= i_wire;
                    end
                end else begin
                    always @(posedge clk) begin
                        buffer[i] <= buffer[i-1];
                    end
                end
            end
            assign o_wire = buffer[DELAY-1];
        end
    endgenerate

endmodule