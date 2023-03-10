module inv256_AES(b, b_inv);
    input [7:0] b;
    output reg [7:0] b_inv;
    always @ (*)
    case (b)
          0: b_inv =   1;
          1: b_inv =   1;
          2: b_inv = 141;
          3: b_inv = 246;
          4: b_inv = 203;
          5: b_inv =  82;
          6: b_inv = 123;
          7: b_inv = 209;
          8: b_inv = 232;
          9: b_inv =  79;
         10: b_inv =  41;
         11: b_inv = 192;
         12: b_inv = 176;
         13: b_inv = 225;
         14: b_inv = 229;
         15: b_inv = 199;
         16: b_inv = 116;
         17: b_inv = 180;
         18: b_inv = 170;
         19: b_inv =  75;
         20: b_inv = 153;
         21: b_inv =  43;
         22: b_inv =  96;
         23: b_inv =  95;
         24: b_inv =  88;
         25: b_inv =  63;
         26: b_inv = 253;
         27: b_inv = 204;
         28: b_inv = 255;
         29: b_inv =  64;
         30: b_inv = 238;
         31: b_inv = 178;
         32: b_inv =  58;
         33: b_inv = 110;
         34: b_inv =  90;
         35: b_inv = 241;
         36: b_inv =  85;
         37: b_inv =  77;
         38: b_inv = 168;
         39: b_inv = 201;
         40: b_inv = 193;
         41: b_inv =  10;
         42: b_inv = 152;
         43: b_inv =  21;
         44: b_inv =  48;
         45: b_inv =  68;
         46: b_inv = 162;
         47: b_inv = 194;
         48: b_inv =  44;
         49: b_inv =  69;
         50: b_inv = 146;
         51: b_inv = 108;
         52: b_inv = 243;
         53: b_inv =  57;
         54: b_inv = 102;
         55: b_inv =  66;
         56: b_inv = 242;
         57: b_inv =  53;
         58: b_inv =  32;
         59: b_inv = 111;
         60: b_inv = 119;
         61: b_inv = 187;
         62: b_inv =  89;
         63: b_inv =  25;
         64: b_inv =  29;
         65: b_inv = 254;
         66: b_inv =  55;
         67: b_inv = 103;
         68: b_inv =  45;
         69: b_inv =  49;
         70: b_inv = 245;
         71: b_inv = 105;
         72: b_inv = 167;
         73: b_inv = 100;
         74: b_inv = 171;
         75: b_inv =  19;
         76: b_inv =  84;
         77: b_inv =  37;
         78: b_inv = 233;
         79: b_inv =   9;
         80: b_inv = 237;
         81: b_inv =  92;
         82: b_inv =   5;
         83: b_inv = 202;
         84: b_inv =  76;
         85: b_inv =  36;
         86: b_inv = 135;
         87: b_inv = 191;
         88: b_inv =  24;
         89: b_inv =  62;
         90: b_inv =  34;
         91: b_inv = 240;
         92: b_inv =  81;
         93: b_inv = 236;
         94: b_inv =  97;
         95: b_inv =  23;
         96: b_inv =  22;
         97: b_inv =  94;
         98: b_inv = 175;
         99: b_inv = 211;
        100: b_inv =  73;
        101: b_inv = 166;
        102: b_inv =  54;
        103: b_inv =  67;
        104: b_inv = 244;
        105: b_inv =  71;
        106: b_inv = 145;
        107: b_inv = 223;
        108: b_inv =  51;
        109: b_inv = 147;
        110: b_inv =  33;
        111: b_inv =  59;
        112: b_inv = 121;
        113: b_inv = 183;
        114: b_inv = 151;
        115: b_inv = 133;
        116: b_inv =  16;
        117: b_inv = 181;
        118: b_inv = 186;
        119: b_inv =  60;
        120: b_inv = 182;
        121: b_inv = 112;
        122: b_inv = 208;
        123: b_inv =   6;
        124: b_inv = 161;
        125: b_inv = 250;
        126: b_inv = 129;
        127: b_inv = 130;
        128: b_inv = 131;
        129: b_inv = 126;
        130: b_inv = 127;
        131: b_inv = 128;
        132: b_inv = 150;
        133: b_inv = 115;
        134: b_inv = 190;
        135: b_inv =  86;
        136: b_inv = 155;
        137: b_inv = 158;
        138: b_inv = 149;
        139: b_inv = 217;
        140: b_inv = 247;
        141: b_inv =   2;
        142: b_inv = 185;
        143: b_inv = 164;
        144: b_inv = 222;
        145: b_inv = 106;
        146: b_inv =  50;
        147: b_inv = 109;
        148: b_inv = 216;
        149: b_inv = 138;
        150: b_inv = 132;
        151: b_inv = 114;
        152: b_inv =  42;
        153: b_inv =  20;
        154: b_inv = 159;
        155: b_inv = 136;
        156: b_inv = 249;
        157: b_inv = 220;
        158: b_inv = 137;
        159: b_inv = 154;
        160: b_inv = 251;
        161: b_inv = 124;
        162: b_inv =  46;
        163: b_inv = 195;
        164: b_inv = 143;
        165: b_inv = 184;
        166: b_inv = 101;
        167: b_inv =  72;
        168: b_inv =  38;
        169: b_inv = 200;
        170: b_inv =  18;
        171: b_inv =  74;
        172: b_inv = 206;
        173: b_inv = 231;
        174: b_inv = 210;
        175: b_inv =  98;
        176: b_inv =  12;
        177: b_inv = 224;
        178: b_inv =  31;
        179: b_inv = 239;
        180: b_inv =  17;
        181: b_inv = 117;
        182: b_inv = 120;
        183: b_inv = 113;
        184: b_inv = 165;
        185: b_inv = 142;
        186: b_inv = 118;
        187: b_inv =  61;
        188: b_inv = 189;
        189: b_inv = 188;
        190: b_inv = 134;
        191: b_inv =  87;
        192: b_inv =  11;
        193: b_inv =  40;
        194: b_inv =  47;
        195: b_inv = 163;
        196: b_inv = 218;
        197: b_inv = 212;
        198: b_inv = 228;
        199: b_inv =  15;
        200: b_inv = 169;
        201: b_inv =  39;
        202: b_inv =  83;
        203: b_inv =   4;
        204: b_inv =  27;
        205: b_inv = 252;
        206: b_inv = 172;
        207: b_inv = 230;
        208: b_inv = 122;
        209: b_inv =   7;
        210: b_inv = 174;
        211: b_inv =  99;
        212: b_inv = 197;
        213: b_inv = 219;
        214: b_inv = 226;
        215: b_inv = 234;
        216: b_inv = 148;
        217: b_inv = 139;
        218: b_inv = 196;
        219: b_inv = 213;
        220: b_inv = 157;
        221: b_inv = 248;
        222: b_inv = 144;
        223: b_inv = 107;
        224: b_inv = 177;
        225: b_inv =  13;
        226: b_inv = 214;
        227: b_inv = 235;
        228: b_inv = 198;
        229: b_inv =  14;
        230: b_inv = 207;
        231: b_inv = 173;
        232: b_inv =   8;
        233: b_inv =  78;
        234: b_inv = 215;
        235: b_inv = 227;
        236: b_inv =  93;
        237: b_inv =  80;
        238: b_inv =  30;
        239: b_inv = 179;
        240: b_inv =  91;
        241: b_inv =  35;
        242: b_inv =  56;
        243: b_inv =  52;
        244: b_inv = 104;
        245: b_inv =  70;
        246: b_inv =   3;
        247: b_inv = 140;
        248: b_inv = 221;
        249: b_inv = 156;
        250: b_inv = 125;
        251: b_inv = 160;
        252: b_inv = 205;
        253: b_inv =  26;
        254: b_inv =  65;
        255: b_inv =  28;
    endcase
endmodule

module inv16_AES(b, b_inv);
    input [3:0] b;
    output reg [3:0] b_inv;

    always @ (*)
    case (b)
        4'h0: b_inv = 4'h1;
        4'h1: b_inv = 4'h1;
        4'h2: b_inv = 4'h9;
        4'h3: b_inv = 4'he;
        4'h4: b_inv = 4'hd;
        4'h5: b_inv = 4'hb;
        4'h6: b_inv = 4'h7;
        4'h7: b_inv = 4'h6;
        4'h8: b_inv = 4'hf;
        4'h9: b_inv = 4'h2;
        4'ha: b_inv = 4'hc;
        4'hb: b_inv = 4'h5;
        4'hc: b_inv = 4'ha;
        4'hd: b_inv = 4'h4;
        4'he: b_inv = 4'h3;
        4'hf: b_inv = 4'h8;
    endcase
endmodule

// x^4 + x + 1
module mul16_AES (o,a,b);
output [3:0]   o;
input  [3:0] a, b;

wire [6:0] temp;
assign temp[0] = (a[0] & b[0]);
assign temp[1] = (a[0] & b[1])^(a[1] & b[0]);
assign temp[2] = (a[0] & b[2])^(a[1] & b[1])^(a[2] & b[0]);
assign temp[3] = (a[0] & b[3])^(a[1] & b[2])^(a[2] & b[1])^(a[3] & b[0]);
assign temp[4] = (a[1] & b[3])^(a[2] & b[2])^(a[3] & b[1]);
assign temp[5] = (a[2] & b[3])^(a[3] & b[2]);
assign temp[6] = (a[3] & b[3]);
wire [3:0] temp2;
assign temp2[0] = temp[0]^temp[4];
assign temp2[1] = temp[1]^temp[4]^temp[5];
assign temp2[2] = temp[2]^temp[5]^temp[6];
assign temp2[3] = temp[3]^temp[6];
assign o = temp2;
endmodule

// x^8 + x^4 + x^3 + x + 1
module mul256_AES (o,a,b);
output [7:0]   o;
input  [7:0] a, b;

wire [14:0] temp;
assign temp[0] = (a[0] & b[0]);
assign temp[1] = (a[0] & b[1])^(a[1] & b[0]);
assign temp[2] = (a[0] & b[2])^(a[1] & b[1])^(a[2] & b[0]);
assign temp[3] = (a[0] & b[3])^(a[1] & b[2])^(a[2] & b[1])^(a[3] & b[0]);
assign temp[4] = (a[0] & b[4])^(a[1] & b[3])^(a[2] & b[2])^(a[3] & b[1])^(a[4] & b[0]);
assign temp[5] = (a[0] & b[5])^(a[1] & b[4])^(a[2] & b[3])^(a[3] & b[2])^(a[4] & b[1])^(a[5] & b[0]);
assign temp[6] = (a[0] & b[6])^(a[1] & b[5])^(a[2] & b[4])^(a[3] & b[3])^(a[4] & b[2])^(a[5] & b[1])^(a[6] & b[0]);
assign temp[7] = (a[0] & b[7])^(a[1] & b[6])^(a[2] & b[5])^(a[3] & b[4])^(a[4] & b[3])^(a[5] & b[2])^(a[6] & b[1])^(a[7] & b[0]);
assign temp[8] = (a[1] & b[7])^(a[2] & b[6])^(a[3] & b[5])^(a[4] & b[4])^(a[5] & b[3])^(a[6] & b[2])^(a[7] & b[1]);
assign temp[9] = (a[2] & b[7])^(a[3] & b[6])^(a[4] & b[5])^(a[5] & b[4])^(a[6] & b[3])^(a[7] & b[2]);
assign temp[10] = (a[3] & b[7])^(a[4] & b[6])^(a[5] & b[5])^(a[6] & b[4])^(a[7] & b[3]);
assign temp[11] = (a[4] & b[7])^(a[5] & b[6])^(a[6] & b[5])^(a[7] & b[4]);
assign temp[12] = (a[5] & b[7])^(a[6] & b[6])^(a[7] & b[5]);
assign temp[13] = (a[6] & b[7])^(a[7] & b[6]);
assign temp[14] = (a[7] & b[7]);
wire [7:0] temp3;
assign temp3[0] = temp[0]^temp[8]^temp[12]^temp[13];
assign temp3[1] = temp[1]^temp[8]^temp[12]^temp[9]^temp[14];
assign temp3[2] = temp[2]^temp[9]^temp[13]^temp[10];
assign temp3[3] = temp[3]^temp[11]^temp[8]^temp[12]^temp[13]^temp[10]^temp[14];
assign temp3[4] = temp[4]^temp[11]^temp[8]^temp[9]^temp[14];
assign temp3[5] = temp[5]^temp[12]^temp[9]^temp[10];
assign temp3[6] = temp[6]^temp[11]^temp[13]^temp[10];
assign temp3[7] = temp[7]^temp[11]^temp[12]^temp[14];
assign o = temp3;
endmodule


