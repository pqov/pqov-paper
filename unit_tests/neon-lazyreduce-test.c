

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "api.h"

#include "benchmark.h"


#include "gf16_neon.h"
#include "blas_neon.h"


#include <arm_neon.h>


uint8x16_t multabs[128*2];
uint8_t mat[128*128];
uint8_t b[128];
uint8_t c0[128];
uint8_t c1[128];


void test_1_0(void)
{
  gf16v_generate_multabs_neon( (uint8_t *)multabs, b , 32 );
}

void test_1_3(void)
{
  // gf16 32x32 normal mul
  uint8x16_t r = vdupq_n_u8(0);
  uint8_t * ptr = mat;
  for(int i=0;i<16;i++) {
    r ^= gf16v_mul_neon( vld1q_u8(ptr) , b[i]&0xf ); ptr+=16;
    r ^= gf16v_mul_neon( vld1q_u8(ptr) , b[i]>>4 ); ptr+=16;
  }
  vst1q_u8( c0 , r );
}

void test_1_1(void)
{
  // gf16 32x32 mat-vec with multab
  uint8x16_t mask_f = vdupq_n_u8(0xf);
  uint8x16_t r = vdupq_n_u8(0);

  for(int i=0;i<32;i++) {
    r ^= _gf16_tbl_x2( vld1q_u8(mat+16*i) , multabs[i] , mask_f );
  }
  vst1q_u8( c0 , r );
}

void test_1_2(void)
{
  // gf16 32x32 mat-vec laze reduce
  uint8x16_t mask_f = vdupq_n_u8(0xf);
  uint8x16_t mask_3 = vdupq_n_u8(3);
  uint8x16_t rl = vdupq_n_u8(0);
  uint8x16_t rh = vdupq_n_u8(0);

  for(int i=0;i<16;i++) {
    uint8x16_t b0 = vdupq_n_u8( b[i]&0xf );
    uint8x16_t b1 = vdupq_n_u8( b[i]>>4 );
    uint8x16_t col0 = vld1q_u8(mat+32*i);
    uint8x16_t col1 = vld1q_u8(mat+32*i+16);

    rl ^= vmulq_p8( col0&mask_f , b0 )^vmulq_p8( col1&mask_f , b1 );
    rh ^= vmulq_p8( vshrq_n_u8(col0,4) , b0 )^vmulq_p8( vshrq_n_u8(col1,4) , b1 );
  }
  vst1q_u8( c0 , _gf16v_reduce_pmul_neon(rl,rh,mask_3) );
}


void test_2_0(void)
{
  gf16v_generate_multabs_neon( (uint8_t *)multabs, b , 64 );
}

void test_2_3(void)
{
  // gf16 64x64 normal mul
  uint8x16_t r0 = vdupq_n_u8(0);
  uint8x16_t r1 = vdupq_n_u8(0);
  uint8_t * ptr = mat;
  for(int i=0;i<32;i++) {
    r0 ^= gf16v_mul_neon( vld1q_u8(ptr) , b[i]&0xf ); ptr+=16;
    r1 ^= gf16v_mul_neon( vld1q_u8(ptr) , b[i]&0xf ); ptr+=16;
    r0 ^= gf16v_mul_neon( vld1q_u8(ptr) , b[i]>>4 ); ptr+=16;
    r1 ^= gf16v_mul_neon( vld1q_u8(ptr) , b[i]>>4 ); ptr+=16;
  }
  vst1q_u8( c0 , r0 );
  vst1q_u8( c0+16 , r1 );
}


void test_2_1(void)
{
  // gf16 64x64 mat-vec with multab
  uint8x16_t mask_f = vdupq_n_u8(0xf);
  uint8x16_t r0 = vdupq_n_u8(0);
  uint8x16_t r1 = vdupq_n_u8(0);

  for(int i=0;i<64;i++) {
    r0 ^= _gf16_tbl_x2( vld1q_u8(mat+32*i) , multabs[i] , mask_f );
    r1 ^= _gf16_tbl_x2( vld1q_u8(mat+32*i+16) , multabs[i] , mask_f );
  }
  vst1q_u8( c0    , r0 );
  vst1q_u8( c0+16 , r1 );
}

void test_2_2(void)
{
  // gf16 64x64 mat-vec lazy reduce
  uint8x16_t mask_f = vdupq_n_u8(0xf);
  uint8x16_t mask_3 = vdupq_n_u8(3);
  uint8x16_t r0l = vdupq_n_u8(0);
  uint8x16_t r0h = vdupq_n_u8(0);
  uint8x16_t r1l = vdupq_n_u8(0);
  uint8x16_t r1h = vdupq_n_u8(0);


  for(int i=0;i<32;i++) {
    uint8x16_t b0 = vdupq_n_u8( b[i]&0xf );
    uint8x16_t b1 = vdupq_n_u8( b[i]>>4 );
    uint8x16_t col00 = vld1q_u8(mat+64*i);
    uint8x16_t col01 = vld1q_u8(mat+64*i+16);
    uint8x16_t col10 = vld1q_u8(mat+64*i+32);
    uint8x16_t col11 = vld1q_u8(mat+64*i+48);

    r0l ^= vmulq_p8( col00&mask_f , b0 )^vmulq_p8( col10&mask_f , b1 );
    r0h ^= vmulq_p8( vshrq_n_u8(col00,4) , b0 )^vmulq_p8( vshrq_n_u8(col10,4) , b1 );
    r1l ^= vmulq_p8( col01&mask_f , b0 )^vmulq_p8( col11&mask_f , b1 );
    r1h ^= vmulq_p8( vshrq_n_u8(col01,4) , b0 )^vmulq_p8( vshrq_n_u8(col11,4) , b1 );
  }
  vst1q_u8( c0    , _gf16v_reduce_pmul_neon(r0l,r0h,mask_3) );
  vst1q_u8( c0+16 , _gf16v_reduce_pmul_neon(r1l,r1h,mask_3) );
}



#define BLOCKLEN16  3

void test_7_0(void)
{
  gf16v_generate_multabs_neon( (uint8_t *)multabs, b , BLOCKLEN16*32 );
}

void test_7_1(void)
{
  // gf16 BLOCKLEN16*16 x BLOCKLEN16*16 mat-vec with multab
    uint8x16_t mask_f = vdupq_n_u8( 0xf );

    uint8x16_t r[BLOCKLEN16];
    for(int i=0;i<BLOCKLEN16;i++) r[i] = vdupq_n_u8(0);

    uint8_t * ptr = mat;
    for( int i=0;i<BLOCKLEN16*32;i++ ) {
        for( int j=0;j<BLOCKLEN16; j++) {
            r[j] ^= _gf16_tbl_x2(vld1q_u8(ptr),multabs[i],mask_f); ptr += 16;
        }
    }
    for( int j=0;j<BLOCKLEN16; j++) { vst1q_u8( c0+j*16 , r[j] ); }
}

void test_7_3(void)
{
  // gf16 BLOCKLEN16*16 x BLOCKLEN16*16 mat-vec with multab
  uint8x16_t r[BLOCKLEN16];
  for(int i=0;i<BLOCKLEN16;i++) r[i] = vdupq_n_u8(0);

  uint8_t * ptr = mat;
  for( int i=0;i<BLOCKLEN16*16;i++ ) {
    uint8_t b0 = b[i]&0xf;
    uint8_t b1 = b[i]>>4;
    for(int j=0;j<BLOCKLEN16;j++) {
        r[j]   ^= gf16v_mul_neon( vld1q_u8(ptr) , b0 );  ptr += 16;
    }
    for(int j=0;j<BLOCKLEN16;j++) {
        r[j]   ^= gf16v_mul_neon( vld1q_u8(ptr) , b1 );  ptr += 16;
    }
  }
  for( int j=0;j<BLOCKLEN16; j++) { vst1q_u8( c0+j*16 , r[j] ); }
}

void test_7_2(void)
{
  uint8x16_t mask_f = vdupq_n_u8(0xf);
  uint8x16_t mask_3 = vdupq_n_u8(3);
  // gf16 BLOCKLEN16*16 x BLOCKLEN16*16 mat-vec lazy reduce
    uint8x16_t r0[BLOCKLEN16*2];
    for(int i=0;i<BLOCKLEN16*2;i++) r0[i] = vdupq_n_u8(0);
    
    uint8_t * ptr = mat;
  for(int i=0;i<BLOCKLEN16*16;i++) {
    uint8x16_t b0 = vdupq_n_u8( b[i]&0xf );
    uint8x16_t b1 = vdupq_n_u8( b[i]>>4 );

    for(int j=0;j<BLOCKLEN16;j++) {
        uint8x16_t cc = vld1q_u8(ptr); ptr += 16;
        r0[j*2]   ^= vmulq_p8( cc&mask_f , b0 );
        r0[j*2+1] ^= vmulq_p8( vshrq_n_u8(cc,4) , b0 );
    }
    for(int j=0;j<BLOCKLEN16;j++) {
        uint8x16_t cc = vld1q_u8(ptr); ptr += 16;
        r0[j*2]   ^= vmulq_p8( cc&mask_f , b1 );
        r0[j*2+1] ^= vmulq_p8( vshrq_n_u8(cc,4) , b1 );
    }
  }
  for(int j=0;j<BLOCKLEN16;j++) {
    vst1q_u8( c0+j*16    , _gf16v_reduce_pmul_neon(r0[j*2],r0[j*2+1],mask_3) );
  }
}










void test_3_0(void)
{
  gf256v_generate_multabs_neon( (uint8_t *)multabs, b , 32 );
}

void test_3_1(void)
{
  // gf256 32x32 mat-vec with multab
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t r0 = vdupq_n_u8(0);
    uint8x16_t r1 = vdupq_n_u8(0);
    uint8_t * ptr = mat;
    for( int i=0;i<32;i++ ) {
        uint8x16_t tab0 = multabs[i*2];
        uint8x16_t tab1 = multabs[i*2+1];
        uint8x16_t c0 = vld1q_u8(ptr); ptr += 16;
        uint8x16_t c1 = vld1q_u8(ptr); ptr += 16;
        r0 ^= _gf256_tbl(c0,tab0,tab1,mask_f);
        r1 ^= _gf256_tbl(c1,tab0,tab1,mask_f);
    }
    vst1q_u8(c0    , r0);
    vst1q_u8(c0+16 , r1);
}

void test_3_2(void)
{
  // gf256 32x32 mat-vec lazy reduce
  uint8x16_t r0l = vdupq_n_u8(0);
  uint8x16_t r0h = vdupq_n_u8(0);
  uint8x16_t r1l = vdupq_n_u8(0);
  uint8x16_t r1h = vdupq_n_u8(0);

  for(int i=0;i<32;i++) {
    uint8x16_t bb = vdupq_n_u8(b[i]);

    uint8x16_t col0 = vld1q_u8(mat+32*i);
    uint8x16_t col1 = vld1q_u8(mat+32*i+16);

    r0l ^= vmull_p8( vget_low_p8(col0) , vget_low_p8(bb) );
    r0h ^= vmull_high_p8( col0 , bb );
    r1l ^= vmull_p8( vget_low_p8(col1) , vget_low_p8(bb) );
    r1h ^= vmull_high_p8( col1 , bb );
  }
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t tab_rd0 = vld1q_u8(__gf256_bit8_11_reduce);
    uint8x16_t tab_rd1 = vld1q_u8(__gf256_bit12_15_reduce);

  vst1q_u8( c0    , _gf256v_reduce_tbl_neon( r0l , r0h , mask_f , tab_rd0 , tab_rd1 ) );
  vst1q_u8( c0+16 , _gf256v_reduce_tbl_neon( r1l , r1h , mask_f , tab_rd0 , tab_rd1 ) );
}



void test_4_0(void)
{
  gf256v_generate_multabs_neon( (uint8_t *)multabs, b , 64 );
}

void test_4_3(void)
{
  // gf256 BLOCKLEN*16 x BLOCKLEN*16 mat-vec with multab
    uint8x16_t r[4];
    for(int i=0;i<4;i++) r[i] = vdupq_n_u8(0);

    uint8_t * ptr = mat;
    for( int i=0;i<4*16;i++ ) {
        for( int j=0;j<4; j++) {
            r[j] ^= gf256v_mul_neon(vld1q_u8(ptr),b[i]); ptr += 16;
        }
    }
    for( int j=0;j<4; j++) { vst1q_u8( c0+j*16 , r[j] ); }
}


void test_4_1(void)
{
  // gf256 64x64 mat-vec with multab
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t r0 = vdupq_n_u8(0);
    uint8x16_t r1 = vdupq_n_u8(0);
    uint8x16_t r2 = vdupq_n_u8(0);
    uint8x16_t r3 = vdupq_n_u8(0);
    uint8_t * ptr = mat;
    for( int i=0;i<64;i++ ) {
        uint8x16_t tab0 = multabs[i*2];
        uint8x16_t tab1 = multabs[i*2+1];

        uint8x16_t c0 = vld1q_u8(ptr); ptr += 16;
        uint8x16_t c1 = vld1q_u8(ptr); ptr += 16;
        uint8x16_t c2 = vld1q_u8(ptr); ptr += 16;
        uint8x16_t c3 = vld1q_u8(ptr); ptr += 16;
        r0 ^= _gf256_tbl(c0,tab0,tab1,mask_f);
        r1 ^= _gf256_tbl(c1,tab0,tab1,mask_f);
        r2 ^= _gf256_tbl(c2,tab0,tab1,mask_f);
        r3 ^= _gf256_tbl(c3,tab0,tab1,mask_f);
    }
    vst1q_u8(c0    , r0);
    vst1q_u8(c0+16 , r1);
    vst1q_u8(c0+32 , r2);
    vst1q_u8(c0+48 , r3);
}

void test_4_2(void)
{
  // gf256 64x64 mat-vec lazy reduce
  uint8x16_t r0l = vdupq_n_u8(0);
  uint8x16_t r0h = vdupq_n_u8(0);
  uint8x16_t r1l = vdupq_n_u8(0);
  uint8x16_t r1h = vdupq_n_u8(0);
  uint8x16_t r2l = r0l;
  uint8x16_t r2h = r0l;
  uint8x16_t r3l = r0l;
  uint8x16_t r3h = r0l;

  for(int i=0;i<64;i++) {
    uint8x16_t bb = vdupq_n_u8(b[i]);

    uint8x16_t col0 = vld1q_u8(mat+64*i);
    uint8x16_t col1 = vld1q_u8(mat+64*i+16);
    uint8x16_t col2 = vld1q_u8(mat+64*i+32);
    uint8x16_t col3 = vld1q_u8(mat+64*i+48);

    r0l ^= vmull_p8( vget_low_p8(col0) , vget_low_p8(bb) );
    r0h ^= vmull_high_p8( col0 , bb );
    r1l ^= vmull_p8( vget_low_p8(col1) , vget_low_p8(bb) );
    r1h ^= vmull_high_p8( col1 , bb );
    r2l ^= vmull_p8( vget_low_p8(col2) , vget_low_p8(bb) );
    r2h ^= vmull_high_p8( col2 , bb );
    r3l ^= vmull_p8( vget_low_p8(col3) , vget_low_p8(bb) );
    r3h ^= vmull_high_p8( col3 , bb );
  }
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t tab_rd0 = vld1q_u8(__gf256_bit8_11_reduce);
    uint8x16_t tab_rd1 = vld1q_u8(__gf256_bit12_15_reduce);

  vst1q_u8( c0    , _gf256v_reduce_tbl_neon( r0l , r0h , mask_f , tab_rd0 , tab_rd1 ) );
  vst1q_u8( c0+16 , _gf256v_reduce_tbl_neon( r1l , r1h , mask_f , tab_rd0 , tab_rd1 ) );
  vst1q_u8( c0+32 , _gf256v_reduce_tbl_neon( r2l , r2h , mask_f , tab_rd0 , tab_rd1 ) );
  vst1q_u8( c0+48 , _gf256v_reduce_tbl_neon( r3l , r3h , mask_f , tab_rd0 , tab_rd1 ) );
}


void test_5_0(void)
{
  gf256v_generate_multabs_neon( (uint8_t *)multabs, b , 96 );
}

void test_5_3(void)
{
  // gf256 BLOCKLEN*16 x BLOCKLEN*16 mat-vec with multab
    uint8x16_t r[6];
    for(int i=0;i<6;i++) r[i] = vdupq_n_u8(0);

    uint8_t * ptr = mat;
    for( int i=0;i<6*16;i++ ) {
        for( int j=0;j<6; j++) {
            r[j] ^= gf256v_mul_neon(vld1q_u8(ptr),b[i]); ptr += 16;
        }
    }
    for( int j=0;j<6; j++) { vst1q_u8( c0+j*16 , r[j] ); }
}


void test_5_1(void)
{
  // gf256 96x96 mat-vec with multab
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t r0 = vdupq_n_u8(0);
    uint8x16_t r1 = vdupq_n_u8(0);
    uint8x16_t r2 = vdupq_n_u8(0);
    uint8x16_t r3 = vdupq_n_u8(0);
    uint8x16_t r4 = r0;
    uint8x16_t r5 = r0;
    uint8_t * ptr = mat;
    for( int i=0;i<96;i++ ) {
        uint8x16_t tab0 = multabs[i*2];
        uint8x16_t tab1 = multabs[i*2+1];

        uint8x16_t c0 = vld1q_u8(ptr); ptr += 16;
        uint8x16_t c1 = vld1q_u8(ptr); ptr += 16;
        uint8x16_t c2 = vld1q_u8(ptr); ptr += 16;
        uint8x16_t c3 = vld1q_u8(ptr); ptr += 16;
        uint8x16_t c4 = vld1q_u8(ptr); ptr += 16;
        uint8x16_t c5 = vld1q_u8(ptr); ptr += 16;

        r0 ^= _gf256_tbl(c0,tab0,tab1,mask_f);
        r1 ^= _gf256_tbl(c1,tab0,tab1,mask_f);
        r2 ^= _gf256_tbl(c2,tab0,tab1,mask_f);
        r3 ^= _gf256_tbl(c3,tab0,tab1,mask_f);
        r4 ^= _gf256_tbl(c4,tab0,tab1,mask_f);
        r5 ^= _gf256_tbl(c5,tab0,tab1,mask_f);
    }
    vst1q_u8(c0    , r0);
    vst1q_u8(c0+16 , r1);
    vst1q_u8(c0+32 , r2);
    vst1q_u8(c0+48 , r3);
    vst1q_u8(c0+64 , r4);
    vst1q_u8(c0+80 , r5);
}

void test_5_2(void)
{
  // gf256 96x96 mat-vec lazy reduce
  uint8x16_t r0l = vdupq_n_u8(0);
  uint8x16_t r0h = vdupq_n_u8(0);
  uint8x16_t r1l = vdupq_n_u8(0);
  uint8x16_t r1h = vdupq_n_u8(0);
  uint8x16_t r2l = r0l;
  uint8x16_t r2h = r0l;
  uint8x16_t r3l = r0l;
  uint8x16_t r3h = r0l;
  uint8x16_t r4l = r0l;
  uint8x16_t r4h = r0l;
  uint8x16_t r5l = r0l;
  uint8x16_t r5h = r0l;

    uint8_t * ptr = mat;
  for(int i=0;i<96;i++) {
    uint8x16_t bb = vdupq_n_u8(b[i]);
        uint8x16_t c0 = vld1q_u8(ptr); ptr += 16;
        uint8x16_t c1 = vld1q_u8(ptr); ptr += 16;
        uint8x16_t c2 = vld1q_u8(ptr); ptr += 16;
        uint8x16_t c3 = vld1q_u8(ptr); ptr += 16;
        uint8x16_t c4 = vld1q_u8(ptr); ptr += 16;
        uint8x16_t c5 = vld1q_u8(ptr); ptr += 16;

    r0l ^= vmull_p8( vget_low_p8(c0) , vget_low_p8(bb) );
    r0h ^= vmull_high_p8( c0 , bb );
    r1l ^= vmull_p8( vget_low_p8(c1) , vget_low_p8(bb) );
    r1h ^= vmull_high_p8( c1 , bb );
    r2l ^= vmull_p8( vget_low_p8(c2) , vget_low_p8(bb) );
    r2h ^= vmull_high_p8( c2 , bb );
    r3l ^= vmull_p8( vget_low_p8(c3) , vget_low_p8(bb) );
    r3h ^= vmull_high_p8( c3 , bb );
    r4l ^= vmull_p8( vget_low_p8(c4) , vget_low_p8(bb) );
    r4h ^= vmull_high_p8( c4 , bb );
    r5l ^= vmull_p8( vget_low_p8(c5) , vget_low_p8(bb) );
    r5h ^= vmull_high_p8( c5 , bb );
  }
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t tab_rd0 = vld1q_u8(__gf256_bit8_11_reduce);
    uint8x16_t tab_rd1 = vld1q_u8(__gf256_bit12_15_reduce);

  vst1q_u8( c0    , _gf256v_reduce_tbl_neon( r0l , r0h , mask_f , tab_rd0 , tab_rd1 ) );
  vst1q_u8( c0+16 , _gf256v_reduce_tbl_neon( r1l , r1h , mask_f , tab_rd0 , tab_rd1 ) );
  vst1q_u8( c0+32 , _gf256v_reduce_tbl_neon( r2l , r2h , mask_f , tab_rd0 , tab_rd1 ) );
  vst1q_u8( c0+48 , _gf256v_reduce_tbl_neon( r3l , r3h , mask_f , tab_rd0 , tab_rd1 ) );
  vst1q_u8( c0+64 , _gf256v_reduce_tbl_neon( r4l , r4h , mask_f , tab_rd0 , tab_rd1 ) );
  vst1q_u8( c0+80 , _gf256v_reduce_tbl_neon( r5l , r5h , mask_f , tab_rd0 , tab_rd1 ) );
}



// On mac M1
// BLOCKLEN 3
// test_6_0: 292 (cycles, avg. of 10240): 293 291 292 292 292 289
// test_6_1: 269 (cycles, avg. of 10240): 268 268 267 269 268 270
// test_6_2: 279 (cycles, avg. of 10240): 278 277 277 279 279 277
//
// BLOCKLEN 4
// test_6_0: 359 (cycles, avg. of 10240): 352 356 356 356 357 354
// test_6_1: 412 (cycles, avg. of 10240): 407 409 408 408 408 408
// test_6_2: 1607 (cycles, avg. of 10240): 1759 1682 1636 1626 1712 1593
//
// test_4_0 : 363 (cycles, avg. of 10240): 360 362 358 359 356 361
// test_4_1 : 412 (cycles, avg. of 10240): 407 408 408 407 408 409
// test_4_2 : 401 (cycles, avg. of 10240): 399 397 397 397 396 398
//

#define BLOCKLEN  3

void test_6_0(void)
{
  gf256v_generate_multabs_neon( (uint8_t *)multabs, b , BLOCKLEN*16 );
}

void test_6_3(void)
{
  // gf256 BLOCKLEN*16 x BLOCKLEN*16 mat-vec with multab
    uint8x16_t r[BLOCKLEN];
    for(int i=0;i<BLOCKLEN;i++) r[i] = vdupq_n_u8(0);

    uint8_t * ptr = mat;
    for( int i=0;i<BLOCKLEN*16;i++ ) {
        for( int j=0;j<BLOCKLEN; j++) {
            r[j] ^= gf256v_mul_neon(vld1q_u8(ptr),b[i]); ptr += 16;
        }
    }
    for( int j=0;j<BLOCKLEN; j++) { vst1q_u8( c0+j*16 , r[j] ); }
}

void test_6_1(void)
{
  // gf256 BLOCKLEN*16 x BLOCKLEN*16 mat-vec with multab
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t r[BLOCKLEN];
    for(int i=0;i<BLOCKLEN;i++) r[i] = vdupq_n_u8(0);

    uint8_t * ptr = mat;
    for( int i=0;i<BLOCKLEN*16;i++ ) {
        uint8x16_t tab0 = multabs[i*2];
        uint8x16_t tab1 = multabs[i*2+1];

        for( int j=0;j<BLOCKLEN; j++) {
            r[j] ^= _gf256_tbl(vld1q_u8(ptr),tab0,tab1,mask_f); ptr += 16;
        }
    }
    for( int j=0;j<BLOCKLEN; j++) { vst1q_u8( c0+j*16 , r[j] ); }
}

void test_6_2(void)
{
  // gf256 BLOCKLEN*16 x BLOCKLEN*16 mat-vec lazy reduce
    uint8x16_t r0[BLOCKLEN*2];
    //uint8x16_t r1[BLOCKLEN];
    for(int i=0;i<BLOCKLEN*2;i++) r0[i] = vdupq_n_u8(0);
    //for(int i=0;i<BLOCKLEN;i++) r1[i] = vdupq_n_u8(0);

    uint8_t * ptr = mat;
  for(int i=0;i<BLOCKLEN*16;i++) {
    uint8x16_t bb = vdupq_n_u8(b[i]);

    for(int j=0;j<BLOCKLEN;j++) {
        uint8x16_t cc = vld1q_u8(ptr); ptr += 16;
        r0[j*2]   ^= vmull_p8( vget_low_p8(cc) , vget_low_p8(bb) );
        r0[j*2+1] ^= vmull_high_p8( cc , bb );
        //r1[j] ^= vmull_high_p8( cc , bb );
    }
  }
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t tab_rd0 = vld1q_u8(__gf256_bit8_11_reduce);
    uint8x16_t tab_rd1 = vld1q_u8(__gf256_bit12_15_reduce);

  for(int j=0;j<BLOCKLEN;j++) {
    vst1q_u8( c0+j*16    , _gf256v_reduce_tbl_neon( r0[j*2] , r0[j*2+1] , mask_f , tab_rd0 , tab_rd1 ) );
//    vst1q_u8( c0+j*16    , _gf256v_reduce_tbl_neon( r0[j] , r1[j] , mask_f , tab_rd0 , tab_rd1 ) );
  }
}





#include "stdio.h"
#include "stdlib.h"


int main(int argc, char** argv)
{
	for(int i=128-1;i>=0;i--)     b[i]=rand();
	for(int i=128*128-1;i>=0;i--) mat[i]=rand();


	struct benchmark bm1,bm2,bm3, bm4,bm5,bm6;
	bm_init(&bm1);
	bm_init(&bm2);
	bm_init(&bm3);
	bm_init(&bm4);
	bm_init(&bm5);
	bm_init(&bm6);


#if 1
// gf256
	for(int i=10240;i>0;i--) {
	test_6_0();
BENCHMARK( bm1 , {
	test_6_1();
} );
BENCHMARK( bm2 , {
	test_6_2();
} );
BENCHMARK( bm3 , {
	test_6_3();
} );
BENCHMARK( bm4 , {
	test_4_1();
} );
BENCHMARK( bm5 , {
	test_4_2();
} );
BENCHMARK( bm6 , {
	test_4_3();
} );
	}
#else
// gf16
	for(int i=10240;i>0;i--) {
	test_7_0();
BENCHMARK( bm1 , {
	test_7_1();
} );
BENCHMARK( bm2 , {
	test_7_2();
} );
BENCHMARK( bm3 , {
	test_7_3();
} );
BENCHMARK( bm4 , {
	test_2_1();
} );
BENCHMARK( bm5 , {
	test_2_2();
} );
BENCHMARK( bm6 , {
	test_2_3();
} );
	}
#endif

	char msg[256];

	bm_dump(msg,256,&bm1);
	printf("bm0 : %s\n\n", msg );

	bm_dump(msg,256,&bm2);
	printf("bm1  : %s\n\n", msg );

	bm_dump(msg,256,&bm3);
	printf("bm2 : %s\n\n", msg );

	bm_dump(msg,256,&bm4);
	printf("bm4: %s\n\n", msg );

	bm_dump(msg,256,&bm5);
	printf("bm5: %s\n\n", msg );

	bm_dump(msg,256,&bm6);
	printf("bm6: %s\n\n", msg );

    (void)argc;
    (void)argv;
	return 0;
}

