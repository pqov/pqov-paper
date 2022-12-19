/******************************************************************************
* C language implementations of the AES-128 and AES-256 key schedules to match
* the fixsliced representation. Note that those implementations rely on Look-Up
* Tables (LUT).
*
* See the paper at https://eprint.iacr.org/2020/1123.pdf for more details.
*
* @author 	Alexandre Adomnicai, Nanyang Technological University, Singapore
*			alexandre.adomnicai@ntu.edu.sg
*
* @date		August 2020
******************************************************************************/
#include "aes256_keyexp_ffs.h"


#include <stdint.h>

#define ROR(x,y)                (((x) >> (y)) | ((x) << (32 - (y))))

#define SWAPMOVE(a, b, mask, n) do{                                                      \
        tmp = (b ^ (a >> n)) & mask;                                                    \
        b ^= tmp;                                                                                               \
        a ^= (tmp << n);                                                                                \
} while(0)

#define LE_LOAD_32(x)                                                                           \
    ((((uint32_t)((x)[3])) << 24) |                                             \
     (((uint32_t)((x)[2])) << 16) |                                             \
     (((uint32_t)((x)[1])) << 8) |                                                      \
      ((uint32_t)((x)[0])))








/******************************************************************************
* Packs two 128-bit input blocs in0, in1 into the 256-bit internal state out 
* where the bits are packed as follows:
* out[0] = b_24 b_56 b_88 b_120 || ... || b_0 b_32 b_64 b_96
* out[1] = b_25 b_57 b_89 b_121 || ... || b_1 b_33 b_65 b_97
* out[2] = b_26 b_58 b_90 b_122 || ... || b_2 b_34 b_66 b_98
* out[3] = b_27 b_59 b_91 b_123 || ... || b_3 b_35 b_67 b_99
* out[4] = b_28 b_60 b_92 b_124 || ... || b_4 b_36 b_68 b_100
* out[5] = b_29 b_61 b_93 b_125 || ... || b_5 b_37 b_69 b_101
* out[6] = b_30 b_62 b_94 b_126 || ... || b_6 b_38 b_70 b_102
* out[7] = b_31 b_63 b_95 b_127 || ... || b_7 b_39 b_71 b_103
******************************************************************************/
static void _packing(uint32_t* out, const unsigned char* in0,
                const unsigned char* in1) {
        uint32_t tmp;
        out[0] = LE_LOAD_32(in0);
        out[1] = LE_LOAD_32(in1);
        out[2] = LE_LOAD_32(in0 + 4);
        out[3] = LE_LOAD_32(in1 + 4);
        out[4] = LE_LOAD_32(in0 + 8);
        out[5] = LE_LOAD_32(in1 + 8);
        out[6] = LE_LOAD_32(in0 + 12);
        out[7] = LE_LOAD_32(in1 + 12);
        SWAPMOVE(out[1], out[0], 0x55555555, 1);
        SWAPMOVE(out[3], out[2], 0x55555555, 1);
        SWAPMOVE(out[5], out[4], 0x55555555, 1);
        SWAPMOVE(out[7], out[6], 0x55555555, 1);
        SWAPMOVE(out[2], out[0], 0x33333333, 2);
        SWAPMOVE(out[3], out[1], 0x33333333, 2);
        SWAPMOVE(out[6], out[4], 0x33333333, 2);
        SWAPMOVE(out[7], out[5], 0x33333333, 2);
        SWAPMOVE(out[4], out[0], 0x0f0f0f0f, 4);
        SWAPMOVE(out[5], out[1], 0x0f0f0f0f, 4);
        SWAPMOVE(out[6], out[2], 0x0f0f0f0f, 4);
        SWAPMOVE(out[7], out[3], 0x0f0f0f0f, 4);
}




/******************************************************************************
* C language implementations of the AES-128 and AES-256 key schedules to match
* the fixsliced representation. Note that those implementations are fully
* bitsliced and do not rely on any Look-Up Table (LUT).
*
* See the paper at https://eprint.iacr.org/2020/1123.pdf for more details.
*
* @author 	Alexandre Adomnicai, Nanyang Technological University, Singapore
*			alexandre.adomnicai@ntu.edu.sg
*
* @date		October 2020
******************************************************************************/
#include <string.h> 	// for memcpy

/******************************************************************************
* Applies ShiftRows^(-1) on a round key to match the fixsliced representation.
******************************************************************************/
static void inv_shiftrows_1(uint32_t* rkey) {
	uint32_t tmp;
	for(int i = 0; i < 8; i++) {
		SWAPMOVE(rkey[i], rkey[i], 0x0c0f0300, 4);
		SWAPMOVE(rkey[i], rkey[i], 0x33003300, 2);
	}
}
/******************************************************************************
* Applies ShiftRows^(-2) on a round key to match the fixsliced representation.
******************************************************************************/
static void inv_shiftrows_2(uint32_t* rkey) {
	uint32_t tmp;
	for(int i = 0; i < 8; i++)
		SWAPMOVE(rkey[i], rkey[i], 0x0f000f00, 4);
}

/******************************************************************************
* Applies ShiftRows^(-3) on a round key to match the fixsliced representation.
******************************************************************************/
static void inv_shiftrows_3(uint32_t* rkey) {
	uint32_t tmp;
	for(int i = 0; i < 8; i++) {
		SWAPMOVE(rkey[i], rkey[i], 0x030f0c00, 4);
		SWAPMOVE(rkey[i], rkey[i], 0x33003300, 2);
	}
}

/******************************************************************************
* XOR the columns after the S-box during the key schedule round function.
* Note that the NOT omitted in the S-box calculations have to be applied t
* ensure output correctness.
* The idx_ror parameter refers to the index of the previous round key that is
* involved in the XOR computation (should be 8 and 16 for AES-128 and AES-256,
* respectively).
* The idx_ror parameter refers to the rotation value. When a Rotword is applied
* the value should be 2, 26 otherwise.
******************************************************************************/
static void xor_columns(uint32_t* rkeys, int idx_xor, int idx_ror) {
	rkeys[1] ^= 0xffffffff; 			// NOT that are omitted in S-box
	rkeys[2] ^= 0xffffffff; 			// NOT that are omitted in S-box
	rkeys[6] ^= 0xffffffff; 			// NOT that are omitted in S-box
	rkeys[7] ^= 0xffffffff; 			// NOT that are omitted in S-box
	for(int i = 0; i < 8; i++) {
		rkeys[i] = (rkeys[i-idx_xor] ^ ROR(rkeys[i], idx_ror))  & 0xc0c0c0c0;
		rkeys[i] |= ((rkeys[i-idx_xor] ^ rkeys[i] >> 2) & 0x30303030);
		rkeys[i] |= ((rkeys[i-idx_xor] ^ rkeys[i] >> 2) & 0x0c0c0c0c);
		rkeys[i] |= ((rkeys[i-idx_xor] ^ rkeys[i] >> 2) & 0x03030303);
	}
}



/******************************************************************************
* Bitsliced implementation of the AES Sbox based on Boyar, Peralta and Calik.
* See http://www.cs.yale.edu/homes/peralta/CircuitStuff/SLP_AES_113.txt
* Note that the 4 NOT (^= 0xffffffff) are moved to the key schedule.
******************************************************************************/
static void _sbox(uint32_t* state) {
	uint32_t t0, t1, t2, t3, t4, t5,
		t6, t7, t8, t9, t10, t11, t12,
		t13, t14, t15, t16, t17;
	t0			= state[3] ^ state[5];
	t1			= state[0] ^ state[6];
	t2			= t1 ^ t0;
	t3			= state[4] ^ t2;
	t4			= t3 ^ state[5];
	t5			= t2 & t4;
	t6			= t4 ^ state[7];
	t7			= t3 ^ state[1];
	t8			= state[0] ^ state[3]; 
	t9			= t7 ^ t8;
	t10			= t8 & t9;
	t11			= state[7] ^ t9; 
	t12			= state[0] ^ state[5];
	t13			= state[1] ^ state[2];
	t14			= t4 ^ t13;
	t15			= t14 ^ t9;
	t16			= t0 & t15;
	t17			= t16 ^ t10;
	state[1]	= t14 ^ t12; 
	state[2]	= t12 & t14;
	state[2] 	^= t10;
	state[4]	= t13 ^ t9;
	state[5]	= t1 ^ state[4];
	t3			= t1 & state[4];
	t10			= state[0] ^ state[4];
	t13 		^= state[7];
	state[3] 	^= t13; 
	t16			= state[3] & state[7];
	t16 		^= t5;
	t16 		^= state[2];
	state[1] 	^= t16;
	state[0] 	^= t13;
	t16			= state[0] & t11;
	t16 		^= t3;
	state[2] 	^= t16;
	state[2] 	^= t10;
	state[6] 	^= t13;
	t10			= state[6] & t13;
	t3 			^= t10;
	t3 			^= t17;
	state[5] 	^= t3;
	t3			= state[6] ^ t12;
	t10			= t3 & t6;
	t5 			^= t10;
	t5 			^= t7;
	t5 			^= t17;
	t7			= t5 & state[5];
	t10			= state[2] ^ t7;
	t7 			^= state[1];
	t5 			^= state[1];
	t16			= t5 & t10;
	state[1] 	^= t16;
	t17			= state[1] & state[0];
	t11			= state[1] & t11;
	t16			= state[5] ^ state[2];
	t7 			&= t16;
	t7 			^= state[2];
	t16			= t10 ^ t7;
	state[2] 	&= t16;
	t10 		^= state[2];
	t10 		&= state[1];
	t5 			^= t10;
	t10			= state[1] ^ t5;
	state[4] 	&= t10; 
	t11 		^= state[4];
	t1 			&= t10;
	state[6] 	&= t5; 
	t10			= t5 & t13;
	state[4] 	^= t10;
	state[5] 	^= t7;
	state[2] 	^= state[5];
	state[5]	= t5 ^ state[2];
	t5			= state[5] & t14;
	t10			= state[5] & t12;
	t12			= t7 ^ state[2];
	t4 			&= t12;
	t2 			&= t12;
	t3 			&= state[2]; 
	state[2] 	&= t6;
	state[2] 	^= t4;
	t13			= state[4] ^ state[2];
	state[3] 	&= t7;
	state[1] 	^= t7;
	state[5] 	^= state[1];
	t6			= state[5] & t15;
	state[4] 	^= t6; 
	t0 			&= state[5];
	state[5]	= state[1] & t9; 
	state[5] 	^= state[4];
	state[1] 	&= t8;
	t6			= state[1] ^ state[5];
	t0 			^= state[1];
	state[1]	= t3 ^ t0;
	t15			= state[1] ^ state[3];
	t2 			^= state[1];
	state[0]	= t2 ^ state[5];
	state[3]	= t2 ^ t13;
	state[1]	= state[3] ^ state[5];
	//state[1] 	^= 0xffffffff;
	t0 			^= state[6];
	state[5]	= t7 & state[7];
	t14			= t4 ^ state[5];
	state[6]	= t1 ^ t14;
	state[6] 	^= t5; 
	state[6] 	^= state[4];
	state[2]	= t17 ^ state[6];
	state[5]	= t15 ^ state[2];
	state[2] 	^= t6;
	state[2] 	^= t10;
	//state[2] 	^= 0xffffffff;
	t14 		^= t11;
	t0 			^= t14;
	state[6] 	^= t0;
	//state[6] 	^= 0xffffffff;
	state[7]	= t1 ^ t0;
	//state[7] 	^= 0xffffffff;
	state[4]	= t14 ^ state[3]; 
}



/******************************************************************************
* Fully bitsliced AES-256 key schedule to match the fully-fixsliced (ffs)
* representation. Note that it is possible to pass two different keys as input
* parameters if one wants to encrypt 2 blocks with two different keys.
******************************************************************************/
void _aes256_keyschedule_ffs(uint32_t* rkeys, const unsigned char* key0,
						const unsigned char* key1) {
	_packing(rkeys, key0, key1); 		// packs the keys into the bitsliced state
	_packing(rkeys+8, key0+16, key1+16); // packs the keys into the bitsliced state
	memcpy(rkeys+16, rkeys+8, 32);
	_sbox(rkeys+16);
	rkeys[23] ^= 0x00000300; 			// 1st rconst
	xor_columns(rkeys+16, 16, 2);  		// Rotword and XOR between the columns
	memcpy(rkeys+24, rkeys+16, 32);
	_sbox(rkeys+24);
	xor_columns(rkeys+24, 16, 26); 		// XOR between the columns
	inv_shiftrows_1(rkeys+8);			// to match fixslicing
	memcpy(rkeys+32, rkeys+24, 32);
	_sbox(rkeys+32);
	rkeys[38] ^= 0x00000300; 			// 2nd rconst
	xor_columns(rkeys+32, 16, 2); 		// Rotword and XOR between the columns
	inv_shiftrows_2(rkeys+16); 			// to match fixslicing
	memcpy(rkeys+40, rkeys+32, 32);	
	_sbox(rkeys+40);
	xor_columns(rkeys+40, 16, 26); 		// XOR between the columns
	inv_shiftrows_3(rkeys+24); 			// to match fixslicing
	memcpy(rkeys+48, rkeys+40, 32);
	_sbox(rkeys+48);
	rkeys[53] ^= 0x00000300; 			// 3rd rconst
	xor_columns(rkeys+48, 16, 2); 		// Rotword and XOR between the columns
	memcpy(rkeys+56, rkeys+48, 32);
	_sbox(rkeys+56);
	xor_columns(rkeys+56, 16, 26); 		// XOR between the columns
	inv_shiftrows_1(rkeys+40);			// to match fixslicing
	memcpy(rkeys+64, rkeys+56, 32);
	_sbox(rkeys+64);
	rkeys[68] ^= 0x00000300; 			// 4th rconst
	xor_columns(rkeys+64, 16, 2); 		// Rotword and XOR between the columns
	inv_shiftrows_2(rkeys+48); 			// to match fixslicing
	memcpy(rkeys+72, rkeys+64, 32);	
	_sbox(rkeys+72);
	xor_columns(rkeys+72, 16, 26); 		// XOR between the columns
	inv_shiftrows_3(rkeys+56); 			// to match fixslicing
	memcpy(rkeys+80, rkeys+72, 32);
	_sbox(rkeys+80);
	rkeys[83] ^= 0x00000300; 			// 5th rconst
	xor_columns(rkeys+80, 16, 2); 		// Rotword and XOR between the columns
	memcpy(rkeys+88, rkeys+80, 32);
	_sbox(rkeys+88);
	xor_columns(rkeys+88, 16, 26); 		// XOR between the columns
	inv_shiftrows_1(rkeys+72);			// to match fixslicing
	memcpy(rkeys+96, rkeys+88, 32);
	_sbox(rkeys+96);
	rkeys[98] ^= 0x00000300; 			// 6th rconst
	xor_columns(rkeys+96, 16, 2); 		// Rotword and XOR between the columns
	inv_shiftrows_2(rkeys+80); 			// to match fixslicing
	memcpy(rkeys+104, rkeys+96, 32);	
	_sbox(rkeys+104);
	xor_columns(rkeys+104, 16, 26); 	// XOR between the columns
	inv_shiftrows_3(rkeys+88); 			// to match fixslicing
	memcpy(rkeys+112, rkeys+104, 32);
	_sbox(rkeys+112);
	rkeys[113] ^= 0x00000300; 			// 7th rconst
	xor_columns(rkeys+112, 16, 2); 		// Rotword and XOR between the columns
	inv_shiftrows_1(rkeys+104);			// to match fixslicing
	for(int i = 1; i < 15; i++) {
		rkeys[i*8 + 1] ^= 0xffffffff; 	// NOT to speed up SBox calculations
		rkeys[i*8 + 2] ^= 0xffffffff; 	// NOT to speed up SBox calculations
		rkeys[i*8 + 6] ^= 0xffffffff; 	// NOT to speed up SBox calculations
		rkeys[i*8 + 7] ^= 0xffffffff; 	// NOT to speed up SBox calculations
	}
}




