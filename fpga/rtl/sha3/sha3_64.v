`include "sha3_constant.v"

module sha3_64 (
  input                   clk,
  input                   rst_n,
  input       [3-1:0]     SHAmode,
  input                   ASmode,
  input                   start,
  output                  ready,
  input                   we,
  input       [5-1:0]     address,
  input       [64-1:0]    data_in,
  output reg  [64-1:0]    data_out
) ;

  reg         [1600-1:0]  rc_buf;
  reg         [1088-1:0]  rate_reg;

  reg         [5-1:0]     round_number;
  wire        [1600-1:0]  round_in;
  wire        [1600-1:0]  round_out;

  assign ready = &(round_number[4:3]);
  assign first = ~|round_number;

  // data input
  always @ (posedge clk) begin
    if(~rst_n) begin
      rate_reg <= 1088'b0;
    end else begin
      if(we) begin
        case(address)
          5'd0:   rate_reg[   0+:64] <= data_in;
          5'd1:   rate_reg[  64+:64] <= data_in;
          5'd2:   rate_reg[ 128+:64] <= data_in;
          5'd3:   rate_reg[ 192+:64] <= data_in;
          5'd4:   rate_reg[ 256+:64] <= data_in;
          5'd5:   rate_reg[ 320+:64] <= data_in;
          5'd6:   rate_reg[ 384+:64] <= data_in;
          5'd7:   rate_reg[ 448+:64] <= data_in;
          5'd8:   rate_reg[ 512+:64] <= data_in;
          5'd9:   rate_reg[ 576+:64] <= data_in;
          5'd10:  rate_reg[ 640+:64] <= data_in;
          5'd11:  rate_reg[ 704+:64] <= data_in;
          5'd12:  rate_reg[ 768+:64] <= data_in;
          5'd13:  rate_reg[ 832+:64] <= data_in;
          5'd14:  rate_reg[ 896+:64] <= data_in;
          5'd15:  rate_reg[ 960+:64] <= data_in;
          5'd16:  rate_reg[1024+:64] <= data_in;
          default: /* Do nothing */;
        endcase
      end
    end
  end

  // data output
  always @ (*) begin
    if(ready && (ASmode == `ASMODE_SQUEEZE)) begin
      case(address)
        5'd0:     data_out = rc_buf[   0+:64];
        5'd1:     data_out = rc_buf[  64+:64];
        5'd2:     data_out = rc_buf[ 128+:64];
        5'd3:     data_out = rc_buf[ 192+:64];
        5'd4:     data_out = rc_buf[ 256+:64];
        5'd5:     data_out = rc_buf[ 320+:64];
        5'd6:     data_out = rc_buf[ 384+:64];
        5'd7:     data_out = rc_buf[ 448+:64];
        5'd8:     data_out = rc_buf[ 512+:64];
        5'd9:     data_out = rc_buf[ 576+:64];
        5'd10:    data_out = rc_buf[ 640+:64];
        5'd11:    data_out = rc_buf[ 704+:64];
        5'd12:    data_out = rc_buf[ 768+:64];
        5'd13:    data_out = rc_buf[ 832+:64];
        5'd14:    data_out = rc_buf[ 896+:64];
        5'd15:    data_out = rc_buf[ 960+:64];
        5'd16:    data_out = rc_buf[1024+:64];
        default:  data_out = 64'b0;
      endcase
    end else begin
      data_out = 64'b0;
    end
  end

  always @ (posedge clk) begin
    if(~rst_n) begin
      round_number <= 5'b11000;
    end else begin
      if(ready) begin
        if(start) begin
          round_number <= 5'b00000;
        end
      end else begin
        round_number <= round_number + 5'b00001;
      end
    end
  end

  always @ (posedge clk) begin
    if(~rst_n) begin
      rc_buf <= 1600'b0;
    end else begin
      if(~ready) begin
        rc_buf <= round_out;
      end
    end
  end

  // round input assignment
  genvar idx;
  generate
    for(idx = 0; idx < 1600; idx = idx + 1) begin : round_input_control
      if(idx < 576) begin
        assign round_in[idx] = rc_buf[idx] ^
                     ((first && (ASmode == `ASMODE_ABSORB)) ? (rate_reg[idx]) : 1'b0 );
      end else if(idx < 832) begin
        assign round_in[idx] = rc_buf[idx] ^
                 ((first && (ASmode == `ASMODE_ABSORB)) ? (rate_reg[idx]) : 1'b0 );
      end else if(idx < 1088) begin
        assign round_in[idx] = rc_buf[idx] ^
                 ((first && (ASmode == `ASMODE_ABSORB)) ? (rate_reg[idx]) : 1'b0 );
      end else begin
        assign round_in[idx] = rc_buf[idx];
      end
    end
  endgenerate

  // round function instance
  keccak_round round_inst (
    .round_in(round_in),
    .round_number(round_number),
    .round_out(round_out)
  ) ;

endmodule

