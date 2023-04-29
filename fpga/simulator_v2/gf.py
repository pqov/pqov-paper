import sys
import math
from numba import njit

### helpers
@njit
def format_int(i, l):
    t = str(i)
    t = " "*(l-len(t)) + t
    return t

@njit
def format_str(s, l):
    s = " "*(l-len(s)) + s
    return s

@njit
def to_int(s):
    s = s[::-1]
    ret = 0
    for idx, i in enumerate(s):
        if i == "1":
            ret += 1<<(idx)
    return ret

@njit
def getVec(a, N):
    ret = ""
    for i in range(N):
        ret += format_int(a[i], 4)+","
    ret += ("\n")
    return ret

@njit
def getMat(a, N, K):
    ret = ""
    for i in range(N):
        for j in range(K):
            ret += format_int(a[i][j], 4)+","
        ret += ("\n")
    return ret

### GF related operations
@njit
def xor(x,y):
    return x^y

@njit
def mulGF4(a, b):
    a0 = a & 0x1;
    a1 = (a>>1) & 0x1;
    b0 = b & 0x1;
    b1 = (b>>1) & 0x1;
    t0 = xor((a0 & b0), (a1 & b1))
    t1 = xor(xor((a1 & b0),  (a0 & b1)), (a1 & b1))
    return t0 | (t1 << 1)

@njit
def mulGF16_tower(a, b):
    a0 = a & 0x3;
    a1 = (a>>2) & 0x3;
    b0 = b & 0x3;
    b1 = (b>>2) & 0x3;
    t1 = xor(mulGF4(xor(a0, a1), xor(b0, b1)), mulGF4(a0, b0))
    t0 = xor(mulGF4(a0, b0), mulGF4(mulGF4(a1, b1), 0x2))
    return (t0 | (t1 << 2))

@njit
def mulGF256_tower(a, b):
    a0 = a & 0xf;
    a1 = (a>>4) & 0xf;
    b0 = b & 0xf;
    b1 = (b>>4) & 0xf;
    a0b0 = mulGF16_tower(a0, b0);
    a1b1 = mulGF16_tower(a1, b1);
    t1 = mulGF16_tower(a0 ^ a1, b0 ^ b1) ^ a0b0;
    t0 = a0b0 ^ mulGF16_tower(a1b1, 0x8);
    return t0 | (t1 << 4)

@njit
def invGF16_tower(a):
    match a:
        case 0x0: return 0x0;
        case 0x1: return 0x1;
        case 0x2: return 0x3;
        case 0x3: return 0x2;
        case 0x4: return 0xf;
        case 0x5: return 0xc;
        case 0x6: return 0x9;
        case 0x7: return 0xb;
        case 0x8: return 0xa;
        case 0x9: return 0x6;
        case 0xa: return 0x8;
        case 0xb: return 0x7;
        case 0xc: return 0x5;
        case 0xd: return 0xe;
        case 0xe: return 0xd;
        case 0xf: return 0x4;
    assert(0), "invGF16 err"

@njit
def invGF256_tower(a):
    match a:
        case 0: return 0x0;
        case 1: return 1;
        case 2: return 3;
        case 3: return 2;
        case 4: return 15;
        case 5: return 12;
        case 6: return 9;
        case 7: return 11;
        case 8: return 10;
        case 9: return 6;
        case 10: return 8;
        case 11: return 7;
        case 12: return 5;
        case 13: return 14;
        case 14: return 13;
        case 15: return 4;
        case 16: return 170;
        case 17: return 160;
        case 18: return 109;
        case 19: return 107;
        case 20: return 131;
        case 21: return 139;
        case 22: return 116;
        case 23: return 115;
        case 24: return 228;
        case 25: return 234;
        case 26: return 92;
        case 27: return 89;
        case 28: return 73;
        case 29: return 77;
        case 30: return 220;
        case 31: return 209;
        case 32: return 85;
        case 33: return 214;
        case 34: return 80;
        case 35: return 219;
        case 36: return 199;
        case 37: return 179;
        case 38: return 203;
        case 39: return 184;
        case 40: return 66;
        case 41: return 226;
        case 42: return 70;
        case 43: return 236;
        case 44: return 156;
        case 45: return 247;
        case 46: return 149;
        case 47: return 248;
        case 48: return 255;
        case 49: return 182;
        case 50: return 189;
        case 51: return 240;
        case 52: return 120;
        case 53: return 164;
        case 54: return 174;
        case 55: return 127;
        case 56: return 142;
        case 57: return 100;
        case 58: return 98;
        case 59: return 134;
        case 60: return 193;
        case 61: return 152;
        case 62: return 145;
        case 63: return 205;
        case 64: return 119;
        case 65: return 207;
        case 66: return 40;
        case 67: return 227;
        case 68: return 112;
        case 69: return 195;
        case 70: return 42;
        case 71: return 237;
        case 72: return 76;
        case 73: return 28;
        case 74: return 186;
        case 75: return 97;
        case 76: return 72;
        case 77: return 29;
        case 78: return 177;
        case 79: return 103;
        case 80: return 34;
        case 81: return 218;
        case 82: return 104;
        case 83: return 253;
        case 84: return 215;
        case 85: return 32;
        case 86: return 242;
        case 87: return 110;
        case 88: return 93;
        case 89: return 27;
        case 90: return 151;
        case 91: return 123;
        case 92: return 26;
        case 93: return 88;
        case 94: return 124;
        case 95: return 158;
        case 96: return 187;
        case 97: return 75;
        case 98: return 58;
        case 99: return 135;
        case 100: return 57;
        case 101: return 143;
        case 102: return 176;
        case 103: return 79;
        case 104: return 82;
        case 105: return 252;
        case 106: return 108;
        case 107: return 19;
        case 108: return 106;
        case 109: return 18;
        case 110: return 87;
        case 111: return 243;
        case 112: return 68;
        case 113: return 194;
        case 114: return 117;
        case 115: return 23;
        case 116: return 22;
        case 117: return 114;
        case 118: return 206;
        case 119: return 64;
        case 120: return 52;
        case 121: return 165;
        case 122: return 150;
        case 123: return 91;
        case 124: return 94;
        case 125: return 159;
        case 126: return 175;
        case 127: return 55;
        case 128: return 238;
        case 129: return 146;
        case 130: return 138;
        case 131: return 20;
        case 132: return 196;
        case 133: return 222;
        case 134: return 59;
        case 135: return 99;
        case 136: return 224;
        case 137: return 155;
        case 138: return 130;
        case 139: return 21;
        case 140: return 200;
        case 141: return 211;
        case 142: return 56;
        case 143: return 101;
        case 144: return 204;
        case 145: return 62;
        case 146: return 129;
        case 147: return 239;
        case 148: return 249;
        case 149: return 46;
        case 150: return 122;
        case 151: return 90;
        case 152: return 61;
        case 153: return 192;
        case 154: return 225;
        case 155: return 137;
        case 156: return 44;
        case 157: return 246;
        case 158: return 95;
        case 159: return 125;
        case 160: return 17;
        case 161: return 171;
        case 162: return 181;
        case 163: return 212;
        case 164: return 53;
        case 165: return 121;
        case 166: return 244;
        case 167: return 232;
        case 168: return 190;
        case 169: return 217;
        case 170: return 16;
        case 171: return 161;
        case 172: return 251;
        case 173: return 230;
        case 174: return 54;
        case 175: return 126;
        case 176: return 102;
        case 177: return 78;
        case 178: return 198;
        case 179: return 37;
        case 180: return 213;
        case 181: return 162;
        case 182: return 49;
        case 183: return 254;
        case 184: return 39;
        case 185: return 202;
        case 186: return 74;
        case 187: return 96;
        case 188: return 241;
        case 189: return 50;
        case 190: return 168;
        case 191: return 216;
        case 192: return 153;
        case 193: return 60;
        case 194: return 113;
        case 195: return 69;
        case 196: return 132;
        case 197: return 223;
        case 198: return 178;
        case 199: return 36;
        case 200: return 140;
        case 201: return 210;
        case 202: return 185;
        case 203: return 38;
        case 204: return 144;
        case 205: return 63;
        case 206: return 118;
        case 207: return 65;
        case 208: return 221;
        case 209: return 31;
        case 210: return 201;
        case 211: return 141;
        case 212: return 163;
        case 213: return 180;
        case 214: return 33;
        case 215: return 84;
        case 216: return 191;
        case 217: return 169;
        case 218: return 81;
        case 219: return 35;
        case 220: return 30;
        case 221: return 208;
        case 222: return 133;
        case 223: return 197;
        case 224: return 136;
        case 225: return 154;
        case 226: return 41;
        case 227: return 67;
        case 228: return 24;
        case 229: return 235;
        case 230: return 173;
        case 231: return 250;
        case 232: return 167;
        case 233: return 245;
        case 234: return 25;
        case 235: return 229;
        case 236: return 43;
        case 237: return 71;
        case 238: return 128;
        case 239: return 147;
        case 240: return 51;
        case 241: return 188;
        case 242: return 86;
        case 243: return 111;
        case 244: return 166;
        case 245: return 233;
        case 246: return 157;
        case 247: return 45;
        case 248: return 47;
        case 249: return 148;
        case 250: return 231;
        case 251: return 172;
        case 252: return 105;
        case 253: return 83;
        case 254: return 183;
        case 255: return 48;
    assert(0), "invGF256 err"

@njit
def invGF16_aes(a):
    match a:
        case 0x0: return 0x0;
        case 0x1: return 0x1;
        case 0x2: return 0x9;
        case 0x3: return 0xe;
        case 0x4: return 0xd;
        case 0x5: return 0xb;
        case 0x6: return 0x7;
        case 0x7: return 0x6;
        case 0x8: return 0xf;
        case 0x9: return 0x2;
        case 0xa: return 0xc;
        case 0xb: return 0x5;
        case 0xc: return 0xa;
        case 0xd: return 0x4;
        case 0xe: return 0x3;
        case 0xf: return 0x8;
    assert(0), "invGF16 err"

@njit
def invGF256_aes(a):
    match a:
        case   0: return   0;
        case   1: return   1;
        case   2: return 141;
        case   3: return 246;
        case   4: return 203;
        case   5: return  82;
        case   6: return 123;
        case   7: return 209;
        case   8: return 232;
        case   9: return  79;
        case  10: return  41;
        case  11: return 192;
        case  12: return 176;
        case  13: return 225;
        case  14: return 229;
        case  15: return 199;
        case  16: return 116;
        case  17: return 180;
        case  18: return 170;
        case  19: return  75;
        case  20: return 153;
        case  21: return  43;
        case  22: return  96;
        case  23: return  95;
        case  24: return  88;
        case  25: return  63;
        case  26: return 253;
        case  27: return 204;
        case  28: return 255;
        case  29: return  64;
        case  30: return 238;
        case  31: return 178;
        case  32: return  58;
        case  33: return 110;
        case  34: return  90;
        case  35: return 241;
        case  36: return  85;
        case  37: return  77;
        case  38: return 168;
        case  39: return 201;
        case  40: return 193;
        case  41: return  10;
        case  42: return 152;
        case  43: return  21;
        case  44: return  48;
        case  45: return  68;
        case  46: return 162;
        case  47: return 194;
        case  48: return  44;
        case  49: return  69;
        case  50: return 146;
        case  51: return 108;
        case  52: return 243;
        case  53: return  57;
        case  54: return 102;
        case  55: return  66;
        case  56: return 242;
        case  57: return  53;
        case  58: return  32;
        case  59: return 111;
        case  60: return 119;
        case  61: return 187;
        case  62: return  89;
        case  63: return  25;
        case  64: return  29;
        case  65: return 254;
        case  66: return  55;
        case  67: return 103;
        case  68: return  45;
        case  69: return  49;
        case  70: return 245;
        case  71: return 105;
        case  72: return 167;
        case  73: return 100;
        case  74: return 171;
        case  75: return  19;
        case  76: return  84;
        case  77: return  37;
        case  78: return 233;
        case  79: return   9;
        case  80: return 237;
        case  81: return  92;
        case  82: return   5;
        case  83: return 202;
        case  84: return  76;
        case  85: return  36;
        case  86: return 135;
        case  87: return 191;
        case  88: return  24;
        case  89: return  62;
        case  90: return  34;
        case  91: return 240;
        case  92: return  81;
        case  93: return 236;
        case  94: return  97;
        case  95: return  23;
        case  96: return  22;
        case  97: return  94;
        case  98: return 175;
        case  99: return 211;
        case 100: return  73;
        case 101: return 166;
        case 102: return  54;
        case 103: return  67;
        case 104: return 244;
        case 105: return  71;
        case 106: return 145;
        case 107: return 223;
        case 108: return  51;
        case 109: return 147;
        case 110: return  33;
        case 111: return  59;
        case 112: return 121;
        case 113: return 183;
        case 114: return 151;
        case 115: return 133;
        case 116: return  16;
        case 117: return 181;
        case 118: return 186;
        case 119: return  60;
        case 120: return 182;
        case 121: return 112;
        case 122: return 208;
        case 123: return   6;
        case 124: return 161;
        case 125: return 250;
        case 126: return 129;
        case 127: return 130;
        case 128: return 131;
        case 129: return 126;
        case 130: return 127;
        case 131: return 128;
        case 132: return 150;
        case 133: return 115;
        case 134: return 190;
        case 135: return  86;
        case 136: return 155;
        case 137: return 158;
        case 138: return 149;
        case 139: return 217;
        case 140: return 247;
        case 141: return   2;
        case 142: return 185;
        case 143: return 164;
        case 144: return 222;
        case 145: return 106;
        case 146: return  50;
        case 147: return 109;
        case 148: return 216;
        case 149: return 138;
        case 150: return 132;
        case 151: return 114;
        case 152: return  42;
        case 153: return  20;
        case 154: return 159;
        case 155: return 136;
        case 156: return 249;
        case 157: return 220;
        case 158: return 137;
        case 159: return 154;
        case 160: return 251;
        case 161: return 124;
        case 162: return  46;
        case 163: return 195;
        case 164: return 143;
        case 165: return 184;
        case 166: return 101;
        case 167: return  72;
        case 168: return  38;
        case 169: return 200;
        case 170: return  18;
        case 171: return  74;
        case 172: return 206;
        case 173: return 231;
        case 174: return 210;
        case 175: return  98;
        case 176: return  12;
        case 177: return 224;
        case 178: return  31;
        case 179: return 239;
        case 180: return  17;
        case 181: return 117;
        case 182: return 120;
        case 183: return 113;
        case 184: return 165;
        case 185: return 142;
        case 186: return 118;
        case 187: return  61;
        case 188: return 189;
        case 189: return 188;
        case 190: return 134;
        case 191: return  87;
        case 192: return  11;
        case 193: return  40;
        case 194: return  47;
        case 195: return 163;
        case 196: return 218;
        case 197: return 212;
        case 198: return 228;
        case 199: return  15;
        case 200: return 169;
        case 201: return  39;
        case 202: return  83;
        case 203: return   4;
        case 204: return  27;
        case 205: return 252;
        case 206: return 172;
        case 207: return 230;
        case 208: return 122;
        case 209: return   7;
        case 210: return 174;
        case 211: return  99;
        case 212: return 197;
        case 213: return 219;
        case 214: return 226;
        case 215: return 234;
        case 216: return 148;
        case 217: return 139;
        case 218: return 196;
        case 219: return 213;
        case 220: return 157;
        case 221: return 248;
        case 222: return 144;
        case 223: return 107;
        case 224: return 177;
        case 225: return  13;
        case 226: return 214;
        case 227: return 235;
        case 228: return 198;
        case 229: return  14;
        case 230: return 207;
        case 231: return 173;
        case 232: return   8;
        case 233: return  78;
        case 234: return 215;
        case 235: return 227;
        case 236: return  93;
        case 237: return  80;
        case 238: return  30;
        case 239: return 179;
        case 240: return  91;
        case 241: return  35;
        case 242: return  56;
        case 243: return  52;
        case 244: return 104;
        case 245: return  70;
        case 246: return   3;
        case 247: return 140;
        case 248: return 221;
        case 249: return 156;
        case 250: return 125;
        case 251: return 160;
        case 252: return 205;
        case 253: return  26;
        case 254: return  65;
        case 255: return  28;
    assert(0), "invGF256 err"

@njit
def mulGF16_aes(a, b):
    temp = [0]*(7)
    a_bit = [0]*4
    b_bit = [0]*4
    for i in range(4):
        a_bit[i] = ((a>>i)&1)
        b_bit[i] = ((b>>i)&1)
    for i in range(4):
        for j in range(4):
            temp[i+j] = temp[i+j] ^ (a_bit[i]&b_bit[j])
    temp2 = [0]*4
    for i in range(4):
        temp2[i] = temp[i]
    for i in range(4, 7):
        temp2[i-4] = temp2[i-4] ^ temp[i]
        temp2[i-3] = temp2[i-3] ^ temp[i]
    ret = 0
    for i in range(4):
        ret += (temp2[i]<<i)
    return ret

@njit
def mulGF256_aes(a, b):
    temp = [0]*(15)
    a_bit = [0]*8
    b_bit = [0]*8
    for i in range(8):
        a_bit[i] = ((a>>i)&1)
        b_bit[i] = ((b>>i)&1)
    for i in range(8):
        for j in range(8):
            temp[i+j] = temp[i+j] ^ (a_bit[i]&b_bit[j])
    temp2 = [0]*(11)
    for i in range(11):
        temp2[i] = temp[i]
    for i in range(11, 15):
        temp2[i-8] = temp2[i-8] ^ temp[i]
        temp2[i-7] = temp2[i-7] ^ temp[i]
        temp2[i-5] = temp2[i-5] ^ temp[i]
        temp2[i-4] = temp2[i-4] ^ temp[i]
    temp3 = [0]*(8)
    for i in range(8):
        temp3[i] = temp2[i]
    for i in range(8, 11):
        temp3[i-8] = temp3[i-8] ^ temp2[i]
        temp3[i-7] = temp3[i-7] ^ temp2[i]
        temp3[i-5] = temp3[i-5] ^ temp2[i]
        temp3[i-4] = temp3[i-4] ^ temp2[i]
    ret = 0
    for i in range(8):
        ret += (temp3[i]<<i)
    return ret