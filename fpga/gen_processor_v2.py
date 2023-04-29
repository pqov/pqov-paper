# This code reads in the configuration file, parses it, generates matrix.v and modifies some files

import sys
import math
import numpy as np
import re
import libconf
import json
import os
import subprocess

assert(len(sys.argv) == 2), """
    usage: python3 gen_processor.py "path/to/file/*.cfg"
    example:
        python3 gen_processor.py ./01.cfg
"""

with open(sys.argv[1]) as f:
    configs = libconf.load(f)
  
# Reading from file
print(json.dumps(configs, indent=4))

(V, O)                            = (configs["V"], configs["O"])
matrix_sz                         = configs["N"]
GF_bit                            = configs["GF_bit"]
right_delay_every_X_resource_unit = configs["right_delay_every_X_resource_unit"]
col_layout                        = configs["col_layout"]
row_layout                        = configs["row_layout"]
mode                              = configs["mode"]
aes_round                         = configs["aes_round"]
use_inversion                     = configs["use_inversion"]
use_tower_field                   = configs["use_tower_field"]
use_pipelined_aes                 = configs["use_pipelined_aes"]
platform                          = configs["platform"]

assert(sum(col_layout) == sum(row_layout) and sum(col_layout) == matrix_sz)

V_ = math.ceil(V/matrix_sz)
O_ = math.ceil(O/matrix_sz)
bank = math.floor(matrix_sz/O_)
v_mod_n = (V % matrix_sz)
o_mod_n = (O % matrix_sz)
to_div = math.gcd(matrix_sz, v_mod_n, o_mod_n)
rand_state_num = 4
inst_depth = 1024
inst_len = 32

assert (mode == "classic" or mode == "pkc" or mode == "pkc_skc")
assert (platform == "zedboard" or platform == "nexys")
test_mode = 0
if mode == "classic":
    test_mode = 0
    key_depth = math.ceil(O*(O+1)//2/bank) + math.ceil(V/bank)*O + math.ceil(V*O/bank) + math.ceil(V*(V+1)//2/bank) + 1
elif mode == "pkc":
    test_mode = 1
    key_depth = math.ceil(O*(O+1)//2/bank) + math.ceil(V/bank)*O + math.ceil(V*(V+1)//2/bank) + 1
elif mode == "pkc_skc":
    test_mode = 2
    key_depth = math.ceil(O*(O+1)//2/bank) + math.ceil(V/bank)*rand_state_num + math.ceil(V*(V+1)//2/bank) + 1

key_addr_len = math.ceil(math.log(key_depth, 2))+math.ceil(math.log(bank, 2))
if (key_addr_len < 2*math.ceil(math.log(matrix_sz+1, 2))):
    key_addr_len = 2*math.ceil(math.log(matrix_sz+1, 2))
op_code_len = 4
op_size = key_addr_len+4+op_code_len
op_start_bit = key_addr_len+1
op_finish_bit = key_addr_len+2
op_functionA_bit = key_addr_len+3
op_insts = key_addr_len+4 # 4-bits

right_delay = math.ceil(len(col_layout) / right_delay_every_X_resource_unit)
right_delay_layout = []
cnt = len(col_layout)
for i in range(right_delay):
    l = []
    for j in range(right_delay_every_X_resource_unit):
        if cnt == 0:
            break
        l.append(col_layout[i*right_delay_every_X_resource_unit+j])
        cnt -= 1
    right_delay_layout.append(l)

assert(GF_bit*matrix_sz == 128)
assert(len(right_delay_layout) >= O_)
assert(right_delay_every_X_resource_unit == 1)

print(right_delay_layout)
print(col_layout)
print(row_layout)

verilog_module = ""

bram16k_num = math.ceil(key_depth/512)
if platform == "nexys":
    platform_bram = 340
else:
    platform_bram = 125

assert(key_depth > 512)
verilog_module += """
module bram16Ks #(
    parameter WIDTH = 8,
    parameter DEPTH = """+str(key_depth)+""",
    parameter FILE = "",
    parameter DELAY = 0,
    parameter BANK = """+str(bank)+"""
)(
    input  wire                                      clock,
    input  wire                      [WIDTH-1:0]      data,
    input  wire [$clog2(DEPTH)+$clog2(BANK)-1:0]   address,
    input  wire                                       wren,
    output wire                 [BANK*WIDTH-1:0]         q
);
    integer i;

    reg                      [WIDTH-1:0] tmp_data;
    reg [$clog2(DEPTH)+$clog2(BANK)-1:0] tmp_address;
    reg [$clog2(DEPTH)+$clog2(BANK)-9:0] tmp_address2;
    reg                     tmp_wren;
    always @(posedge clock) begin
        tmp_data      <= data;
        tmp_address   <= address;
        tmp_address2  <= tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9];
        tmp_wren      <= wren;
        // $display("inside: %d, %d, %d", tmp_data, tmp_address, tmp_wren);
    end 
    """
current_key_depth = 0
for i in range(bram16k_num):
    for b in range(bank):
        current_bram16k_num = current_key_depth*O*GF_bit/32
        if i == bram16k_num-1:
            if current_bram16k_num >= platform_bram*2:
                ram_type = "lutmem"
            elif key_depth-512*(bram16k_num-1) >= 128:
                ram_type = "mem"
            else:
                ram_type = "lutmem"
            verilog_module += """
    wire [WIDTH-1:0] q"""+str(b*bram16k_num+i)+""";
    """+ram_type+""" #(
        .WIDTH(WIDTH),
        .DEPTH("""+str(key_depth-512*(bram16k_num-1))+"""),
        .FILE(FILE)
    ) mem_inst"""+str(b*bram16k_num+i)+""" (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == """+str((b<<(math.ceil(math.log(bram16k_num, 2))))+i)+"""))),
        .q (q"""+str(b*bram16k_num+i)+""")
    );
        """
        else:
            if current_bram16k_num >= platform_bram*2:
                ram_type = "lutmem"
            else:
                ram_type = "mem"
            verilog_module += """
    wire [WIDTH-1:0] q"""+str(b*bram16k_num+i)+""";
    """+ram_type+""" #(
        .WIDTH(WIDTH),
        .DEPTH(512),
        .FILE(FILE)
    ) mem_inst"""+str(b*bram16k_num+i)+""" (
        .clock (clock),
        .data (tmp_data),
        .rdaddress (tmp_address[8:0]),
        .wraddress (tmp_address[8:0]),
        .wren ((tmp_wren && (tmp_address[$clog2(DEPTH)+$clog2(BANK)-1:9] == """+str((b<<(math.ceil(math.log(bram16k_num, 2))))+i)+"""))),
        .q (q"""+str(b*bram16k_num+i)+""")
    );
        """
        current_key_depth += 1
    

verilog_module += """
    reg [BANK*WIDTH-1:0] q_r;
    generate
        if (DELAY == 0) begin
            assign q[0*WIDTH+:WIDTH] = """
for b in range(bank):
    for i in range(bram16k_num):
        verilog_module += """
                       (tmp_address2 == """+str((b<<(math.ceil(math.log(bram16k_num, 2))))+i)+""") ? q"""+str(b*bram16k_num+i)+""" : """ 
verilog_module += """0;"""
for b in range(1, bank):
    verilog_module += """
            assign q["""+str(b)+"""*WIDTH+:WIDTH] = """
    for i in range(bram16k_num):
        verilog_module += """
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == """+str(i)+""") ? q"""+str(b*bram16k_num+i)+""" : """ 
    verilog_module += """0;"""
    
verilog_module += """
        end else begin
            always @ (posedge clock) begin
                q_r[0*WIDTH+:WIDTH] <="""
for b in range(bank):
    for i in range(bram16k_num):
        verilog_module += """
                       (tmp_address2 == """+str((b<<(math.ceil(math.log(bram16k_num, 2))))+i)+""") ? q"""+str(b*bram16k_num+i)+""" : """ 
verilog_module += """0;
            end"""
for b in range(1, bank):
    verilog_module += """
            always @ (posedge clock) begin
                q_r["""+str(b)+"""*WIDTH+:WIDTH] <="""
    for i in range(bram16k_num):
        verilog_module += """
                       (tmp_address2[$clog2(DEPTH)-9-1:0] == """+str(i)+""") ? q"""+str(b*bram16k_num+i)+""" : """ 
    verilog_module += """0;
            end"""
verilog_module += """
            assign q = q_r;
        end
    endgenerate
endmodule
    """

bram_type = "mem"
if key_depth > 512:
    bram_type = "bram16Ks"

for r_idx, r_num in enumerate(row_layout):
    for c_idx, c_num in enumerate(col_layout):
        start_o = O_*matrix_sz - (c_idx+1)*matrix_sz + sum(row_layout[:r_idx])
        end_o   = start_o + r_num
        if end_o > O:
            end_o = O
        o_width = end_o - start_o
        verilog_module += """
// row = {r_num}, col = {c_num}
module tile_{r_idx}_{c_idx}#(
    parameter N = {matrix_sz},
    parameter GF_BIT = {GF_bit},
    parameter OP_SIZE = {op_size},
    parameter ROW = {r_num},
    parameter COL = {c_num}
)(
    input wire                      clk,
    input wire                      rst_n,
    input wire        [OP_SIZE-1:0] op_in,        // decide which operations
    input wire     [GF_BIT*COL-1:0] dataA_in,     // for mat_mul, load
    input wire          [2*ROW-1:0] gauss_op_in,  // for gauss
    input wire     [GF_BIT*ROW-1:0] dataB_in,     // for gauss
    input wire     [GF_BIT*COL-1:0] data_in,      // for gauss, store (not used in first row)
    input wire                      start_in, 
    input wire                      finish_in,
    output wire         [2*ROW-1:0] gauss_op_out, // for gauss
    output wire    [GF_BIT*ROW-1:0] dataB_out,    // for gauss
    output wire    [GF_BIT*COL-1:0] data_out,     // for gauss, store
    output reg                      start_out,
    output reg                      finish_out,
    output wire                     r_A_and
);
    
    localparam TILE_ROW_IDX = {tile_r_idx};
    localparam TILE_COL_IDX = {tile_c_idx};
    localparam NUM_PROC_COL = {num_proc_col};
    localparam BANK = {bank}; 

    genvar i, j, k;
    integer n, m;

    wire                  start_in_w[0:ROW-1][0:COL-1];
    wire                 start_out_w[0:ROW-1][0:COL-1];
    wire                 finish_in_w[0:ROW-1];
    wire                finish_out_w[0:ROW-1];
    wire         [3:0]  inst_op_in_w[0:ROW-1][0:COL-1];
    wire         [3:0] inst_op_out_w[0:ROW-1][0:COL-1];
    wire         [1:0]       op_in_w[0:ROW-1][0:COL-1];
    wire         [1:0]      op_out_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    dataB_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]   dataB_out_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]           r_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]     data_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    dataA_in_w[0:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]   dataA_out_w[0:ROW-1][0:COL-1];
    reg   [GF_BIT-1:0]     data_in_r[1:ROW-1][0:COL-1];
    wire  [GF_BIT-1:0]    data_out_w[0:ROW-1][0:COL-1];

    reg [ROW-1 : 1] start_tmp;
    reg [ROW-1 : 1] start_row;
    
    reg [ROW-1 : 1] finish_tmp;
    reg [ROW-1 : 1] finish_row;
    
    reg functionA_dup;
    always @(posedge clk) begin
        functionA_dup <= op_in[{op_functionA_bit}];
    end

    wire [GF_BIT*{o_width}*BANK-1:0] key_data;
    wire          [GF_BIT-1:0] key_data_w[0:ROW-1][0:COL-1];
    wire                       key_wren;
    wire      [GF_BIT*ROW-1:0] key_write_data;
    generate
        if (GF_BIT*{o_width} != 0) begin: key_mem
            assign key_wren = op_in[{key_addr_len}];
            {bram_type} #(
                .WIDTH(GF_BIT*{o_width}),
                .DELAY(1)
            ) mem_inst (
                .clock (clk),
                .data (key_write_data),
                .address (op_in[{key_addr_len}-1:0]),
                .wren (key_wren),
                .q (key_data)
            );
            for (j = 0; j < ROW; j=j+1) begin
                for (k = 0; k < BANK; k=k+1) begin
                    assign key_data_w[j][k] = (j < {o_width}) ? key_data[(j+k*{o_width})*GF_BIT+:GF_BIT] : 0; // load from
                end
                assign key_write_data[j*GF_BIT+:GF_BIT] = r_w[j][0];                        // write to
            end
        end else begin
            for (j = 0; j < ROW; j=j+1) begin
                for (k = 0; k < BANK; k=k+1) begin
                    assign key_data_w[j][k] = 0; // load from
                end
            end
        end
    endgenerate

    // always@(posedge clk) begin
    //     if ((op_in[OP_SIZE-1:OP_SIZE-4] == 7)) begin
    //         $display("_____________________________________________");
    //         $display("| {r_idx}_{c_idx}, {r_num}, {c_num}");
    //         $display("| dataA_in: %x,  dataB_in: %x, addr: %d, key_data: %x, key_write_data: %x, key_wren: %d", dataA_in, dataB_in, op_in[{key_addr_len}-1:0], key_data, key_write_data, key_wren);
    //         $display("|____________________________________________");
    //     end
    // end
        """.format(r_idx=r_idx, c_idx=c_idx, r_num=r_num, c_num=c_num, GF_bit=GF_bit,
            op_functionA_bit=op_functionA_bit, op_size=op_size, key_addr_len=key_addr_len,
            matrix_sz=matrix_sz, tile_r_idx=r_idx, tile_c_idx=c_idx, 
            num_proc_col=O_, bram_type=bram_type, op_code_len=op_code_len, o_width=o_width, bank=bank)
        
        processor_AB_num = 0

        for i in range(r_num):
            for j in range(c_num):
                current_row = sum(row_layout[:r_idx]) + i
                current_col = sum(col_layout[:c_idx]) + j
                verilog_module += """
    // compute_unit({current_row}, {current_col}), (tile({r_tile}, {c_tile}), unit({r_idx}, {c_idx}))
                """.format(current_row=current_row, current_col=current_col, 
                           r_tile=r_idx, c_tile=c_idx, r_idx=i, c_idx=j)
                if i == 0:
                    verilog_module += """
    assign dataA_in_w[{r_idx}][{c_idx}] = dataA_in[GF_BIT*{c_idx}+(GF_BIT-1):GF_BIT*{c_idx}];
                    """.format(r_idx=i, c_idx=j)
                else:
                    verilog_module += """
    assign dataA_in_w[{r_idx}][{c_idx}] = dataA_out_w[{r_idx}-1][{c_idx}];
                    """.format(r_idx=i, c_idx=j)
                if i == 0:
                    verilog_module += """
    assign data_in_w[{r_idx}][{c_idx}] = data_in[GF_BIT*{c_idx}+(GF_BIT-1):GF_BIT*{c_idx}];
                    """.format(r_idx=i, c_idx=j)
                else:
                    verilog_module += """
    assign data_in_w[{r_idx}][{c_idx}] = data_out_w[{r_idx}-1][{c_idx}];
                    """.format(r_idx=i, c_idx=j)
                if j == 0:
                    verilog_module += """
    assign op_in_w[{r_idx}][{c_idx}] = gauss_op_in[2*{r_idx}+1:2*{r_idx}];
    assign inst_op_in_w[{r_idx}][{c_idx}] = op_in[OP_SIZE-1:OP_SIZE-{op_code_len}];
    assign dataB_in_w[{r_idx}][{c_idx}] = dataB_in[GF_BIT*{r_idx}+(GF_BIT-1):GF_BIT*{r_idx}];
                    """.format(r_idx=i, c_idx=j, op_code_len=op_code_len)
                else: 
                    verilog_module += """
    assign op_in_w[{r_idx}][{c_idx}] = op_out_w[{r_idx}][{c_idx}-1];
    assign inst_op_in_w[{r_idx}][{c_idx}] = inst_op_out_w[{r_idx}][{c_idx}-1];
    assign dataB_in_w[{r_idx}][{c_idx}] = dataB_out_w[{r_idx}][{c_idx}-1];
                    """.format(r_idx=i, c_idx=j)
                if i == 0 and j ==0:
                    verilog_module += """
    assign start_in_w[{r_idx}][{c_idx}] = start_in;
    assign finish_in_w[{r_idx}] = finish_in;
                    """.format(r_idx=i, c_idx=j)
                elif j == 0:
                    verilog_module += """
    assign start_in_w[{r_idx}][{c_idx}] = start_row[{r_idx}];
    assign finish_in_w[{r_idx}] = finish_row[{r_idx}];
                    """.format(r_idx=i, c_idx=j)
                else:
                    verilog_module += """
    assign start_in_w[{r_idx}][{c_idx}] = start_out_w[{r_idx}][{c_idx}-1];
                    """.format(r_idx=i, c_idx=j)
                if j == 0:
                    if i == 1:
                        verilog_module += """
    always @(posedge clk) begin
        start_tmp[{r_idx}] <= start_in;
        start_row[{r_idx}] <= start_tmp[{r_idx}];
        finish_tmp[{r_idx}] <= finish_in;
        finish_row[{r_idx}] <= finish_tmp[{r_idx}];
    end
                        """.format(r_idx=i, c_idx=j, op_start_bit=op_start_bit, op_finish_bit=op_finish_bit)
                    elif i > 1:
                        verilog_module += """
    always @(posedge clk) begin
        start_tmp[{r_idx}] <= start_row[{r_idx}-1];
        start_row[{r_idx}] <= start_tmp[{r_idx}];
        finish_tmp[{r_idx}] <= finish_row[{r_idx}-1];
        finish_row[{r_idx}] <= finish_tmp[{r_idx}];
    end
                        """.format(r_idx=i, c_idx=j)
                if (current_col == current_row):
                    processor_AB_num += 1
                    ab_type = "AB"
                    op_code_len_proc = 3
                    if c_idx == 0 and j == 0:
                        ab_type = "ABCD"
                        op_code_len_proc = 4
                    elif c_idx < O_ and j == 0:
                        ab_type = "ABC"
                    verilog_module += """
    processor_{ab_type} #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN({op_code_len})
    ) AB_proc_{r_idx}_{c_idx} (
        .clk(clk),
        .start_in(start_in_w[{r_idx}][{c_idx}]),
        .start_out(start_out_w[{r_idx}][{c_idx}]),
        .finish_in(finish_in_w[{r_idx}]),
        .finish_out(finish_out_w[{r_idx}]),
        .key_data(key_data_w[{r_idx}][{c_idx}]),
        .op_in(inst_op_in_w[{r_idx}][{c_idx}]),
        .op_out(inst_op_out_w[{r_idx}][{c_idx}]),
        .gauss_op_in(op_in_w[{r_idx}][{c_idx}]),
        .gauss_op_out(op_out_w[{r_idx}][{c_idx}]),
        .data_in(data_in_w[{r_idx}][{c_idx}]),
        .data_out(data_out_w[{r_idx}][{c_idx}]),
        .dataB_in(dataB_in_w[{r_idx}][{c_idx}]),
        .dataB_out(dataB_out_w[{r_idx}][{c_idx}]),
        .dataA_in(dataA_in_w[{r_idx}][{c_idx}]),
        .dataA_out(dataA_out_w[{r_idx}][{c_idx}]),
        .r(r_w[{r_idx}][{c_idx}]),
        .functionA(functionA_dup)
    );
                    """.format(r_idx=i, c_idx=j, op_code_len=op_code_len_proc, ab_type=ab_type)
                else:
                    b_type = "B"
                    op_code_len_proc = 3
                    if c_idx == 0 and j == 0:
                        b_type = "BCD"
                        op_code_len_proc = 4
                    elif c_idx < O_ and j == 0:
                        b_type = "BC"
                    verilog_module += """
    processor_{b_type} #(
        .GF_BIT(GF_BIT),
        .OP_CODE_LEN({op_code_len})
    ) B_proc_{r_idx}_{c_idx} (
        .clk(clk),
        .start_in(start_in_w[{r_idx}][{c_idx}]),
        .start_out(start_out_w[{r_idx}][{c_idx}]),
        .key_data(key_data_w[{r_idx}][{c_idx}]),
        .op_in(inst_op_in_w[{r_idx}][{c_idx}]),
        .op_out(inst_op_out_w[{r_idx}][{c_idx}]),
        .gauss_op_in(op_in_w[{r_idx}][{c_idx}]),
        .gauss_op_out(op_out_w[{r_idx}][{c_idx}]),
        .data_in(data_in_w[{r_idx}][{c_idx}]),
        .data_out(data_out_w[{r_idx}][{c_idx}]),
        .dataB_in(dataB_in_w[{r_idx}][{c_idx}]),
        .dataB_out(dataB_out_w[{r_idx}][{c_idx}]),
        .dataA_in(dataA_in_w[{r_idx}][{c_idx}]),
        .dataA_out(dataA_out_w[{r_idx}][{c_idx}]),
        .r(r_w[{r_idx}][{c_idx}])
    );
                    """.format(r_idx=i, c_idx=j, op_code_len=op_code_len_proc, b_type=b_type)
        
        verilog_module += """
    generate
        for (i = 0; i < COL; i=i+1) begin
            for (j = 0; j < GF_BIT; j=j+1) begin
                assign data_out[i*GF_BIT+j] = data_out_w[ROW-1][i][j];
            end
        end
    endgenerate
        
    generate
        for (i = 0; i < ROW; i=i+1) begin
            assign gauss_op_out[2*i+1:2*i] = op_out_w[i][COL-1];
            assign dataB_out[GF_BIT*i+(GF_BIT-1):GF_BIT*i] = dataB_out_w[i][COL-1];
        end
    endgenerate
        """
        
        if processor_AB_num > 0:
            verilog_module += """
    wire [{processor_AB_num}-1:0] is_one;
            """.format(processor_AB_num=processor_AB_num)
            
            idx = 0
            for i in range(r_num):
                for j in range(c_num):
                    current_row = sum(row_layout[:r_idx]) + i
                    current_col = sum(col_layout[:c_idx]) + j
                    if current_row == current_col:
                        verilog_module += """
                        assign is_one[{idx}] = (r_w[{r_idx}][{c_idx}] == 1); // current_row = {current_row}, current_col = {current_col}
                        """.format(r_idx=i, c_idx=j, current_row=current_row, current_col=current_col, idx=idx)
                        idx += 1
                
            verilog_module += """
    assign r_A_and = &is_one;
            """
        else:
            verilog_module += """
    assign r_A_and = 1;
            """

        verilog_module += """
    reg start_out_tmp;
    reg finish_out_tmp;
    always @(posedge clk) begin
        start_out_tmp  <= start_row[ROW-1];
        finish_out_tmp <= finish_row[ROW-1];
        start_out      <= start_out_tmp;
        finish_out     <= finish_out_tmp;
    end

endmodule
        """.format(r_idx=r_idx, c_idx=c_idx)
        
required_cycles = math.ceil(matrix_sz*matrix_sz*GF_bit/128)

verilog_module += """
module matrix_processor#(
    parameter N = {matrix_sz},
    parameter GF_BIT = {GF_bit},
    parameter OP_SIZE = {op_size}
)(
    input wire                                  clk,
    input wire                                  rst_n,
    input wire                    [OP_SIZE-1:0] op_in,
    input wire                        [2*N-1:0] gauss_op_in,
    input wire                   [GF_BIT*N-1:0] dataA_in,
    input wire                   [GF_BIT*N-1:0] dataB_in,
    output reg                   [GF_BIT*N-1:0] data_out,
    output reg                   [GF_BIT*N-1:0] dataB_out,
    output reg                        [2*N-1:0] gauss_op_out,
    output reg                                  r_A_and
);
""".format(matrix_sz=matrix_sz, GF_bit=GF_bit, op_size=op_size, cycle=required_cycles)


# buffer (deal in reverse order)
row_buffer = matrix_sz
for r_idx, r_num in enumerate(row_layout[::-1]):
    verilog_module += """
    // tile_row: {r_idx}
    reg [OP_SIZE-1:0] op_buffer_{r_idx};
    reg [GF_BIT*N-1:0] dataA_buffer_{r_idx};
    reg [GF_BIT*{row_buffer}-1:0] dataB_buffer_{r_idx};
    reg [2*{row_buffer}-1:0] gauss_op_buffer_{r_idx};
    
    wire        [OP_SIZE-1:0] op_buffer_{r_idx}_0_r;
    wire [GF_BIT*N-1:0] dataA_buffer_{r_idx}_0_r;
    wire [GF_BIT*{r_num}-1:0] dataB_buffer_{r_idx}_0_r;
    wire [2*{r_num}-1:0] gauss_op_buffer_{r_idx}_0_r;
    
    buffering#(
        .SIZE(OP_SIZE),
        .DELAY({delay})
    ) op_buffer_{r_idx}_0 (clk, op_buffer_{r_idx}, op_buffer_{r_idx}_0_r);

    buffering#(
        .SIZE(GF_BIT*N),
        .DELAY({delay})
    ) dataA_buffer_{r_idx}_0 (clk, dataA_buffer_{r_idx}, dataA_buffer_{r_idx}_0_r);

    buffering#(
        .SIZE(GF_BIT*{r_num}),
        .DELAY({delay})
    ) dataB_buffer_{r_idx}_0 (clk, dataB_buffer_{r_idx}[GF_BIT*{row_buffer}-1:GF_BIT*({row_buffer}-{r_num})], dataB_buffer_{r_idx}_0_r);

    buffering#(
        .SIZE(2*{r_num}),
        .DELAY({delay})
    ) gauss_op_buffer_{r_idx}_0 (clk, gauss_op_buffer_{r_idx}[2*{row_buffer}-1:2*({row_buffer}-{r_num})], gauss_op_buffer_{r_idx}_0_r);
    """.format(r_idx=len(row_layout)-1-r_idx, row_buffer=row_buffer, 
               delay=len(row_layout)-1-r_idx, r_num=r_num)
    row_buffer -= r_num
verilog_module += """
    always @(posedge clk) begin
        op_buffer_{r_num}       <= op_in;
        dataA_buffer_{r_num}    <= dataA_in;
        dataB_buffer_{r_num}    <= dataB_in;
        gauss_op_buffer_{r_num} <= gauss_op_in;
    end
""".format(r_num=len(row_layout)-1)

row_buffer = matrix_sz
for r_idx, r_num in enumerate(row_layout[::-1]):
    if r_idx == len(row_layout)-1: # reverse order, so row N-1 skip (done above)
        continue
    row_buffer -= r_num
    verilog_module += """
    always @(posedge clk) begin
        op_buffer_{r_idx}       <= op_buffer_{r_idx2};
        dataA_buffer_{r_idx}    <= dataA_buffer_{r_idx2};
        dataB_buffer_{r_idx}    <= dataB_buffer_{r_idx2}[GF_BIT*{row_buffer}-1:0];
        gauss_op_buffer_{r_idx} <= gauss_op_buffer_{r_idx2}[2*{row_buffer}-1:0];
    end
    
    """.format(r_idx=len(row_layout)-2-r_idx, r_idx2=len(row_layout)-1-r_idx, row_buffer=row_buffer)

# Deal with right delay (data, data_out)
current_idx = 0
last_col_num = 0
last_col_idx = 0
col_buffer = matrix_sz
for c_idx, c_num in enumerate(right_delay_layout):
    for r_idx, r_num in enumerate(row_layout):  
        col_buffer_tmp = 0
        verilog_module += """
    wire [{c_num}-1:0] r_A_and_{r_idx}_{c_idx}_w;
    reg r_A_and_{r_idx}_{c_idx}_r;
    always @(posedge clk) begin
        r_A_and_{r_idx}_{c_idx}_r <= &r_A_and_{r_idx}_{c_idx}_w;
    end
        """.format(r_idx=r_idx, c_idx=c_idx, c_num=len(c_num))

        if c_idx > 0: # pass dataB and gauss_op to next tile
            verilog_module += """
    reg [OP_SIZE-1:0]      op_buffer_{r_idx}_{c_idx}_r;
    reg [GF_BIT*{col_buffer}-1:0] dataA_buffer_{r_idx}_{c_idx}_r;
    reg [GF_BIT*{r_num}-1:0] dataB_buffer_{r_idx}_{c_idx}_r;
    reg      [2*{r_num}-1:0] gauss_op_buffer_{r_idx}_{c_idx}_r;
    always @(posedge clk) begin
        op_buffer_{r_idx}_{c_idx}_r    <= op_buffer_{r_idx}_{c_idx2}_r;
        dataA_buffer_{r_idx}_{c_idx}_r <= dataA_buffer_{r_idx}_{c_idx2}_r[({col_buffer}+{last_col_num})*GF_BIT-1:{last_col_num}*GF_BIT];
        dataB_buffer_{r_idx}_{c_idx}_r <= dataB_out_{r_idx}_{last_col_idx}_w;
        gauss_op_buffer_{r_idx}_{c_idx}_r <= gauss_op_out_{r_idx}_{last_col_idx}_w;
    end
            """.format(r_idx=r_idx, c_idx=c_idx, c_idx2=c_idx-1, last_col_idx=current_idx-1, c_num=len(c_num), r_num=r_num,
                last_col_num=last_col_num, col_buffer=col_buffer)
        for cc_idx, cc_num in enumerate(c_num):
            if r_idx == 0:
                which_data_in   = "dataA_buffer_{r_idx}_{c_idx}_w".format(r_idx=r_idx, c_idx=current_idx+cc_idx)
                which_start_in  = "op_buffer_{r_idx}_{c_idx}_w[{op_start_bit}]".format(r_idx=r_idx, c_idx=current_idx+cc_idx, op_start_bit=op_start_bit) 
                which_finish_in = "op_buffer_{r_idx}_{c_idx}_w[{op_finish_bit}]".format(r_idx=r_idx, c_idx=current_idx+cc_idx, op_finish_bit=op_finish_bit) 
            else:
                which_data_in   = "data_out_{r_idx}_{c_idx}_w".format(r_idx=r_idx-1, c_idx=current_idx+cc_idx)
                which_start_in  = "start_out_{r_idx}_{c_idx}_w".format(r_idx=r_idx-1, c_idx=current_idx+cc_idx) 
                which_finish_in = "finish_out_{r_idx}_{c_idx}_w".format(r_idx=r_idx-1, c_idx=current_idx+cc_idx) 
            if cc_idx == 0:
                which_dataB_in    = "dataB_buffer_{r_idx}_{c_idx}_r".format(r_idx=r_idx, c_idx=c_idx)
                which_gauss_op_in = "gauss_op_buffer_{r_idx}_{c_idx}_r".format(r_idx=r_idx, c_idx=c_idx)
            else:
                which_dataB_in    = "dataB_out_{r_idx}_{c_idx}_w".format(r_idx=r_idx, c_idx=current_idx+cc_idx-1)
                which_gauss_op_in = "gauss_op_out_{r_idx}_{c_idx}_w".format(r_idx=r_idx, c_idx=current_idx+cc_idx-1)
            tmp_str = """
    wire         [OP_SIZE-1:0] op_buffer_{r_idx}_{c_idx}_w = op_buffer_{r_idx}_{c_idx2}_r;
    wire [GF_BIT*{cc_num}-1:0] dataA_buffer_{r_idx}_{c_idx}_w = dataA_buffer_{r_idx}_{c_idx2}_r[({col_buffer_tmp}+{cc_num})*GF_BIT-1:{col_buffer_tmp}*GF_BIT];
    
    wire      [2*{r_num}-1:0]  gauss_op_out_{r_idx}_{c_idx}_w;
    wire  [GF_BIT*{r_num}-1:0] dataB_out_{r_idx}_{c_idx}_w;
    wire [GF_BIT*{cc_num}-1:0] data_out_{r_idx}_{c_idx}_w;
    wire                       start_out_{r_idx}_{c_idx}_w;
    wire                       finish_out_{r_idx}_{c_idx}_w;
    tile_{r_idx}_{c_idx}#(
        .N(N),
        .GF_BIT(GF_BIT),
        .OP_SIZE(OP_SIZE),
        .ROW({r_num}),
        .COL({cc_num})
    ) p_{r_idx}_{c_idx} (
        .clk(clk),
        .rst_n(rst_n),
        .op_in(op_buffer_{r_idx}_{c_idx}_w),
        .dataA_in(dataA_buffer_{r_idx}_{c_idx}_w),
        .gauss_op_in("""+which_gauss_op_in+"""),
        .dataB_in("""+which_dataB_in+"""),
        .data_in("""+which_data_in+"""),
        .start_in("""+which_start_in+"""),
        .finish_in("""+which_finish_in+"""),
        .gauss_op_out(gauss_op_out_{r_idx}_{c_idx}_w),
        .dataB_out(dataB_out_{r_idx}_{c_idx}_w),
        .data_out(data_out_{r_idx}_{c_idx}_w),
        .start_out(start_out_{r_idx}_{c_idx}_w),
        .finish_out(finish_out_{r_idx}_{c_idx}_w),
        .r_A_and(r_A_and_{r_idx}_{c_idx2}_w[{cc_idx}])
    );
            """
            verilog_module += tmp_str.format(r_idx=r_idx, c_idx=current_idx+cc_idx, c_idx2=c_idx,
                cc_num=cc_num, col_buffer_tmp=col_buffer_tmp, r_num=r_num, cc_idx=cc_idx)
            last_col_idx = current_idx+cc_idx
            col_buffer_tmp += cc_num
    current_idx += len(c_num)
    col_buffer -= sum(c_num)
    last_col_num = sum(c_num)

# deal with r_A
for r_idx, r_num in enumerate(row_layout):  
    for c_idx, c_num in enumerate(right_delay_layout):
        verilog_module += """
    wire r_A_and_{r_idx}_{c_idx}_tmp;
    buffering#(
        .SIZE(1),
        .DELAY({delay})
    ) r_A_and_{r_idx}_{c_idx}_r_inst (clk, r_A_and_{r_idx}_{c_idx}_r, r_A_and_{r_idx}_{c_idx}_tmp);
        """.format(r_idx=r_idx, c_idx=c_idx, delay=r_idx)
        if (r_idx == 0):
            verilog_module += """
    wire r_A_and_{r_idx}_{c_idx}_tmp2 = r_A_and_{r_idx}_{c_idx}_tmp;
            """.format(r_idx=r_idx, c_idx=c_idx)
            continue
        verilog_module += """
    reg r_A_and_{r_idx}_{c_idx}_tmp2;
    always @(posedge clk) begin
        r_A_and_{r_idx}_{c_idx}_tmp2 <= r_A_and_{last_r_idx}_{c_idx}_tmp2 & r_A_and_{r_idx}_{c_idx}_tmp;
    end
        """.format(r_idx=r_idx, c_idx=c_idx, last_r_idx=r_idx-1)
            

# deal with data out buffer
col_buffer = matrix_sz
current_idx = 0
for c_idx, c_num in enumerate(right_delay_layout):
    verilog_module += """
    wire [GF_BIT*{c_num}-1:0] data_out_buffer_{c_idx}_w;
    wire [GF_BIT*{c_num}-1:0] data_out_buffer_{c_idx}_r;
    buffering#(
        .SIZE(GF_BIT*{c_num}),
        .DELAY({delay})
    ) data_out_{c_idx}_inst (clk, data_out_buffer_{c_idx}_w, data_out_buffer_{c_idx}_r);
    
    wire r_A_and_{row_num}_{c_idx}_tmp2_r;
    buffering#(
        .SIZE(1),
        .DELAY({delay})
    ) r_A_and_{row_num}_{c_idx}_inst (clk, r_A_and_{row_num}_{c_idx}_tmp2, r_A_and_{row_num}_{c_idx}_tmp2_r);
    """.format(c_idx=c_idx, col_buffer=col_buffer, c_num=sum(c_num), 
    	delay=2*(len(right_delay_layout)-1-(c_idx)), row_num=len(row_layout)-1)
    col_buffer_tmp = 0
    for cc_idx, cc_num in enumerate(c_num):
        verilog_module += """
    assign data_out_buffer_{c_idx}_w[({col_buffer_tmp}+{cc_num})*GF_BIT-1:{col_buffer_tmp}*GF_BIT] = data_out_{r_idx}_{cc_idx}_w;
        """.format(c_idx=c_idx, cc_idx=current_idx+cc_idx, cc_num=cc_num, col_buffer_tmp=col_buffer_tmp, r_idx=len(row_layout)-1)
        col_buffer_tmp += cc_num
    current_idx += len(c_num)

last_col_num = 0
for c_idx, c_num in enumerate(right_delay_layout[::-1]): # reverse order
    if c_idx == 0:
        verilog_module += """
    wire [GF_BIT*{c_num}-1:0] combined_data_out_{c_idx} = data_out_buffer_{c_idx}_r;
    wire combined_r_A_and_{c_idx} = r_A_and_{row_num}_{c_idx}_tmp2_r;
        """.format(c_idx=len(right_delay_layout)-1-c_idx, GF_bit=GF_bit, c_num=sum(c_num), row_num=len(row_layout)-1)
        last_col_num = sum(c_num)
        continue
    verilog_module += """
    wire [GF_BIT*{c_num}-1:0] combined_data_out_{c_idx};
    reg [GF_BIT*{last_col_num}-1:0] buffer_last_data_out_{c_idx};
    always @(posedge clk) begin
        buffer_last_data_out_{c_idx} <= combined_data_out_{last_c_idx};
    end
    assign combined_data_out_{c_idx} = {{buffer_last_data_out_{c_idx}, data_out_buffer_{c_idx}_r}};
    
    reg combined_r_A_and_{c_idx};
    always @(posedge clk) begin
        combined_r_A_and_{c_idx} <= r_A_and_{row_num}_{c_idx}_tmp2_r & combined_r_A_and_{last_c_idx};
    end
    """.format(c_idx=len(right_delay_layout)-1-c_idx, last_c_idx=len(right_delay_layout)-c_idx, 
        c_num=sum(c_num)+last_col_num, last_col_num=last_col_num, row_num=len(row_layout)-1)
    last_col_num = sum(c_num)+last_col_num

# deal with dataB_out and op_gauss_out
for r_idx, r_num in enumerate(row_layout):
    verilog_module += """
    wire [GF_BIT*{r_num}-1:0] dataB_out_buffer_{r_idx}_r;
    buffering#(
        .SIZE(GF_BIT*{r_num}),
        .DELAY({delay})
    ) dataB_out_buffer_{r_idx}_inst (clk, dataB_out_{r_idx}_{c_idx}_w, dataB_out_buffer_{r_idx}_r);

    wire [2*{r_num}-1:0] gauss_op_out_buffer_{r_idx}_r;
    buffering#(
        .SIZE(2*{r_num}),
        .DELAY({delay})
    ) gauss_op_out_buffer_{r_idx}_inst (clk, gauss_op_out_{r_idx}_{c_idx}_w, gauss_op_out_buffer_{r_idx}_r);
    """.format(r_num=r_num, r_idx=r_idx, delay=r_idx+1, c_idx=len(col_layout)-1)
last_row_num = 0
for r_idx, r_num in enumerate(row_layout):
    if r_idx == 0:
        verilog_module += """
    wire [GF_BIT*{r_num}-1:0] combined_dataB_out_{r_idx} = dataB_out_buffer_{r_idx}_r;
    wire [2*{r_num}-1:0] combined_gauss_op_out_{r_idx} = gauss_op_out_buffer_{r_idx}_r;
        """.format(r_idx=r_idx, r_num=r_num)
        last_row_num = r_num
        continue
    verilog_module += """
    wire [GF_BIT*{r_num}-1:0] combined_dataB_out_{r_idx};
    reg [GF_BIT*{last_row_num}-1:0] buffer_last_dataB_out_{r_idx};
    always @(posedge clk) begin
        buffer_last_dataB_out_{r_idx} <= combined_dataB_out_{last_r_idx};
    end
    assign combined_dataB_out_{r_idx} = {{dataB_out_buffer_{r_idx}_r, buffer_last_dataB_out_{r_idx}}};

    wire [2*{r_num}-1:0] combined_gauss_op_out_{r_idx};
    reg [2*{last_row_num}-1:0] buffer_last_gauss_op_out_{r_idx};
    always @(posedge clk) begin
        buffer_last_gauss_op_out_{r_idx} <= combined_gauss_op_out_{last_r_idx};
    end
    assign combined_gauss_op_out_{r_idx} = {{gauss_op_out_buffer_{r_idx}_r, buffer_last_gauss_op_out_{r_idx}}};
    """.format(r_idx=r_idx, r_num=r_num+last_row_num, last_row_num=last_row_num, last_r_idx=r_idx-1)
    last_row_num = r_num+last_row_num
verilog_module += """
    wire [GF_BIT*N-1:0] dataB_final_buffer_r;
    buffering#(
        .SIZE(GF_BIT*N),
        .DELAY({delay})
    ) dataB_final_buffer_inst (clk, combined_dataB_out_{r_idx}, dataB_final_buffer_r);

    wire [2*N-1:0] gauss_op_final_buffer_r;
    buffering#(
        .SIZE(2*N),
        .DELAY({delay})
    ) gauss_op_final_buffer_inst (clk, combined_gauss_op_out_{r_idx}, gauss_op_final_buffer_r);
""".format(delay=len(right_delay_layout)-1, r_idx=len(row_layout)-1)


verilog_module += """
    always @(posedge clk) begin
        data_out     <= combined_data_out_0;
        r_A_and      <= combined_r_A_and_0;
        dataB_out    <= dataB_final_buffer_r;
        gauss_op_out <= gauss_op_final_buffer_r;
    end

endmodule
"""

### write out verilog file
with open("./rtl_v2/matrix.v", "w") as sources:
    sources.write(verilog_module)

### modify delay information
with open("./rtl_v2/uov.v", "r") as sources:
    lines = sources.readlines()
with open("./rtl_v2/uov.v", "w") as sources:
    for line in lines:
        line = re.sub(r"localparam BANK = .*",
                       "localparam BANK = " + str(bank) + ";", line)
        line = re.sub(r"localparam P1_depth = .*",
                       "localparam P1_depth = " + str(math.ceil(V*(V+1)//2/bank)) + ";", line)
        line = re.sub(r"localparam P2_depth = .*",
                       "localparam P2_depth = " + str(math.ceil(O*V/bank)) + ";", line)
        line = re.sub(r"localparam P3_depth = .*",
                       "localparam P3_depth = " + str(math.ceil(O*(O+1)//2/bank)) + ";", line)
        line = re.sub(r"localparam V_BANK = .*",
                       "localparam V_BANK = " + str(math.ceil(V/bank)) + ";", line)
        line = re.sub(r"RIGHT_DELAY = .*",
                       "RIGHT_DELAY = " + str(len(right_delay_layout)-1) + ";", line)
        line = re.sub(r"UP_DELAY = .*",
                       "UP_DELAY = " + str(len(row_layout)-1) + ";", line)
        line = re.sub(r"KEY_BRAM_SIZE = .*",
                       "KEY_BRAM_SIZE = " + str(key_depth) + ";", line)
        line = re.sub(r"reg .* key_addr_r;",
                       "reg ["+str(key_addr_len-1)+":0] key_addr_r;", line)
        line = re.sub(r"reg .* op_insts_r;",
                       "reg ["+str(op_code_len-1)+":0] op_insts_r;", line)
        line = re.sub(r"assign .* = key_addr_r;",
                       "assign operations["+str(key_addr_len-1)+":0] = key_addr_r;", line)
        line = re.sub(r"assign .* = key_en_r;",
                       "assign operations["+str(key_addr_len)+"] = key_en_r;", line)
        line = re.sub(r"assign .* SA_start_r;",
                       "assign operations["+str(op_start_bit)+"] = SA_start_r;", line)
        line = re.sub(r"assign .* SA_finish_r;",
                       "assign operations["+str(op_finish_bit)+"] = SA_finish_r;", line)
        line = re.sub(r"assign .* functionA_r;",
                       "assign operations["+str(op_functionA_bit)+"] = functionA_r;", line)
        line = re.sub(r"assign .* = op_insts_r;",
                       "assign operations["+str(op_insts+op_code_len-1)+":"+str(op_insts)+"] = op_insts_r;", line)
        line = re.sub(r"localparam RAND_STATE_NUM .* // rand_state_num", 
                       "localparam RAND_STATE_NUM = " + str(rand_state_num) + "; // rand_state_num", line)
        sources.write(line)

address_translation_str = "        // address translation start\n"
for i in range(bank):
    if i == 0:
        address_translation_str += """        if ((translation_idx < translation_depth*("""+str(i)+"""+1)) && (translation_depth*"""+str(i)+""" <= translation_idx)) begin
            translated_idx  = translation_idx-translation_depth*"""+str(i)+""";
            translated_bank = """+str(i)+""";
        end\n"""
    else:
        address_translation_str += """        else if ((translation_idx < translation_depth*("""+str(i)+"""+1)) && (translation_depth*"""+str(i)+""" <= translation_idx)) begin
            translated_idx  = translation_idx-translation_depth*"""+str(i)+""";
            translated_bank = """+str(i)+""";
        end\n"""
address_translation_str += "        // address translation end\n"

eval_setting_str = "    // eval setting start\n"
for i in range(bank):
    P1_depth = math.ceil(V*(V+1)//2/bank)
    P1_start = P1_depth*i
    P1_end   = P1_depth*(i+1)-1
    P1_r_start = 0 
    P1_c_start = 0
    P1_r_end = V-1 
    P1_c_end = V-1
    for r in range(V):
        for c in range(r, V):
            idx = ((V+V-(r-1))*r)//2 + (c-r)
            if idx == P1_start:
                P1_r_start = r
                P1_c_start = c
            if idx == P1_end:
                P1_r_end = r
                P1_c_end = c
    P2_depth = math.ceil(V*O/bank)
    P2_start = P2_depth*i
    P2_end   = P2_depth*(i+1)-1
    P2_r_start = 0 
    P2_c_start = 0
    P2_r_end = V-1 
    P2_c_end = O-1
    for r in range(V):
        for c in range(O):
            idx = r*O + c
            if idx == P2_start:
                P2_r_start = r
                P2_c_start = c
            if idx == P2_end:
                P2_r_end = r
                P2_c_end = c
    P3_depth = math.ceil(O*(O+1)//2/bank)
    P3_start = P3_depth*i
    P3_end   = P3_depth*(i+1)-1
    P3_r_start = 0 
    P3_c_start = 0
    P3_r_end = O-1 
    P3_c_end = O-1
    for r in range(O):
        for c in range(r, O):
            idx = ((O+O-(r-1))*r)//2 + (c-r)
            if idx == P3_start:
                P3_r_start = r
                P3_c_start = c
            if idx == P3_end:
                P3_r_end = r
                P3_c_end = c

    eval_setting_str += """    assign eval_start_row["""+str(i)+"""] = (data_addr1 == Q1) ? """+str(P1_r_start)+""" :
                               (data_addr1 == Q2) ? """+str(P2_r_start)+""" : """+str(P3_r_start)+""";
    assign eval_end_row["""+str(i)+"""]   = (data_addr1 == Q1) ? """+str(P1_r_end)+""" :
                               (data_addr1 == Q2) ? """+str(P2_r_end)+""" : """+str(P3_r_end)+""";
    assign eval_start_col["""+str(i)+"""] = (data_addr1 == Q1) ? """+str(P1_c_start)+""" :
                               (data_addr1 == Q2) ? """+str(P2_c_start)+""" : """+str(P3_c_start)+""";
    assign eval_end_col["""+str(i)+"""]   = (data_addr1 == Q1) ? """+str(P1_c_end)+""" :
                               (data_addr1 == Q2) ? """+str(P2_c_end)+""" : """+str(P3_c_end)+""";\n"""
eval_setting_str += "    // eval setting end\n"

calc_setting_str = "    // calc setting start\n"
for i in range(bank):
    L_depth = math.ceil(V/bank)
    L_start = L_depth*i
    L_end   = L_depth*(i+1)-1
    if L_end >= V:
        L_end = V-1
    calc_setting_str += """    assign calc_start_row["""+str(i)+"""] = """+str(L_start)+""";
    assign calc_end_row["""+str(i)+"""]   = """+str(L_end)+""";\n"""
calc_setting_str += "    // calc setting end\n"

line_all = ""
with open("./rtl_v2/uov.v", "r") as sources:
    lines = sources.readlines()
    for line in lines:
        line_all += line

with open("./rtl_v2/uov.v", "w") as sources:
    line_all = re.sub(r"        // address translation start[\s\S]*// address translation end\n", address_translation_str, line_all)
    line_all = re.sub(r"    // eval setting start[\s\S]*// eval setting end\n", eval_setting_str, line_all)
    line_all = re.sub(r"    // calc setting start[\s\S]*// calc setting end\n", calc_setting_str, line_all)
    sources.write(line_all)


# Configure define.v
define_str = "// defines start\n"
if use_inversion:
    define_str += "`define USE_INVERSION\n"
if use_tower_field:
    define_str += "`define USE_TOWER_FIELD\n"
if use_pipelined_aes:
    define_str += "`define USE_PIPELINED_AES\n"
define_str += "// defines end\n"

line_all = ""
with open("./rtl_v2/define.v", "r") as sources:
    lines = sources.readlines()
    for line in lines:
        line_all += line

with open("./rtl_v2/define.v", "w") as sources:
    line_all = re.sub(r"// defines start[\s\S]*// defines end\n", define_str, line_all)
    sources.write(line_all)

if os.path.exists("./onboard/interface/uovipcore_v1_0_S00_AXI.v"):
    # modify interface
    with open("./onboard/interface/uovipcore_v1_0_S00_AXI.v", "r") as sources:
        lines = sources.readlines()
    with open("./onboard/interface/uovipcore_v1_0_S00_AXI.v", "w") as sources:
        for line in lines:
            line = re.sub(r"localparam .* // localparam", 
                           "localparam GF_BIT="+str(GF_bit)+", OP_SIZE="+str(op_size)+", V="+str(V)+", O="+str(O)+", N="+str(matrix_sz)+", L="+str(O_*matrix_sz)+", K="+str(2*O_*matrix_sz)+", L_ORI="+str(O)+", V_="+str(V_)+", O_="+str(O_)+", TEST_MODE="+str(test_mode)+", INST_DEPTH="+str(inst_depth)+", INST_LEN="+str(inst_len)+", AES_ROUND="+str(aes_round)+"; // localparam", line)
            sources.write(line)

### modify test path
with open("./scripts/run_synthesis", "r") as sources:
    lines = sources.readlines()
with open("./scripts/run_synthesis", "w") as sources:
    for line in lines:
        line = re.sub(r"^ENV_FOLDER=.*", "ENV_FOLDER=\""+str(sys.argv[1]).replace("/", "_").replace(".", "_")+"\"", line)
        line = re.sub(r"^vivado .*", "vivado -mode batch -source generate_system."+platform+".tcl", line)
        line = re.sub(r"^OP_SIZE=.*", "OP_SIZE="+str(op_size), line)
        line = re.sub(r"^GF_BIT=.*", "GF_BIT="+str(GF_bit), line)
        line = re.sub(r"^N=.*", "N="+str(matrix_sz), line)
        line = re.sub(r"^O=.*", "O="+str(O), line)
        line = re.sub(r"^V=.*", "V="+str(V), line)
        line = re.sub(r"^MODE=.*", "MODE=\""+mode+"\"", line)
        line = re.sub(r"^AES_ROUND=.*", "AES_ROUND="+str(aes_round), line)
        line = re.sub(r"^RTL_PATH=.*", "RTL_PATH=\"rtl_v2\"", line)
        sources.write(line)

package_str = "# package start\n"
if platform == "nexys":
    package_str += "./build_nexys_test\n"
else:
    package_str += "./build_zed_test\n"
package_str += "# package end\n"


line_all = ""
with open("./scripts/run_synthesis", "r") as sources:
    lines = sources.readlines()
    for line in lines:
        line_all += line

with open("./scripts/run_synthesis", "w") as sources:
    line_all = re.sub(r"# package start[\s\S]*# package end\n", package_str, line_all)
    sources.write(line_all)


### modify test parameters
with open("./scripts/run_simulation", "r") as sources:
    lines = sources.readlines()
with open("./scripts/run_simulation", "w") as sources:
    for line in lines:
        line = re.sub(r"^OP_SIZE=.*", "OP_SIZE="+str(op_size), line)
        line = re.sub(r"^GF_BIT=.*", "GF_BIT="+str(GF_bit), line)
        line = re.sub(r"^N=.*", "N="+str(matrix_sz), line)
        line = re.sub(r"^O=.*", "O="+str(O), line)
        line = re.sub(r"^V=.*", "V="+str(V), line)
        line = re.sub(r"^MODE=.*", "MODE=\""+mode+"\"", line)
        line = re.sub(r"^AES_ROUND=.*", "AES_ROUND="+str(aes_round), line)
        line = re.sub(r"^RTL_PATH=.*", "RTL_PATH=\"rtl_v2\"", line)
        sources.write(line)


simulator_arguments = "python simulator_v2/codegen.py -n {matrix_sz} -v {V} -o {O} -g {GF_bit} -m {mode} -r {aes_round}".format(
    matrix_sz=matrix_sz, V=V, O=O, GF_bit=GF_bit, mode=mode, aes_round=aes_round)
if use_inversion:
    simulator_arguments += " --use_inversion"
if use_tower_field:
    simulator_arguments += " --use_tower_field"
if use_pipelined_aes:
    simulator_arguments += " --use_pipelined_aes"
print(simulator_arguments)
subprocess.run(simulator_arguments.split(" "))
