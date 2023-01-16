module mem #(
    parameter WIDTH = 8,
    parameter DEPTH = 9,
    parameter FILE = ""
)(
    input  wire                         clock,
    input  wire         [WIDTH-1:0]      data,
    input  wire [$clog2(DEPTH)-1:0] rdaddress,
    input  wire [$clog2(DEPTH)-1:0] wraddress,
    input  wire                          wren,
    output reg          [WIDTH-1:0]         q
);
  
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    integer i;

    initial begin
        // read file contents if FILE is given
        if (FILE != "") begin
            $readmemb(FILE, mem);
        end else begin
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] = {WIDTH{1'b0}};
        end
    end

    always @ (posedge clock) begin
        if (wren)
            mem[wraddress] <= data;
    end

    always @ (posedge clock) begin
        q <= mem[rdaddress];
    end

endmodule

module lutmem #(
    parameter WIDTH = 8,
    parameter DEPTH = 9,
    parameter FILE = ""
)(
    input  wire                         clock,
    input  wire         [WIDTH-1:0]      data,
    input  wire [$clog2(DEPTH)-1:0] rdaddress,
    input  wire [$clog2(DEPTH)-1:0] wraddress,
    input  wire                          wren,
    output reg          [WIDTH-1:0]         q
);
  
    (* ram_style="distributed" *)
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    integer i;

    initial begin
        // read file contents if FILE is given
        if (FILE != "") begin
            $readmemb(FILE, mem);
        end else begin
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] = {WIDTH{1'b0}};
        end
    end

    always @ (posedge clock) begin
        if (wren)
            mem[wraddress] <= data;
    end

    always @ (posedge clock) begin
        q <= mem[rdaddress];
    end

endmodule

module blockmem #(
    parameter WIDTH = 8,
    parameter DEPTH = 9,
    parameter FILE = ""
)(
    input  wire                         clock,
    input  wire         [WIDTH-1:0]      data,
    input  wire [$clog2(DEPTH)-1:0] rdaddress,
    input  wire [$clog2(DEPTH)-1:0] wraddress,
    input  wire                          wren,
    output reg          [WIDTH-1:0]         q
);
  
    (* ram_style="block" *)
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    integer i;

    initial begin
        // read file contents if FILE is given
        if (FILE != "") begin
            $readmemb(FILE, mem);
        end else begin
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] = {WIDTH{1'b0}};
        end
    end

    always @ (posedge clock) begin
        if (wren)
            mem[wraddress] <= data;
    end

    always @ (posedge clock) begin
        q <= mem[rdaddress];
    end

endmodule