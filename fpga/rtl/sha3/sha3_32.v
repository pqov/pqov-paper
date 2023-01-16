`include "sha3_constant.v"

module sha3_32 (
  input                   clk,
  input                   rst_n,
  input       [3-1:0]     SHAmode,
  input                   ASmode,
  input                   start,
  output                  ready,
  input                   we,
  input       [6-1:0]     address,
  input       [32-1:0]    data_in,
  output reg  [32-1:0]    data_out
) ;

  reg         [1600-1:0]  rc_buf;
  reg         [1344-1:0]  rate_reg;

  reg         [5-1:0]     round_number;
  wire        [1600-1:0]  round_in;
  wire        [1600-1:0]  round_out;

  assign ready = &(round_number[4:3]);
  assign first = ~|round_number;

  // data input
  always @ (posedge clk) begin
    if(~rst_n) begin
      rate_reg <= 1344'b0;
    end else begin
      if(we) begin
        case(address)
          6'd0:   rate_reg[   0+:32] <= data_in;
          6'd1:   rate_reg[  32+:32] <= data_in;
          6'd2:   rate_reg[  64+:32] <= data_in;
          6'd3:   rate_reg[  96+:32] <= data_in;
          6'd4:   rate_reg[ 128+:32] <= data_in;
          6'd5:   rate_reg[ 160+:32] <= data_in;
          6'd6:   rate_reg[ 192+:32] <= data_in;
          6'd7:   rate_reg[ 224+:32] <= data_in;
          6'd8:   rate_reg[ 256+:32] <= data_in;
          6'd9:   rate_reg[ 288+:32] <= data_in;
          6'd10:  rate_reg[ 320+:32] <= data_in;
          6'd11:  rate_reg[ 352+:32] <= data_in;
          6'd12:  rate_reg[ 384+:32] <= data_in;
          6'd13:  rate_reg[ 416+:32] <= data_in;
          6'd14:  rate_reg[ 448+:32] <= data_in;
          6'd15:  rate_reg[ 480+:32] <= data_in;
          6'd16:  rate_reg[ 512+:32] <= data_in;
          6'd17:  rate_reg[ 544+:32] <= data_in;
          6'd18:  rate_reg[ 576+:32] <= data_in;
          6'd19:  rate_reg[ 608+:32] <= data_in;
          6'd20:  rate_reg[ 640+:32] <= data_in;
          6'd21:  rate_reg[ 672+:32] <= data_in;
          6'd22:  rate_reg[ 704+:32] <= data_in;
          6'd23:  rate_reg[ 736+:32] <= data_in;
          6'd24:  rate_reg[ 768+:32] <= data_in;
          6'd25:  rate_reg[ 800+:32] <= data_in;
          6'd26:  rate_reg[ 832+:32] <= data_in;
          6'd27:  rate_reg[ 864+:32] <= data_in;
          6'd28:  rate_reg[ 896+:32] <= data_in;
          6'd29:  rate_reg[ 928+:32] <= data_in;
          6'd30:  rate_reg[ 960+:32] <= data_in;
          6'd31:  rate_reg[ 992+:32] <= data_in;
          6'd32:  rate_reg[1024+:32] <= data_in;
          6'd33:  rate_reg[1056+:32] <= data_in;
          6'd34:  rate_reg[1088+:32] <= data_in;
          6'd35:  rate_reg[1120+:32] <= data_in;
          6'd36:  rate_reg[1152+:32] <= data_in;
          6'd37:  rate_reg[1184+:32] <= data_in;
          6'd38:  rate_reg[1216+:32] <= data_in;
          6'd39:  rate_reg[1248+:32] <= data_in;
          6'd40:  rate_reg[1280+:32] <= data_in;
          6'd41:  rate_reg[1312+:32] <= data_in;
          default: /* Do nothing */;
        endcase
      end
    end
  end

  // data output
  always @ (*) begin
    if(ready && (ASmode == `ASMODE_SQUEEZE)) begin
      case(address)
        6'd0:     data_out = rc_buf[   0+:32];
        6'd1:     data_out = rc_buf[  32+:32];
        6'd2:     data_out = rc_buf[  64+:32];
        6'd3:     data_out = rc_buf[  96+:32];
        6'd4:     data_out = rc_buf[ 128+:32];
        6'd5:     data_out = rc_buf[ 160+:32];
        6'd6:     data_out = rc_buf[ 192+:32];
        6'd7:     data_out = rc_buf[ 224+:32];
        6'd8:     data_out = rc_buf[ 256+:32];
        6'd9:     data_out = rc_buf[ 288+:32];
        6'd10:    data_out = rc_buf[ 320+:32];
        6'd11:    data_out = rc_buf[ 352+:32];
        6'd12:    data_out = rc_buf[ 384+:32];
        6'd13:    data_out = rc_buf[ 416+:32];
        6'd14:    data_out = rc_buf[ 448+:32];
        6'd15:    data_out = rc_buf[ 480+:32];
        6'd16:    data_out = rc_buf[ 512+:32];
        6'd17:    data_out = rc_buf[ 544+:32];
        6'd18:    data_out = rc_buf[ 576+:32];
        6'd19:    data_out = rc_buf[ 608+:32];
        6'd20:    data_out = rc_buf[ 640+:32];
        6'd21:    data_out = rc_buf[ 672+:32];
        6'd22:    data_out = rc_buf[ 704+:32];
        6'd23:    data_out = rc_buf[ 736+:32];
        6'd24:    data_out = rc_buf[ 768+:32];
        6'd25:    data_out = rc_buf[ 800+:32];
        6'd26:    data_out = rc_buf[ 832+:32];
        6'd27:    data_out = rc_buf[ 864+:32];
        6'd28:    data_out = rc_buf[ 896+:32];
        6'd29:    data_out = rc_buf[ 928+:32];
        6'd30:    data_out = rc_buf[ 960+:32];
        6'd31:    data_out = rc_buf[ 992+:32];
        6'd32:    data_out = rc_buf[1024+:32];
        6'd33:    data_out = rc_buf[1056+:32];
        6'd34:    data_out = rc_buf[1088+:32];
        6'd35:    data_out = rc_buf[1120+:32];
        6'd36:    data_out = rc_buf[1152+:32];
        6'd37:    data_out = rc_buf[1184+:32];
        6'd38:    data_out = rc_buf[1216+:32];
        6'd39:    data_out = rc_buf[1248+:32];
        6'd40:    data_out = rc_buf[1280+:32];
        6'd41:    data_out = rc_buf[1312+:32];
        default:  data_out = 32'b0;
      endcase
    end else begin
      data_out = 32'b0;
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
                     ( (first &&
                        (ASmode == `ASMODE_ABSORB)) ? (rate_reg[idx]) : 1'b0 );
      end else if(idx < 832) begin
        assign round_in[idx] = rc_buf[idx] ^
                 ( (first && (ASmode == `ASMODE_ABSORB) &&
                    (SHAmode != `SHAMODE_SHA3_512)) ? (rate_reg[idx]) : 1'b0 );
      end else if(idx < 1088) begin
        assign round_in[idx] = rc_buf[idx] ^
                 ( (first && (ASmode == `ASMODE_ABSORB) &&
                    (SHAmode != `SHAMODE_SHA3_512) &&
                    (SHAmode != `SHAMODE_SHA3_384)) ? (rate_reg[idx]) : 1'b0 );
      end else if(idx < 1152) begin
        assign round_in[idx] = rc_buf[idx] ^
                ( (first && (ASmode == `ASMODE_ABSORB) &&
                 ((SHAmode == `SHAMODE_SHA3_224) ||
                  (SHAmode == `SHAMODE_SHAKE_128))) ? (rate_reg[idx]) : 1'b0 );
      end else if(idx < 1344) begin
        assign round_in[idx] = rc_buf[idx] ^
                ( (first && (ASmode == `ASMODE_ABSORB) &&
                   (SHAmode == `SHAMODE_SHAKE_128)) ? (rate_reg[idx]) : 1'b0 );
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

