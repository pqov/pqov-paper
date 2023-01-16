module keccak_round (
  input   [1600-1:0]  round_in,
  input   [5-1:0]     round_number,
  output  [1600-1:0]  round_out
) ;

  wire    [64-1:0]    theta_in  [4:0][4:0];
  wire    [64-1:0]    theta_out [4:0][4:0];
  wire    [64-1:0]    rho_in    [4:0][4:0];
  wire    [64-1:0]    rho_out   [4:0][4:0];
  wire    [64-1:0]    pi_in     [4:0][4:0];
  wire    [64-1:0]    pi_out    [4:0][4:0];
  wire    [64-1:0]    chi_in    [4:0][4:0];
  wire    [64-1:0]    chi_out   [4:0][4:0];
  wire    [64-1:0]    iota_in   [4:0][4:0];
  wire    [64-1:0]    iota_out  [4:0][4:0];

  reg     [64-1:0]    round_constant_signal;

  wire    [1600-1:0]  theta_outR;
  wire    [1600-1:0]  rho_outR;
  wire    [1600-1:0]  pi_outR;
  wire    [1600-1:0]  chi_outR;

  genvar xid, yid, zid;

  /********** Connection Begin **********/

  generate
    for(xid = 0; xid < 5; xid = xid + 1) begin : LBL_connection_in_x
      for(yid = 0; yid < 5; yid = yid + 1) begin : LBL_connection_in_y
        for(zid = 0; zid < 64; zid = zid + 1) begin : LBL_connection_in_z
          assign theta_in[xid][yid][zid] =
                                          round_in[64 * (5 * yid + xid) + zid];
        end
      end
    end
  endgenerate

  generate
    for(xid = 0; xid < 5; xid = xid + 1) begin : LBL_conn_inter_x
      for(yid = 0; yid < 5; yid = yid + 1) begin : LBL_conn_inter_y
        assign rho_in[xid][yid] = theta_out[xid][yid];
        assign pi_in[xid][yid] = rho_out[xid][yid];
        assign chi_in[xid][yid] = pi_out[xid][yid];
        assign iota_in[xid][yid] = chi_out[xid][yid];
      end
    end
  endgenerate

  generate
    for(xid = 0; xid < 5; xid = xid + 1) begin : LBL_connection_out_x
      for(yid = 0; yid < 5; yid = yid + 1) begin : LBL_connection_out_y
        for(zid = 0; zid < 64; zid = zid + 1) begin : LBL_connection_out_z
          assign theta_outR[64 * (5 * yid + xid) + zid] =
                                                      theta_out[xid][yid][zid];
          assign rho_outR[64 * (5 * yid + xid) + zid] =
                                                        rho_out[xid][yid][zid];
          assign pi_outR[64 * (5 * yid + xid) + zid] =
                                                         pi_out[xid][yid][zid];
          assign chi_outR[64 * (5 * yid + xid) + zid] =
                                                        chi_out[xid][yid][zid];
          assign round_out[64 * (5 * yid + xid) + zid] =
                                                       iota_out[xid][yid][zid];
        end
      end
    end
  endgenerate

  /********** Connection End **********/

  /********** Theta Begin **********/

  wire  [64-1:0]  theta_C   [4:0];
  wire  [64-1:0]  theta_D   [4:0];

  generate
    for(xid = 0; xid < 5; xid = xid + 1) begin : LBL_theta0_x
      for(zid = 0; zid < 64; zid = zid + 1) begin : LBL_theta0_z
        assign theta_C[xid][zid] = theta_in[xid][0][zid] ^
                                   theta_in[xid][1][zid] ^
                                   theta_in[xid][2][zid] ^
                                   theta_in[xid][3][zid] ^
                                   theta_in[xid][4][zid];
        assign theta_D[xid][zid] = theta_C[(xid + 4) % 5][zid] ^
                                   theta_C[(xid + 1) % 5][(zid + 63) % 64];
      end
    end
    for(xid = 0; xid < 5; xid = xid + 1) begin : LBL_theta1_x
      for(yid = 0; yid < 5; yid = yid + 1) begin : LBL_theta1_y
        for(zid = 0; zid < 64; zid = zid + 1) begin : LBL_theta1_z
          assign theta_out[xid][yid][zid] = theta_in[xid][yid][zid] ^
                                            theta_D[xid][zid];
        end
      end
    end
  endgenerate

  /********** Theta End **********/

  /********** Rho Begin **********/

  generate
    for(zid = 0; zid < 64; zid = zid + 1) begin : LBL_rho_z
      assign rho_out[0][0][zid] = rho_in[0][0][ zid           ];
      assign rho_out[1][0][zid] = rho_in[1][0][(zid + 63) % 64];
      assign rho_out[0][2][zid] = rho_in[0][2][(zid + 61) % 64];
      assign rho_out[2][1][zid] = rho_in[2][1][(zid + 58) % 64];
      assign rho_out[1][2][zid] = rho_in[1][2][(zid + 54) % 64];
      assign rho_out[2][3][zid] = rho_in[2][3][(zid + 49) % 64];
      assign rho_out[3][3][zid] = rho_in[3][3][(zid + 43) % 64];
      assign rho_out[3][0][zid] = rho_in[3][0][(zid + 36) % 64];
      assign rho_out[0][1][zid] = rho_in[0][1][(zid + 28) % 64];
      assign rho_out[1][3][zid] = rho_in[1][3][(zid + 19) % 64];
      assign rho_out[3][1][zid] = rho_in[3][1][(zid +  9) % 64];
      assign rho_out[1][4][zid] = rho_in[1][4][(zid + 62) % 64];
      assign rho_out[4][4][zid] = rho_in[4][4][(zid + 50) % 64];
      assign rho_out[4][0][zid] = rho_in[4][0][(zid + 37) % 64];
      assign rho_out[0][3][zid] = rho_in[0][3][(zid + 23) % 64];
      assign rho_out[3][4][zid] = rho_in[3][4][(zid +  8) % 64];
      assign rho_out[4][3][zid] = rho_in[4][3][(zid + 56) % 64];
      assign rho_out[3][2][zid] = rho_in[3][2][(zid + 39) % 64];
      assign rho_out[2][2][zid] = rho_in[2][2][(zid + 21) % 64];
      assign rho_out[2][0][zid] = rho_in[2][0][(zid +  2) % 64];
      assign rho_out[0][4][zid] = rho_in[0][4][(zid + 46) % 64];
      assign rho_out[4][2][zid] = rho_in[4][2][(zid + 25) % 64];
      assign rho_out[2][4][zid] = rho_in[2][4][(zid +  3) % 64];
      assign rho_out[4][1][zid] = rho_in[4][1][(zid + 44) % 64];
      assign rho_out[1][1][zid] = rho_in[1][1][(zid + 20) % 64];
    end
  endgenerate

  /********** Rho End **********/

  /********** Pi Begin **********/

  generate
    for(xid = 0; xid < 5; xid = xid + 1) begin : LBL_pi_x
      for(yid = 0; yid < 5; yid = yid + 1) begin : LBL_pi_y
        assign pi_out[xid][yid] = pi_in[(xid + 3 * yid) % 5][xid];
      end
    end
  endgenerate

  /********** Pi End **********/

  /********** Chi Begin **********/

  generate
    for(xid = 0; xid < 5; xid = xid + 1) begin : LBL_chi_x
      for(yid = 0; yid < 5; yid = yid + 1) begin : LBL_chi_y
        for(zid = 0; zid < 64; zid = zid + 1) begin : LBL_chi_z
          assign chi_out[xid][yid][zid] = chi_in[xid][yid][zid] ^
                                          ((~chi_in[(xid + 1) % 5][yid][zid])
                                            & chi_in[(xid + 2) % 5][yid][zid]);
        end
      end
    end
  endgenerate

  /********** Chi End **********/

  /********** Iota Begin **********/

  generate
    for(xid = 0; xid < 5; xid = xid + 1) begin : LBL_iota_x
      for(yid = 0; yid < 5; yid = yid + 1) begin : LBL_iota_y
        if(xid == 0 && yid == 0) begin
          assign iota_out[xid][yid] = iota_in[xid][yid] ^
                                                        round_constant_signal;
        end else begin
          assign iota_out[xid][yid] = iota_in[xid][yid];
        end
      end
    end
  endgenerate

  always @ (*) begin
    case(round_number)
      5'd0:     round_constant_signal = 64'h0000000000000001;
      5'd1:     round_constant_signal = 64'h0000000000008082;
      5'd2:     round_constant_signal = 64'h800000000000808a;
      5'd3:     round_constant_signal = 64'h8000000080008000;
      5'd4:     round_constant_signal = 64'h000000000000808b;
      5'd5:     round_constant_signal = 64'h0000000080000001;
      5'd6:     round_constant_signal = 64'h8000000080008081;
      5'd7:     round_constant_signal = 64'h8000000000008009;
      5'd8:     round_constant_signal = 64'h000000000000008a;
      5'd9:     round_constant_signal = 64'h0000000000000088;
      5'd10:    round_constant_signal = 64'h0000000080008009;
      5'd11:    round_constant_signal = 64'h000000008000000a;
      5'd12:    round_constant_signal = 64'h000000008000808b;
      5'd13:    round_constant_signal = 64'h800000000000008b;
      5'd14:    round_constant_signal = 64'h8000000000008089;
      5'd15:    round_constant_signal = 64'h8000000000008003;
      5'd16:    round_constant_signal = 64'h8000000000008002;
      5'd17:    round_constant_signal = 64'h8000000000000080;
      5'd18:    round_constant_signal = 64'h000000000000800a;
      5'd19:    round_constant_signal = 64'h800000008000000a;
      5'd20:    round_constant_signal = 64'h8000000080008081;
      5'd21:    round_constant_signal = 64'h8000000000008080;
      5'd22:    round_constant_signal = 64'h0000000080000001;
      5'd23:    round_constant_signal = 64'h8000000080008008;
      default:  round_constant_signal = 64'h0000000000000000;
    endcase
  end

  /********** Iota End **********/

endmodule

