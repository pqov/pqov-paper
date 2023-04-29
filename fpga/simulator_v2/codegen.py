# This code provides the behavior simulation for ov processor.
# It simulates the systolic array and estimates the cycle count for KeyGen, Sign and Verfiy.
# The code will generate test.data, which is a binary instruction sequence for the RTL simulation.

import sys
import math
import numpy as np
import random
import os
import re
from argparse import ArgumentParser
from numba import njit
from numba.core import types
from numba.typed import Dict, List
from gf import mulGF256_aes, invGF256_aes, mulGF16_aes, invGF16_aes, mulGF256_tower, invGF256_tower, mulGF16_tower, invGF16_tower, getMat, getVec, to_int, format_int, format_str, xor
from Crypto.Cipher import AES
from Crypto.Hash import SHAKE256
from pyfinite import ffield

np.set_printoptions(threshold=sys.maxsize)
          
parser = ArgumentParser(description='Example: python codegen.py -n 16 -v 68 -o 44 -g 8 -m classic -r 1 -c v1 [-e]')
parser.add_argument("-n", type=int, help="matrix processor width", required=True)
parser.add_argument("-v", type=int, help="# of vineagar variables", required=True)
parser.add_argument("-o", type=int, help="# of oil variables", required=True)
parser.add_argument("-g", "--GF_bit", type=int, help="can be either 4 or 8, representing GF16 or GF256", required=True)
parser.add_argument("-m", choices=["classic", "pkc", "pkc_skc"], type=str, help="Either classic, pkc, pkc_skc", required=True)
parser.add_argument("-r", type=int, help="round of AES", required=True)
parser.add_argument("--use_inversion", help="Use matrix inversion or not", action='store_true')
parser.add_argument("--use_tower_field", help="Use tower_field or aes_field (default aes)", action='store_true')
parser.add_argument("--use_pipelined_aes", help="Use pipelined aes or not", action='store_true')
parser.add_argument("-e", "--enable_simulation", help="can be either 4 or 8, representing GF16 or GF256", action='store_true')
args = parser.parse_args()

N                 = args.n
V                 = args.v
O                 = args.o
GF_bit            = args.GF_bit
mode              = args.m
aes_round         = args.r
use_inversion     = args.use_inversion
use_tower_field   = args.use_tower_field
use_pipelined_aes = args.use_pipelined_aes
enable            = args.enable_simulation
assert(N == 16 or N == 32)
assert(N < O and N < V)
assert(N*GF_bit == 128)
assert(aes_round > 0)
right_delay = 2
up_delay    = 2
V_ = math.ceil(V/N)
O_ = math.ceil(O/N)
v_mod_n = (V % N)
o_mod_n = (O % N)
bank = math.floor(N/O_)

rand_state_num = 4
assert(math.lcm(1088, V*GF_bit) % (V*GF_bit) == 0)
assert(math.lcm(1088, V*GF_bit) % (1088) == 0)
assert(N % (math.gcd(V*math.lcm(1088, V*GF_bit) // (V*GF_bit), N)) == 0)
sk_squeeze_time = math.ceil((GF_bit*V*O) / 1088)
sk_cnt          = sk_squeeze_time * (1088 // 64)

# Instruction bit fields
inst_depth    = 10
op_len        = 6
reg_len       = 4
imm_len       = 18
data_addr_len = 3
inst_len = reg_len*2+imm_len+op_len


# matrix gen STALL cycles
sk_stall = max(min((24+18)*(sk_squeeze_time), (1<<imm_len)-1), 0)

# matrix gen STALL cycles
if O == 64:
    if aes_round == 4:
        P1_stall = (aes_round+4)*(O*rand_state_num//N)
    else:
        P1_stall = (aes_round+3)*(O*rand_state_num//N)
else:
    P1_stall = (aes_round+2)*(O*rand_state_num//N)
if O == 44:
    P2_stall = (aes_round+2)*(O*rand_state_num//N+1)
elif O == 64:
    if aes_round == 4:
        P2_stall = (aes_round+4)*(O*rand_state_num//N)
    else:
        P2_stall = (aes_round+3)*(O*rand_state_num//N)
else:
    P2_stall = (aes_round+2)*(O*rand_state_num//N)

if O == 44:
    buffer_multiplier = 21
elif O == 72:
    buffer_multiplier = 14
elif O == 96:
    buffer_multiplier = 24
elif O == 64:
    buffer_multiplier = 12

if O == 96:
    buffer_depth = 1024
else:
    buffer_depth = 512

P1_start_ctr = 0
P2_start_ctr = (O*V*(V+1)//2)//N

# Instructions and opcodes
inst = List()
inst_map_ ={"addi"           : "000_000",
            "subi"           : "000_001",
            "bne"            : "000_010",
            "beq"            : "000_011",
            "bgt"            : "000_100",
            
            "stall"          : "001_000",
            "sha_hash_v"     : "001_001",
            "sha_hash_m"     : "001_010",
            "sha_hash_sk"    : "001_011",
            "sha_squeeze_sk" : "001_100",
            "send"           : "001_101",
            "store_o"        : "001_110",
            
            "aes_set_round"  : "010_000",
            "aes_set_ctr"    : "010_001",
            "aes_update_ctr" : "010_010",
            "aes_init_key"   : "010_011",
            "aes_to_tower"   : "010_100",
            "tower_to_aes"   : "010_101",
                      
            "gauss_elim"     : "011_000",
            "mul_l_inv"      : "011_001",
            "mul_o"          : "011_010",
            "load_keys"      : "011_011",
            "store_keys"     : "011_100",

            "unload_check"   : "100_000", 
            "add_to_sig_v"   : "100_001",
            "store_sig_o"    : "100_010",
            "store_l"        : "100_011",
            "unload_add_y"   : "100_100",

            "mul_key_o_pipe" : "101_001",
            "mul_key_o"      : "101_010",
            "eval"           : "101_011",
            "calc_l"         : "101_100",
            "mul_key_sig"    : "101_101",
            
            "finish"         : "111_111"}

inst_map     = Dict()
inv_inst_map = Dict()
for k, v in inst_map_.items():
    inst_map[k] = v
    inv_inst_map[v.replace("_", "")] = k

# Different instruction formats
inst_template = [ # [4-bit rs2][4-bit rs1][18-bit immediate][6-bit opcode]
                  "{:0"+str(reg_len)+"b}_{:0"+str(reg_len)+"b}_{:0"+str(imm_len)+"b}_{:s}",
                  # [8-bit unused][18-bit immediate][6-bit opcode]
                  "0"*(2*reg_len)+"_{:0"+str(imm_len)+"b}_{:s}",
                  # [26-bit unused][6-bit opcode]
                  "0"*(2*reg_len+imm_len)+"_{:s}",
                  # [4-bit unused][4-bit rs1][18-bit unused][6-bit opcode]
                  "0"*(reg_len)+"_{:0"+str(reg_len)+"b}_"+"0"*(imm_len)+"_{:s}",
                  # [4-bit rs2][4-bit rs1][7-bit unused][3-bit data_addr1][8-bit unused][6-bit opcode]
                  "{:0"+str(reg_len)+"b}_{:0"+str(reg_len)+"b}_"+"0"*(imm_len-2*reg_len-data_addr_len)+"_{:0"+str(data_addr_len)+"b}_"+"0"*(2*reg_len)+"_{:s}",
                  # [4-bit rs2][4-bit rs1][4-bit unused][3-bit data_addr2][3-bit data_addr1][4-bit rs2][4-bit rs1][6-bit opcode]
                  "{:0"+str(reg_len)+"b}_{:0"+str(reg_len)+"b}_"+"0"*(imm_len-2*reg_len-2*data_addr_len)+"_{:0"+str(data_addr_len)+"b}_{:0"+str(data_addr_len)+"b}_{:0"+str(reg_len)+"b}_{:0"+str(reg_len)+"b}"+"_{:s}",
                  # [15-bit unused][3-bit data_addr1][8-bit unused][6-bit opcode]
                  "0"*(2*reg_len+(imm_len-2*reg_len-data_addr_len))+"_{:0"+str(data_addr_len)+"b}_"+"0"*(2*reg_len)+"_{:s}",
                  # [4-bit rs2][4-bit rs1][7-bit imm2][3-bit data_addr1][8-bit imm1][6-bit opcode]
                  "{:0"+str(reg_len)+"b}_{:0"+str(reg_len)+"b}_"+"{:0"+str(imm_len-2*reg_len-data_addr_len)+"b}_{:0"+str(data_addr_len)+"b}_"+"{:0"+str(2*reg_len)+"b}_{:s}",
                ]

# Register the instructions into the designated formats
def register_instruction(func_name, which, *args):
    inst.append(inst_template[which].format(*args, inst_map[func_name]))

inst_template0_funcs = ["addi", "subi", "bne", "beq", "bgt", "aes_set_ctr"]
for s in inst_template0_funcs:
    exec("def {func_name}(rd, rs, imm): \
              register_instruction('{func_name}', {which}, rd, rs, imm)".format(func_name=s, which=0)) # function factory

inst_template1_funcs = ["sha_hash_sk", "sha_squeeze_sk", "gauss_elim", "aes_update_ctr", "stall", "aes_set_round"]
for s in inst_template1_funcs:
    exec("def {func_name}(imm): \
              register_instruction('{func_name}', {which}, imm)".format(func_name=s, which=1))

inst_template2_funcs = ["sha_hash_v", "sha_hash_m", "aes_init_key", "unload_add_y", "send", "finish"]
for s in inst_template2_funcs:
    exec("def {func_name}(): \
              register_instruction('{func_name}', {which})".format(func_name=s, which=2))

inst_template3_funcs = ["store_o", "add_to_sig_v", "store_sig_o", "store_l", "unload_check", "tower_to_aes", "aes_to_tower"]
for s in inst_template3_funcs:
    exec("def {func_name}(rs1): \
              register_instruction('{func_name}', {which}, rs1)".format(func_name=s, which=3))

inst_template4_funcs = ["mul_l_inv", "mul_o", "store_keys", "load_keys", "calc_l"]
for s in inst_template4_funcs:
    exec("def {func_name}(data_addr, rs1, rs2): \
              register_instruction('{func_name}', {which}, rs2, rs1, data_addr)".format(func_name=s, which=4))

inst_template5_funcs = ["mul_key_o", "mul_key_o_pipe"]
for s in inst_template5_funcs:
    exec("def {func_name}(data_addr1, rs1, rs2, data_addr2, rs3, rs4): \
              register_instruction('{func_name}', {which}, rs2, rs1, data_addr2, data_addr1, rs4, rs3)".format(func_name=s, which=5))

inst_template6_funcs = ["eval"]
for s in inst_template6_funcs:
    exec("def {func_name}(data_addr): \
              register_instruction('{func_name}', {which}, data_addr)".format(func_name=s, which=6))

inst_template7_funcs = ["mul_key_sig"]
for s in inst_template7_funcs:
    exec("def {func_name}(data_addr, rs1, rs2, imm): \
              register_instruction('{func_name}', {which}, rs2, rs1, imm>>8, data_addr, imm&255)".format(func_name=s, which=7))

# Estimate the cycle count for each instruction.
cycle_map_ = {"addi"           : 1,
              "subi"           : 1,
              "bne"            : 1,
              "beq"            : 1,
              "bgt"            : 1, 
              
              "stall"          : 1,
              "sha_hash_v"     : 4,
              "sha_hash_m"     : 4,
              "sha_hash_sk"    : 4,
              "sha_squeeze_sk" : 4,
              "send"           : O//N+1,
              "store_o"        : O//N+1,
              
              "aes_set_round"  : 2,
              "aes_set_ctr"    : 2,
              "aes_update_ctr" : 2,
              "aes_init_key"   : 2,
              "aes_to_tower"   : 1,
              "tower_to_aes"   : 1,

              "gauss_elim"     : up_delay+(O+2*N+2*right_delay)*((2*O//N)+(O//N+1))*(O//N)//2,
              "mul_l_inv"      : 2+N,
              "mul_o"          : 2+N,
              "load_keys"      : 3,
              "store_keys"     : 2,
              
              "mul_key_o_pipe" : V+5,
              "mul_key_o"      : 3,
              "eval"           : 1,
              "calc_l"         : 3,
              "mul_key_sig"    : 3,
              
              "unload_check"   : math.ceil(O/N),
              "add_to_sig_v"   : O//N+1,
              "store_sig_o"    : O//N+1,
              "store_l"        : O//N+1,
              "unload_add_y"   : O//N+1, 

              "finish"        : 1
              }

cycle_map = Dict()
for k, v in cycle_map_.items():
    cycle_map[k] = v



# Define
r0  = 0
r1  = 1
r2  = 2
r3  = 3
r4  = 4
r5  = 5
r6  = 6
r7  = 7
r8  = 8
r9  = 9
r10 = 10
r11 = 11
r12 = 12
r13 = 13
r14 = 14
r15 = 15

# keys imm and depth for different modes
O1 = 0
if mode == "classic":
    mode_num      = 0
    P3            = 0
    L             = 1
    P2            = 2
    P1            = 3
    F1            = 3
    ZERO          = 4
    key_mem_depth = math.ceil(O*(O+1)//2/bank) + math.ceil(V/bank)*O + math.ceil(V*O/bank) + math.ceil(V*(V+1)//2/bank) + 1
elif mode == "pkc":
    mode_num      = 1
    P3            = 0
    L             = 1
    P2            = 1
    P1            = 2
    F1            = 2
    ZERO          = 3
    key_mem_depth = math.ceil(O*(O+1)//2/bank) + math.ceil(V/bank)*O + math.ceil(V*(V+1)//2/bank) + 1
elif mode == "pkc_skc":
    mode_num      = 2
    P3            = 0
    L             = 1
    P2            = 1
    P1            = 2
    F1            = 2
    ZERO          = 3
    key_mem_depth = math.ceil(O*(O+1)//2/bank) + math.ceil(V/bank)*rand_state_num + math.ceil(V*(V+1)//2/bank) + 1

# Mapping for the eval to evaluate the right variables.
@njit
def get_row_col(which):
    if mode == "classic":
        match which:
            case 0: # P3
                return (V_*N, V_*N)
            case 2: # P2
                return (0, V_*N)
            case 3: # P1
                return (0, 0)
    elif mode == "pkc":
        match which:
            case 0: # P3
                return (V_*N, V_*N)
            case 1: # P2
                return (0, V_*N)
            case 2: # P1
                return (0, 0)
    elif mode == "pkc_skc":
        match which:
            case 0: # P3
                return (V_*N, V_*N)
            case 1: # P2
                return (0, V_*N)
            case 2: # P1
                return (0, 0)

# Mapping between (imm, r1, r2) and key address  
@njit
def get_key_addr(which, r1, r2):
    if mode == "classic":
        match which:
            case 0: # P3
                idx = ((O+O-(r1-1))*r1)//2 + (r2-r1)
                depth = math.ceil(O*(O+1)//2/bank)
                for i in range(bank):
                    if idx < depth*(i+1) and depth*i <= idx:
                        ret_bank = i
                        idx -= depth*i
                return (idx, ret_bank)
            case 1: # L
                idx = r1
                depth = math.ceil(V/bank)
                for i in range(bank):
                    if idx < depth*(i+1) and depth*i <= idx:
                        ret_bank = i
                        idx -= depth*i
                return (math.ceil(O*(O+1)//2/bank) + r2*depth + idx, ret_bank)
            case 2: # P2
                idx = r1*O + r2
                depth = math.ceil(V*O/bank)
                for i in range(bank):
                    if idx < depth*(i+1) and depth*i <= idx:
                        ret_bank = i
                        idx -= depth*i
                return (math.ceil(O*(O+1)//2/bank) + math.ceil(V/bank)*O + idx, ret_bank)
            case 3: # P1
                idx = ((V+V-(r1-1))*r1)//2 + (r2-r1)
                depth = math.ceil(V*(V+1)//2/bank)
                for i in range(bank):
                    if idx < depth*(i+1) and depth*i <= idx:
                        ret_bank = i
                        idx -= depth*i
                return (math.ceil(O*(O+1)//2/bank) + math.ceil(V/bank)*O + math.ceil(V*O/bank) + idx, ret_bank)
            case 4: # ZERO
                return key_mem_depth-1, 0
    elif mode == "pkc":
        match which:
            case 0: # P3
                idx = ((O+O-(r1-1))*r1)//2 + (r2-r1)
                depth = math.ceil(O*(O+1)//2/bank)
                for i in range(bank):
                    if idx < depth*(i+1) and depth*i <= idx:
                        ret_bank = i
                        idx -= depth*i
                return (idx, ret_bank)
            case 1: # L, P2
                idx = r1
                depth = math.ceil(V/bank)
                for i in range(bank):
                    if idx < depth*(i+1) and depth*i <= idx:
                        ret_bank = i
                        idx -= depth*i
                return (math.ceil(O*(O+1)//2/bank) + r2*depth + idx, ret_bank)
            case 2: # P1
                idx = ((V+V-(r1-1))*r1)//2 + (r2-r1)
                depth = math.ceil(V*(V+1)//2/bank)
                for i in range(bank):
                    if idx < depth*(i+1) and depth*i <= idx:
                        ret_bank = i
                        idx -= depth*i
                return (math.ceil(O*(O+1)//2/bank) + math.ceil(V/bank)*O + idx, ret_bank)
            case 3: # ZERO
                return key_mem_depth-1, 0
    elif mode == "pkc_skc":
        match which:
            case 0: # P3
                idx = ((O+O-(r1-1))*r1)//2 + (r2-r1)
                depth = math.ceil(O*(O+1)//2/bank)
                for i in range(bank):
                    if idx < depth*(i+1) and depth*i <= idx:
                        ret_bank = i
                        idx -= depth*i
                return (idx, ret_bank)
            case 1: # L, P2
                idx = r1
                depth = math.ceil(V/bank)
                for i in range(bank):
                    if idx < depth*(i+1) and depth*i <= idx:
                        ret_bank = i
                        idx -= depth*i
                return (math.ceil(O*(O+1)//2/bank) + r2*depth + idx, ret_bank)
            case 2: # P1
                idx = ((V+V-(r1-1))*r1)//2 + (r2-r1)
                depth = math.ceil(V*(V+1)//2/bank)
                for i in range(bank):
                    if idx < depth*(i+1) and depth*i <= idx:
                        ret_bank = i
                        idx -= depth*i
                return (math.ceil(O*(O+1)//2/bank) + math.ceil(V/bank)*rand_state_num + idx, ret_bank)
            case 3: # ZERO
                return key_mem_depth-1, 0

@njit
def mul(a, b):
    if GF_bit == 4:
        if use_tower_field:
            return mulGF16_tower(a, b)
        else:
            return mulGF16_aes(a, b)
    elif GF_bit == 8:
        if use_tower_field:
            return mulGF256_tower(a, b)
        else:
            return mulGF256_aes(a, b)

@njit
def inv(a):
    if GF_bit == 4:
        if use_tower_field:
            return invGF16_tower(a)
        else:
            return invGF16_aes(a)
    elif GF_bit == 8:
        if use_tower_field:
            return invGF256_tower(a)
        else:
            return invGF256_aes(a)

@njit
def aes_to_tower_func(a):
    if GF_bit == 4:
        gfaes_to_gft = [
        [1,0,0,0,],
        [0,0,1,0,],
        [0,1,1,0,],
        [0,1,1,1,],
        ]
    elif GF_bit == 8:
        gfaes_to_gft = [
        [1,0,0,0,0,0,0,0,],
        [1,0,0,0,0,0,1,0,],
        [0,1,1,0,0,1,1,0,],
        [0,0,1,1,0,1,1,0,],
        [0,1,1,0,1,0,1,0,],
        [0,1,0,1,1,0,0,1,],
        [0,0,0,1,1,0,1,0,],
        [0,0,1,0,0,0,1,1,],
        ]
    a_list = []
    for i in range(GF_bit):
        a_list.append((a>>i) & 1)
    b_list = [0]*GF_bit
    for i in range(GF_bit):
        for j in range(GF_bit):
            b_list[i] = b_list[i] ^ (gfaes_to_gft[j][i] & a_list[j])
    b = 0
    for i in range(GF_bit):
        b += (b_list[i]<<i)
    return b 

@njit
def tower_to_aes_func(a):
    if GF_bit == 4:
        gft_to_gfaes = [
        [1,0,0,0,],
        [0,1,1,0,],
        [0,1,0,0,],
        [0,0,1,1,],
        ]
    elif GF_bit == 8:
        gft_to_gfaes = [
        [1,0,0,0,0,0,0,0,],
        [0,0,1,1,1,1,0,1,],
        [0,0,1,1,1,0,1,0,],
        [0,0,0,0,1,1,0,1,],
        [1,1,0,0,1,1,1,1,],
        [1,1,1,0,0,1,1,1,],
        [1,1,0,0,0,0,0,0,],
        [1,1,1,1,1,0,1,1,],
        ]
    a_list = []
    for i in range(GF_bit):
        a_list.append((a>>i) & 1)
    b_list = [0]*GF_bit
    for i in range(GF_bit):
        for j in range(GF_bit):
            b_list[i] = b_list[i] ^ (gft_to_gfaes[j][i] & a_list[j])
    b = 0
    for i in range(GF_bit):
        b += (b_list[i]<<i)
    return b 


########################################################
###               Simulation setup                   ###
########################################################

# @njit(cache=True)
def behavior_simulation(inst_map_, inv_inst_map_, cycle_map_, inst_, to_simulate, addrs):
    # global variables for behavior simulation
    
    control_reg   = [0]*(1<<reg_len)
    matrix_reg    = np.zeros((N, N), dtype=np.uint8)
    key_mem       = np.zeros((key_mem_depth, bank, O), dtype=np.uint8)
    O_mem         = np.zeros((V_*O_*N, N), dtype=np.uint8)
    L_mem         = np.zeros((2, O_*N, O_*N), dtype=np.uint8)
    sig_buff      = np.zeros(N, dtype=np.uint8)
    sig_temp      = np.zeros(O_*N, dtype=np.uint8)
    sig           = np.zeros((V_+O_)*N, dtype=np.uint8)
    message       = np.zeros(O_*N, dtype=np.uint8)
    rand_reg      = np.zeros((N, O_), dtype=np.uint8)
    pk_key        = 0xdeadbeefdeadbeefdeadbeefdeadbeef
    sk_key        = 0xbaaaaaadbaaaaaadbaaaaaadbaaaaaadbaaaaaadbaaaaaadbaaaaaadbaaaaaad
    enc_for_keys  = None
    shake         = None
    current_key   = 0
    current_ptext = 0
    buffer_bram   = np.zeros((buffer_depth, N), dtype=np.uint8)
    buffer_cnt    = 0
    rand_state    = 0
    salt          = 0xcafebabecafebabecafebabecafebabe
    message_in    = 0x5a45e7a4571d7f3661307efacefce2582e2b34ca59fa4c883b2c8aefd44be966
    ctr           = 0


    for s, s_addr in zip(to_simulate, addrs):
        if s == "Sign" or s == "Vrfy":
            for i in range(O):
                message[i] = i & (2**GF_bit-1)

        program_counter = s_addr
        cycle_count     = 0
  
        while program_counter != ((1<<imm_len)-1):
            # try: 
            current_inst = inst_[int(program_counter)]
            current_inst = current_inst.replace("_", "")
            op  = inv_inst_map_[current_inst[-op_len:]]
            imm = to_int(current_inst[-op_len-imm_len:-op_len])
            data_addr1 = to_int(current_inst[-op_len-2*reg_len-data_addr_len:-op_len-2*reg_len])
            data_addr2 = to_int(current_inst[-op_len-2*reg_len-2*data_addr_len:-op_len-2*reg_len-data_addr_len])
            rs1 = to_int(current_inst[-op_len-imm_len-reg_len:-op_len-imm_len])
            rs2 = to_int(current_inst[-op_len-imm_len-2*reg_len:-op_len-imm_len-reg_len])
            rs3 = to_int(current_inst[-op_len-1*reg_len:-op_len-0*reg_len])
            rs4 = to_int(current_inst[-op_len-2*reg_len:-op_len-1*reg_len])
            imm_mul_key = to_int(current_inst[-op_len-18:-op_len-11]+current_inst[-op_len-8:-op_len])
            cycle_count += cycle_map_[op]

            # print("============================================================================================================")
            # print("pc: ", format_int(program_counter, 3), " op: ", format_str(op, 13), 
            #   " rs1: ", format_int(rs1, 2), " rs2: ", format_int(rs2, 2), " rs3: ", format_int(rs3, 2), "rs4: ", format_int(rs4, 2), 
            #   " data_addr1: ", format_int(data_addr1, 2), " data_addr2: ", format_int(data_addr2, 2), " imm: ", format_int(imm, 3))
            # print(program_counter, op)
            program_counter += 1
            
            match op:
                case "addi":
                    control_reg[rs2] = control_reg[rs1] + imm
                case "subi":
                    control_reg[rs2] = control_reg[rs1] - imm
                case "bne":
                    if control_reg[rs1] != control_reg[rs2]:
                        program_counter = imm
                case "beq":
                    if control_reg[rs1] == control_reg[rs2]:
                        program_counter = imm
                case "bgt":
                    if control_reg[rs1] < control_reg[rs2]:
                        program_counter = imm
                case "stall":
                    cycle_count += imm
                case "aes_init_key":
                    enc_for_keys  = AES.new(pk_key.to_bytes(16, 'little'), AES.MODE_ECB)
                case "aes_set_ctr":
                    current_ptext = control_reg[rs1] + imm
                case "aes_to_tower":
                    for i in range(N):
                        sig[control_reg[rs1]*N+i] = aes_to_tower_func(sig[control_reg[rs1]*N+i])
                case "tower_to_aes":
                    # print("before")
                    # for i in range(N):
                    #     sys.stdout.write("%02x " % sig[control_reg[rs1]*N+i])
                    # print()
                    # print("after")
                    # for i in range(N):
                    #     sys.stdout.write("%02x " % tower_to_aes_func(sig[control_reg[rs1]*N+i]))
                    # print()
                    for i in range(N):
                        sig[control_reg[rs1]*N+i] = tower_to_aes_func(sig[control_reg[rs1]*N+i])
                case "sha_hash_v":
                    input_of_shake = (ctr<<640) + (sk_key<<384) + (salt<<256) + message_in
                    shake = SHAKE256.new(input_of_shake.to_bytes(81, 'little'))
                    temp = int.from_bytes(int(str(shake.read(V*GF_bit//8).hex()), 16).to_bytes(V*GF_bit//8, 'big'), "little")
                    for i in range(V):
                        if use_tower_field:
                            sig[i] = aes_to_tower_func((temp >> (i*GF_bit)) & (2**GF_bit-1))
                        else:
                            sig[i] = (temp >> (i*GF_bit)) & (2**GF_bit-1)
                    # print("SHA_HASH_V")
                    # for i in range(V):
                    #     sys.stdout.write("%02x " % sig[i])
                    # print()
                case "sha_hash_m":
                    input_of_shake = (salt<<256) + message_in
                    shake = SHAKE256.new(input_of_shake.to_bytes(48, 'little'))
                    temp = int.from_bytes(int(str(shake.read(O*GF_bit//8).hex()), 16).to_bytes(O*GF_bit//8, 'big'), "little")
                    for i in range(O):
                        if use_tower_field:
                            message[i] = aes_to_tower_func((temp >> (i*GF_bit)) & (2**GF_bit-1))
                        else:
                            message[i] = (temp >> (i*GF_bit)) & (2**GF_bit-1)
                    # print("SHA_HASH_M")
                    # for i in range(O):
                    #     sys.stdout.write("%02x " % message[i])
                    # print()
                case "sha_hash_sk":
                    shake = SHAKE256.new(sk_key.to_bytes(32, 'little'))
                    temp = int.from_bytes(int(str(shake.read(imm*64//8).hex()), 16).to_bytes(imm*64//8, 'big'), "little")
                    for i in range((imm*64) // (GF_bit*N)):
                        for j in range(N):
                            if use_tower_field:
                                buffer_bram[i][j] = aes_to_tower_func((temp >> ((N*i+j)*GF_bit)) & (2**GF_bit-1))
                            else:
                                buffer_bram[i][j] = (temp >> ((N*i+j)*GF_bit)) & (2**GF_bit-1)
                    #     for j in range(N):
                    #         sys.stdout.write("%2x " % buffer_bram[i][j])
                    #     print()
                    # print("----------------------------------")
                    rand_state = 0
                    buffer_cnt = 0
                case "sha_squeeze_sk":
                    temp = int.from_bytes(int(str(shake.read(imm*64//8).hex()), 16).to_bytes(imm*64//8, 'big'), "little")
                    for i in range((imm*64) // (GF_bit*N)):
                        for j in range(N):
                            if use_tower_field:
                                buffer_bram[i][j] = aes_to_tower_func((temp >> ((N*i+j)*GF_bit)) & (2**GF_bit-1))
                            else:
                                buffer_bram[i][j] = (temp >> ((N*i+j)*GF_bit)) & (2**GF_bit-1)
                    #     for j in range(N):
                    #         sys.stdout.write("%2x " % buffer_bram[i][j])
                    #     print()
                    # print("----------------------------------")
                    rand_state = 0
                    buffer_cnt = 0
                case "aes_update_ctr":
                    update_num         = imm % 65536
                    initial_rand_state = imm // 65536
                    for i in range(update_num):
                        rand = enc_for_keys.encrypt((current_ptext+i).to_bytes(16, 'big')) # 128 bits
                        rand = int.from_bytes(rand, byteorder='little')
                        for j in range(N):
                            if use_tower_field:
                                buffer_bram[i][j] = aes_to_tower_func((rand>>(GF_bit*j)) & (2**GF_bit-1))
                            else:
                                buffer_bram[i][j] = (rand>>(GF_bit*j)) & (2**GF_bit-1)
                    #     for j in range(N):
                    #         sys.stdout.write("%2x " % buffer_bram[i][j])
                    #     print()
                    # print("----------------------------------")
                    current_ptext += update_num
                    rand_state = initial_rand_state
                    buffer_cnt = 0
                case "store_o":
                    # print(op)
                    temp_buff = np.zeros((V_+1)*N, dtype=np.uint8)
                    for i in range(V_+1):
                        for j in range(N):
                            temp_buff[i*N+j] = buffer_bram[buffer_cnt+i][j]
                    for i in range(V_):
                        data_pipe = [0]*N
                        for j in range(N):
                            if (i == (V_-1) and j >= v_mod_n and v_mod_n != 0):
                                data_pipe[j] = 0
                            else:
                                data_pipe[j] = temp_buff[i*N+j+((v_mod_n*rand_state)%N)]
                        for j in range(N):
                            O_mem[control_reg[rs1]+i*O_*N][j] = data_pipe[j]
                    #     for j in range(N):
                    #         sys.stdout.write("%2x " % data_pipe[j])
                    #     print()
                    # print("----------------------------------")
                    if V == 112 or V == 96:
                        buffer_cnt += V_
                    elif V == 68 or V == 148:
                        if rand_state == rand_state_num-1:
                            buffer_cnt += V_
                        else:
                            buffer_cnt += (V_-1)
                    rand_state = (rand_state + 1)%rand_state_num
                case "send":
                    # print(op)
                    temp_buff = np.zeros((O_+1)*N, dtype=np.uint8)
                    for i in range(O_+1):
                        for j in range(N):
                            temp_buff[i*N+j] = buffer_bram[buffer_cnt+i][j]
                    for i in range(O_):
                        data_pipe = [0]*N
                        for j in range(N):
                            if (i == (O_-1) and j >= o_mod_n and o_mod_n != 0):
                                data_pipe[j] = 0
                            else:
                                data_pipe[j] = temp_buff[i*N+j+((o_mod_n*rand_state)%N)]
                        for j in range(N-1, 0, -1): # column
                            for k in range(N): # row
                                matrix_reg[k][j] = matrix_reg[k][j-1]
                        for k in range(N): # row
                            matrix_reg[k][0] = data_pipe[k]
                    #     for j in range(N):
                    #         sys.stdout.write("%2x " % data_pipe[j])
                    #     print()
                    # print("----------------------------------")
                    if O == 96 or O == 64:
                        buffer_cnt += O_
                    else:
                        if O == 44:
                            if rand_state == 0:
                                buffer_cnt += (O_-1)
                            else:
                                buffer_cnt += O_
                        elif O == 72:
                            if (rand_state & 1) == 0:
                                buffer_cnt += (O_-1)
                            else:
                                buffer_cnt += O_
                    rand_state = (rand_state + 1)%rand_state_num  
                case "store_keys":
                    store_addr, store_bank = get_key_addr(data_addr1, control_reg[rs1], control_reg[rs2])
                    for i in range(O):
                        key_mem[int(store_addr)][store_bank][i] = matrix_reg[i%N][O_-1-i//N]
                case "load_keys":
                    load_addr, load_bank = get_key_addr(data_addr1, control_reg[rs1], control_reg[rs2])
                    for i in range(O):
                        matrix_reg[i%N][O_-1-i//N] = key_mem[int(load_addr)][load_bank][i]
                    for i in range(O, O_*N):
                        matrix_reg[i%N][O_-1-i//N] = 0
                case "mul_key_o":
                    mul1_addr, mul1_bank = get_key_addr(data_addr1, control_reg[rs1], control_reg[rs2])
                    for i in range(O):
                        matrix_reg[i%N][O_-1-i//N] = matrix_reg[i%N][O_-1-i//N] ^ mul(key_mem[int(mul1_addr)][mul1_bank][i], O_mem[int(control_reg[rs4]+(control_reg[rs3]//N)*O_*N)][control_reg[rs3]%N])
                case "mul_key_o_pipe":
                    for k in range(V):
                        if control_reg[rs1] == k:
                            continue
                        elif control_reg[rs1] > k:
                            mul1_addr, mul1_bank = get_key_addr(data_addr1, k, control_reg[rs1])
                        else:
                            mul1_addr, mul1_bank = get_key_addr(data_addr1, control_reg[rs1], k)
                        for i in range(O):
                            matrix_reg[i%N][O_-1-i//N] = matrix_reg[i%N][O_-1-i//N] ^ mul(key_mem[int(mul1_addr)][mul1_bank][i], O_mem[int(control_reg[rs4]+(k//N)*O_*N)][k%N])
                case "calc_l":
                    cycle_count += V
                    for j in range(V):
                        mul1_addr, mul1_bank = get_key_addr(L, j, control_reg[rs2])
                        for i in range(O):
                            matrix_reg[i%N][O_-1-i//N] = matrix_reg[i%N][O_-1-i//N] ^ mul(key_mem[int(mul1_addr)][mul1_bank][i], sig[j])
                case "eval":
                    if (data_addr1 == P1):
                        cycle_count += V*(V+1) // 2
                    elif (data_addr1 == P2):
                        cycle_count += V*O
                    else:
                        cycle_count += O*(O+1) // 2
                    row, col = get_row_col(data_addr1)
                    if (data_addr1 == P1):
                        for i in range(V):
                            for j in range(i, V):
                                temp = mul(sig[row+i], sig[col+j])
                                mul1_addr, mul1_bank = get_key_addr(data_addr1, i, j)
                                for k in range(O):
                                    matrix_reg[k%N][O_-1-k//N] = matrix_reg[k%N][O_-1-k//N] ^ mul(key_mem[int(mul1_addr)][mul1_bank][k], temp)
                    elif (data_addr1 == P2):
                        for i in range(V):
                            for j in range(O):
                                temp = mul(sig[row+i], sig[col+j])
                                mul1_addr, mul1_bank = get_key_addr(data_addr1, i, j)
                                for k in range(O):
                                    matrix_reg[k%N][O_-1-k//N] = matrix_reg[k%N][O_-1-k//N] ^ mul(key_mem[int(mul1_addr)][mul1_bank][k], temp)
                    else:
                        for i in range(O):
                            for j in range(i, O):
                                temp = mul(sig[row+i], sig[col+j])
                                mul1_addr, mul1_bank = get_key_addr(data_addr1, i, j)
                                for k in range(O):
                                    matrix_reg[k%N][O_-1-k//N] = matrix_reg[k%N][O_-1-k//N] ^ mul(key_mem[int(mul1_addr)][mul1_bank][k], temp)
                case "mul_key_sig":
                    temp_buff = np.zeros((O_+1)*N, dtype=np.uint8)
                    init_row = control_reg[rs1]
                    init_col = control_reg[rs2]
                    buffer_cnt = 0
                    for t in range(imm_mul_key):
                        if init_row >= V:
                            break
                        for i in range(O_+1):
                            for j in range(N):
                                temp_buff[i*N+j] = buffer_bram[buffer_cnt+i][j]
                        for i in range(O_):
                            data_pipe = [0]*N
                            for j in range(N):
                                if (i == (O_-1) and j >= o_mod_n and o_mod_n != 0):
                                    data_pipe[j] = 0
                                else:
                                    data_pipe[j] = temp_buff[i*N+j+((o_mod_n*rand_state)%N)]
                            for j in range(O_-1, 0, -1): # column
                                for k in range(N): # row
                                    rand_reg[k][j] = rand_reg[k][j-1]
                            for k in range(N): # row
                                rand_reg[k][0] = data_pipe[k]
                        if O == 96 or O == 64:
                            buffer_cnt += O_
                        else:
                            if O == 44:
                                if rand_state == 0:
                                    buffer_cnt += (O_-1)
                                else:
                                    buffer_cnt += O_
                            elif O == 72:
                                if (rand_state & 1) == 0:
                                    buffer_cnt += (O_-1)
                                else:
                                    buffer_cnt += O_
                        rand_state = (rand_state + 1)%rand_state_num

                        row, col = get_row_col(data_addr1)
                        temp = mul(sig[row+init_row], sig[col+init_col])
                        for i in range(O):
                            matrix_reg[i%N][O_-1-i//N] = matrix_reg[i%N][O_-1-i//N] ^ mul(rand_reg[i%N][O_-1-i//N], temp)
                        # print("mul_key_sig ")
                        # if data_addr1 == P1:
                        #     print("P1")
                        # elif data_addr1 == P2:
                        #     print("P2")
                        # print("multiplied %02x" % temp)
                        # for i in range(O):
                        #     sys.stdout.write("%02x " % (matrix_reg[i%N][O_-1-i//N]))
                        # print()
                        # for i in range(O):
                        #     sys.stdout.write("%02x " % (rand_reg[i%N][O_-1-i//N]))
                        # print()
                        if init_col == V-1:
                            init_row += 1
                            if data_addr1 == P1:
                                init_col = init_row
                            else:
                                init_col = 0
                        else:
                            init_col += 1

                case "store_l":
                    for i in range(O):
                        L_mem[0][i][control_reg[rs1]] = matrix_reg[i%N][O_-1-i//N]
                case "unload_add_y":
                    for i in range(O):
                        sig_temp[i] = message[i] ^ matrix_reg[i%N][O_-1-i//N]
                case "mul_l_inv": # InvF
                    for i in range(N):
                        for k in range(N):
                            matrix_reg[i][0] = matrix_reg[i][0] ^ mul(L_mem[1][control_reg[rs1]*N+i][control_reg[rs2]*N+k],
                                                                      sig_temp[control_reg[rs2]*N+k])
                case "mul_o": # T
                    for i in range(N):
                        for k in range(N):
                            matrix_reg[i][0] = matrix_reg[i][0] ^ mul(O_mem[control_reg[rs1]*N*O_+control_reg[rs2]*N+k][i],
                                                                      sig[V_*N+control_reg[rs2]*N+k])
                case "add_to_sig_v":
                    for i in range(N):
                        sig[control_reg[rs1]*N+i] = sig[control_reg[rs1]*N+i] ^ matrix_reg[i][0]
                case "store_sig_o":
                    for i in range(N):
                        sig[V_*N+control_reg[rs1]*N+i] = matrix_reg[i][0]
                case "unload_check":
                    out = [0]*O
                    for i in range(O):
                        out[i] = matrix_reg[i%N][O_-1-i//N]
                    for i in range(O):
                        if out[i] != message[i]:
                            print("Err", i, out[i], message[i])
                case "gauss_elim":
                    if use_inversion:
                        A_rows = np.zeros((O_*N, 2*O_*N), dtype=np.uint8)
                        for i in range(O_*N):
                            for j in range(O_*N):
                                A_rows[i][j] = L_mem[0][i][j]
                        for i in range(O):
                            A_rows[i][O_*N+i] = 1
                        row_list = [(O+1)]*O
                        for c in range(O):
                            pivot = 0
                            inv_value = 1
                            for i in range(O):
                                if (A_rows[i][c] != 0 and (i not in row_list)):
                                    inv_value = inv(A_rows[i][c])
                                    pivot = i
                                    row_list[c] = i
                                    break
                            # normalize
                            for i in range(c, O):
                                A_rows[pivot][i] = mul(A_rows[pivot][i], inv_value);
                            for i in range(O):
                                A_rows[pivot][i+O_*N] = mul(A_rows[pivot][i+O_*N], inv_value);
                            # elimin
                            for i in range(O):
                                if (i == pivot): 
                                    continue
                                temp = A_rows[i][c]
                                for j in range(c, O):
                                    A_rows[i][j] = xor(A_rows[i][j], mul(A_rows[pivot][j], temp))
                                for j in range(O):
                                    A_rows[i][j+O_*N] = xor(A_rows[i][j+O_*N], mul(A_rows[pivot][j+O_*N], temp))
                        # print(row_list)
                        if (O+1) in row_list:
                            print("Non invertible")
                            program_counter = imm
                            ctr += 1
                            continue
                        out = np.zeros((O_*N,2*O_*N), dtype=np.uint8)
                        for i in range(O):
                            for j in range(2*O_*N):
                                out[i][j] = A_rows[row_list[i]][j]
                        for i in range(O_*N):
                            for j in range(O_*N):
                                L_mem[1][i][j] = out[i][O_*N+j]
                    else:
                        A_rows = np.zeros((O_*N, O_*N+1), dtype=np.uint8)
                        for i in range(O_*N):
                            for j in range(O_*N):
                                A_rows[i][j] = L_mem[0][i][j]
                        for i in range(O):
                            A_rows[i][O_*N] = sig_temp[i]
                        row_list = [(O+1)]*O
                        for c in range(O):
                            pivot = 0
                            inv_value = 1
                            for i in range(O):
                                if (A_rows[i][c] != 0 and (i not in row_list)):
                                    inv_value = inv(A_rows[i][c])
                                    pivot = i
                                    row_list[c] = i
                                    break
                            # normalize
                            for i in range(c, O):
                                A_rows[pivot][i] = mul(A_rows[pivot][i], inv_value);
                            for i in range(1):
                                A_rows[pivot][i+O_*N] = mul(A_rows[pivot][i+O_*N], inv_value);
                            # elimin
                            for i in range(O):
                                if (i == pivot): 
                                    continue
                                temp = A_rows[i][c]
                                for j in range(c, O):
                                    A_rows[i][j] = xor(A_rows[i][j], mul(A_rows[pivot][j], temp))
                                for j in range(1):
                                    A_rows[i][j+O_*N] = xor(A_rows[i][j+O_*N], mul(A_rows[pivot][j+O_*N], temp))
                        # print(row_list)
                        if (O+1) in row_list:
                            print("Non invertible")
                            program_counter = imm
                            ctr += 1
                            continue
                        out = np.zeros((O_*N,O_*N+1), dtype=np.uint8)
                        for i in range(O):
                            for j in range(O_*N+1):
                                out[i][j] = A_rows[row_list[i]][j]
                        for i in range(O):
                            sig[V_*N+i] = out[i][O_*N]
                case "finish":
                    program_counter = ((1<<imm_len)-1)
                    print("Sig: ")
                    if GF_bit == 4:
                        for i in range(V//2):
                            sys.stdout.write("%02x" % (sig[2*i]^(sig[2*i+1]<<4)))
                        for i in range(O//2):
                            sys.stdout.write("%02x" % (sig[V_*N+2*i]^(sig[V_*N+2*i+1]<<4)))
                    else:
                        for i in range(V):
                            sys.stdout.write("%02x" % sig[i])
                        for i in range(O):
                            sys.stdout.write("%02x" % sig[V_*N+i])
                    print()
                    print("%032x" % int.from_bytes(salt.to_bytes(128//8, 'big'), 'little'))
            
            # print("Mat")
            # print(getMat(matrix_reg, N, N))
            # print("Register value:")
            # print(format_int(control_reg[r0], 4), format_int(control_reg[r1], 4), format_int(control_reg[r2], 4), format_int(control_reg[r3], 4),
            #       format_int(control_reg[r4], 4), format_int(control_reg[r5], 4), format_int(control_reg[r6], 4), format_int(control_reg[r7], 4))
            # print("Sig_buff value:")
            # print(getVec(sig_buff, N))
            # print("Sig_temp1 value:")
            # print(getVec(sig_temp, O_*N))
            # print("Sig value:")
            # print(getVec(sig, (V_+O_)*N))
            # print("Message value:")
            # print(getVec(message, O_*N))
        print(s + ", Cycle count: " + str(cycle_count) + ", (N, V, O, GF_bit)=(" + str(N) + ", " + str(V) + ", " + str(O) + ", " + str(GF_bit) + ")")

# Read the codes in, and push them into instruction list.
exec(open(__file__.replace("codegen.py", "codegen_"+mode+".py")).read())


keygen_start = len(inst)
keygen_codegen()
sign_start = len(inst)
sign_codegen()
vrfy_start = len(inst)
vrfy_codegen()

for i in range((1<<inst_depth)-len(inst)):
    inst.append("1"*inst_len)

# Dump to test.data
with open("./test.data", "w") as sources:
    for i in inst:
        sources.write(i.replace("_", "")+"\n")

# Modify the testbench.v
if os.path.exists("./rtl/testbench.v") and not enable:
    with open("./rtl/testbench.v", "r") as sources:
        lines = sources.readlines()
    with open("./rtl/testbench.v", "w") as sources:
        for line in lines:
            line = re.sub(r"localparam KEYGEN_ADDR .* // keygen", 
                           "localparam KEYGEN_ADDR = 10'd" + str(keygen_start) + "; // keygen", line)
            line = re.sub(r"localparam SIGN_ADDR .* // sign", 
                           "localparam SIGN_ADDR = 10'd" + str(sign_start) + "; // sign", line)
            line = re.sub(r"localparam VRFY_ADDR .* // vrfy", 
                           "localparam VRFY_ADDR = 10'd" + str(vrfy_start) + "; // vrfy", line)
            line = re.sub(r"localparam TEST_MODE .* // test_mode",
                           "localparam TEST_MODE = 2'd" + str(mode_num) + "; // test_mode", line)
            line = re.sub(r"localparam INST_DEPTH .* // inst_depth",
                           "localparam INST_DEPTH = " + str(1<<inst_depth) + "; // inst_depth", line)
            line = re.sub(r"localparam INST_LEN .* // inst_len",
                           "localparam INST_LEN = " + str(inst_len) + "; // inst_len", line)
            line = re.sub(r"localparam AES_ROUND .* // aes_round",
                           "localparam AES_ROUND = " + str(aes_round) + "; // aes_round", line)
            sources.write(line)

# Modify the uov.c
if os.path.exists("./host/sdcard_test/uov.c") and not enable:
    with open("./host/sdcard_test/uov.c", "r") as sources:
        lines = sources.readlines()
    with open("./host/sdcard_test/uov.c", "w") as sources:
        for line in lines:
            line = re.sub(r"#define KEYGEN_ADDR .*", "#define KEYGEN_ADDR " + str(keygen_start), line) 
            line = re.sub(r"#define SIGN_ADDR .*", "#define SIGN_ADDR " + str(sign_start), line) 
            line = re.sub(r"#define VRFY_ADDR .*", "#define VRFY_ADDR " + str(vrfy_start), line) 
            line = re.sub(r"#define V .*", "#define V " + str(V), line)
            line = re.sub(r"#define O .*", "#define O " + str(O), line)
            line = re.sub(r"#define GF_BIT .*", "#define GF_BIT " + str(GF_bit), line)
            line = re.sub(r"#define INST_DEPTH .*", "#define INST_DEPTH " + str(1<<inst_depth), line)
            line = re.sub(r"#define LOG_INST_DEPTH .*", "#define LOG_INST_DEPTH " + str(inst_depth), line)
            line = re.sub(r"#define INST_LEN .*", "#define INST_LEN " + str(inst_len), line)
            sources.write(line)

# Modify the ov-test.c
if os.path.exists("./host/sdcard_test/pquov/unit_tests/ov-test.c") and not enable:
    with open("./host/sdcard_test/pquov/unit_tests/ov-test.c", "r") as sources:
        lines = sources.readlines()
    with open("./host/sdcard_test/pquov/unit_tests/ov-test.c", "w") as sources:
        for line in lines:
            line = re.sub(r"#define KEYGEN_ADDR .*", "#define KEYGEN_ADDR " + str(keygen_start), line) 
            line = re.sub(r"#define SIGN_ADDR .*", "#define SIGN_ADDR " + str(sign_start), line) 
            line = re.sub(r"#define VRFY_ADDR .*", "#define VRFY_ADDR " + str(vrfy_start), line) 
            line = re.sub(r"#define V .*", "#define V " + str(V), line)
            line = re.sub(r"#define O .*", "#define O " + str(O), line)
            line = re.sub(r"#define GF_BIT .*", "#define GF_BIT " + str(GF_bit), line)
            line = re.sub(r"#define INST_DEPTH .*", "#define INST_DEPTH " + str(1<<inst_depth), line)
            line = re.sub(r"#define LOG_INST_DEPTH .*", "#define LOG_INST_DEPTH " + str(inst_depth), line)
            line = re.sub(r"#define INST_LEN .*", "#define INST_LEN " + str(inst_len), line)
            sources.write(line)

# Modify the helloworld.c (needs to embed instruction into the c code)
if os.path.exists("./host/jtag_test/helloworld.c") and not enable:
    with open("./host/jtag_test/helloworld.c", "r") as sources:
        lines = sources.readlines()
    with open("./host/jtag_test/helloworld.c", "w") as sources:
        for line in lines:
            line = re.sub(r"#define KEYGEN_ADDR .*", "#define KEYGEN_ADDR " + str(keygen_start), line) 
            line = re.sub(r"#define SIGN_ADDR .*", "#define SIGN_ADDR " + str(sign_start), line) 
            line = re.sub(r"#define VRFY_ADDR .*", "#define VRFY_ADDR " + str(vrfy_start), line) 
            line = re.sub(r"#define V .*", "#define V " + str(V), line)
            line = re.sub(r"#define O .*", "#define O " + str(O), line)
            line = re.sub(r"#define GF_BIT .*", "#define GF_BIT " + str(GF_bit), line)
            line = re.sub(r"#define INST_DEPTH .*", "#define INST_DEPTH " + str(1<<inst_depth), line)
            line = re.sub(r"#define LOG_INST_DEPTH .*", "#define LOG_INST_DEPTH " + str(inst_depth), line)
            line = re.sub(r"#define INST_LEN .*", "#define INST_LEN " + str(inst_len), line)
            sources.write(line)
    
    codes = "// Instruction start\n"
    for i in inst:
        codes = codes + ("\""+i.replace("_", "")+"\",\n")
    codes = codes + "// Instruction end\n"

    line_all = ""
    with open("./host/jtag_test/helloworld.c", "r") as sources:
        lines = sources.readlines()
        for line in lines:
            line_all += line

    with open("./host/jtag_test/helloworld.c", "w") as sources:
        line_all = re.sub(r"// Instruction start[\s\S]*// Instruction end\n", codes, line_all)
        sources.write(line_all)

if enable:
    behavior_simulation(inst_map, inv_inst_map, cycle_map, inst, List(["Keygen", "Sign", "Vrfy"]), List([keygen_start, sign_start, vrfy_start]))
