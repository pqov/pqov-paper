

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
uint8_t c2[128];





// On mac M1
// BLOCKLEN 3


#define BLOCKLEN  3

void test_6_0( unsigned w )
{
  gf256v_generate_multabs_neon( (uint8_t *)multabs, b , w );
}




void gf256mat_block3_prod_multab(uint8_t *c, const uint8_t * mat , unsigned mat_vec_len ,
       const uint8_t * multabs , unsigned mat_n_vec );

void gf256mat_block3_prod_lazy(uint8_t *c, const uint8_t * mat , unsigned mat_vec_len ,
       const uint8_t * b , unsigned mat_n_vec );

void gf256mat_block4_prod_multab(uint8_t *c, const uint8_t * mat , unsigned mat_vec_len ,
       const uint8_t * multabs , unsigned mat_n_vec );

void gf256mat_block4_prod_lazy(uint8_t *c, const uint8_t * mat , unsigned mat_vec_len ,
       const uint8_t * b , unsigned mat_n_vec );



#define HAS_M3
#define HAS_M4
#define HAS_Z3
#define HAS_Z4


#if defined(HAS_M3)

void gf256mat_block3_prod_multab(uint8_t *c, const uint8_t * mat , unsigned mat_vec_len ,
       const uint8_t * multabs , unsigned mat_n_vec )
{
  if( 0==mat_n_vec ) { memset(c,0,48); return; }
  // gf256 BLOCKLEN*16 x BLOCKLEN*16 mat-vec with multab
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    const uint8x16_t * tab = (const uint8x16_t*)multabs;

    uint8x16_t r0,r1,r2;
    const uint8_t * ptr = mat;
    uint8x16_t tab0 = tab[0];
    uint8x16_t tab1 = tab[1];  tab += 2;
    r0 = _gf256_tbl(vld1q_u8(ptr   ),tab0,tab1,mask_f);
    r1 = _gf256_tbl(vld1q_u8(ptr+16),tab0,tab1,mask_f);
    r2 = _gf256_tbl(vld1q_u8(ptr+32),tab0,tab1,mask_f);
    ptr += mat_vec_len;
    while(--mat_n_vec) {
       uint8x16_t tab0 = tab[0];
       uint8x16_t tab1 = tab[1];  tab += 2;
       r0 ^= _gf256_tbl(vld1q_u8(ptr   ),tab0,tab1,mask_f);
       r1 ^= _gf256_tbl(vld1q_u8(ptr+16),tab0,tab1,mask_f);
       r2 ^= _gf256_tbl(vld1q_u8(ptr+32),tab0,tab1,mask_f);
       ptr += mat_vec_len;
    }
    vst1q_u8( c    , r0 );
    vst1q_u8( c+16 , r1 );
    vst1q_u8( c+32 , r2 );
}

#endif


#if defined(HAS_M4)

void gf256mat_block4_prod_multab(uint8_t *c, const uint8_t * mat , unsigned mat_vec_len ,
       const uint8_t * multabs , unsigned mat_n_vec )
{
  if( 0==mat_n_vec ) { memset(c,0,64); return; }
  // gf256 BLOCKLEN*16 x BLOCKLEN*16 mat-vec with multab
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    const uint8x16_t * tab = (const uint8x16_t*)multabs;

    uint8x16_t r0,r1,r2,r3;
    const uint8_t * ptr = mat;
    uint8x16_t tab0 = tab[0];
    uint8x16_t tab1 = tab[1];  tab += 2;
    r0 = _gf256_tbl(vld1q_u8(ptr   ),tab0,tab1,mask_f);
    r1 = _gf256_tbl(vld1q_u8(ptr+16),tab0,tab1,mask_f);
    r2 = _gf256_tbl(vld1q_u8(ptr+32),tab0,tab1,mask_f);
    r3 = _gf256_tbl(vld1q_u8(ptr+48),tab0,tab1,mask_f);
    ptr += mat_vec_len;
    while(--mat_n_vec) {
       uint8x16_t tab0 = tab[0];
       uint8x16_t tab1 = tab[1];  tab += 2;
       r0 ^= _gf256_tbl(vld1q_u8(ptr   ),tab0,tab1,mask_f);
       r1 ^= _gf256_tbl(vld1q_u8(ptr+16),tab0,tab1,mask_f);
       r2 ^= _gf256_tbl(vld1q_u8(ptr+32),tab0,tab1,mask_f);
       r3 ^= _gf256_tbl(vld1q_u8(ptr+48),tab0,tab1,mask_f);
       ptr += mat_vec_len;
    }
    vst1q_u8( c    , r0 );
    vst1q_u8( c+16 , r1 );
    vst1q_u8( c+32 , r2 );
    vst1q_u8( c+48 , r3 );
}

#endif


#if defined(HAS_Z3)

void gf256mat_block3_prod_lazy(uint8_t *c, const uint8_t * mat , unsigned mat_vec_len ,
       const uint8_t * b , unsigned mat_n_vec )
{
  if( 0==mat_n_vec ) { memset(c,0,48); return; }

  uint8x16_t rl0,rl1,rl2;
  uint8x16_t rh0,rh1,rh2;
  rl0 = vdupq_n_u8(0);
  rl1 = vdupq_n_u8(0);
  rl2 = vdupq_n_u8(0);
  rh0 = vdupq_n_u8(0);
  rh1 = vdupq_n_u8(0);
  rh2 = vdupq_n_u8(0);

  const uint8_t * ptr = mat;
  for(unsigned j=0;j<mat_n_vec;j++) {
        register uint8x16_t cc0 __asm__ ("v10") = vld1q_u8(ptr);
        register uint8x16_t cc1 __asm__ ("v11") = vld1q_u8(ptr+16);
        register uint8x16_t cc2 __asm__ ("v12") = vld1q_u8(ptr+32);  ptr += mat_vec_len;
        register uint8x16_t bb  __asm__ ("v9") = vld1q_dup_u8(b+j);
#if 1
        register uint8x16_t tmp0 __asm__("v13");
        //rl0 ^= vmull_p8( vget_low_p8(cc0) , vget_low_p8(bb) );
        __asm__ volatile ( "pmull   v13.8h, v10.8b , v9.8b"   : "=w"(tmp0) : "w"(cc0),"w"(bb) );
        __asm__ volatile ( "pmull2  v10.8h, v10.16b , v9.16b" : "+w"(cc0) : "w"(bb) );
        rl0 ^= tmp0;
        rh0 ^= cc0;
        //rl1 ^= vmull_p8( vget_low_p8(cc1) , vget_low_p8(bb) );
        __asm__ volatile ( "pmull   v13.8h, v11.8b , v9.8b"   : "=w"(tmp0) : "w"(cc1),"w"(bb) );
        __asm__ volatile ( "pmull2  v10.8h, v11.16b , v9.16b" : "=w"(cc0) : "w"(cc1) , "w"(bb) );
        rl1 ^= tmp0;
        rh1 ^= cc0;
        //rl2 ^= vmull_p8( vget_low_p8(cc2) , vget_low_p8(bb) );
        __asm__ volatile ( "pmull   v13.8h, v12.8b , v9.8b"   : "=w"(tmp0) : "w"(cc2),"w"(bb) );
        __asm__ volatile ( "pmull2  v10.8h, v12.16b , v9.16b" : "=w"(cc0) : "w"(cc2) , "w"(bb) );
        rl2 ^= tmp0;
        rh2 ^= cc0;
#else
        rl0 ^= vmull_p8( vget_low_p8(cc0) , vget_low_p8(bb) );
        rh0 ^= vmull_high_p8( cc0 , bb );
        rl1 ^= vmull_p8( vget_low_p8(cc1) , vget_low_p8(bb) );
        rh1 ^= vmull_high_p8( cc1 , bb );
        rl2 ^= vmull_p8( vget_low_p8(cc2) , vget_low_p8(bb) );
        rh2 ^= vmull_high_p8( cc2 , bb );
#endif
  }
  // reduce
  uint8x16_t mask_f = vdupq_n_u8( 0xf );
  uint8x16_t tab_rd0 = vld1q_u8(__gf256_bit8_11_reduce);
  uint8x16_t tab_rd1 = vld1q_u8(__gf256_bit12_15_reduce);

  uint8x16_t r0 = _gf256v_reduce_tbl_neon( rl0 , rh0 , mask_f , tab_rd0 , tab_rd1 );
  uint8x16_t r1 = _gf256v_reduce_tbl_neon( rl1 , rh1 , mask_f , tab_rd0 , tab_rd1 );
  uint8x16_t r2 = _gf256v_reduce_tbl_neon( rl2 , rh2 , mask_f , tab_rd0 , tab_rd1 );

  vst1q_u8( c    , r0 );
  vst1q_u8( c+16 , r1 );
  vst1q_u8( c+32 , r2 );
}

#endif


#if defined(HAS_Z4)

void gf256mat_block4_prod_lazy(uint8_t *c, const uint8_t * mat , unsigned mat_vec_len ,
       const uint8_t * b , unsigned mat_n_vec )
{
  if( 0==mat_n_vec ) { memset(c,0,64); return; }

  uint8x16_t rl0,rl1,rl2,rl3;
  uint8x16_t rh0,rh1,rh2,rh3;
  rl0 = vdupq_n_u8(0);
  rl1 = vdupq_n_u8(0);
  rl2 = vdupq_n_u8(0);
  rl3 = vdupq_n_u8(0);
  rh0 = vdupq_n_u8(0);
  rh1 = vdupq_n_u8(0);
  rh2 = vdupq_n_u8(0);
  rh3 = vdupq_n_u8(0);

  const uint8_t * ptr = mat;
  for(unsigned j=0;j<mat_n_vec;j++) {
        uint8x16_t bb = vdupq_n_u8(b[j]);
        uint8x16_t cc0 = vld1q_u8(ptr);
        uint8x16_t cc1 = vld1q_u8(ptr+16);
        uint8x16_t cc2 = vld1q_u8(ptr+32);
        uint8x16_t cc3 = vld1q_u8(ptr+48);  ptr += mat_vec_len;

        rl0 ^= vmull_p8( vget_low_p8(cc0) , vget_low_p8(bb) );
        rh0 ^= vmull_high_p8( cc0 , bb );
        rl1 ^= vmull_p8( vget_low_p8(cc1) , vget_low_p8(bb) );
        rh1 ^= vmull_high_p8( cc1 , bb );
        rl2 ^= vmull_p8( vget_low_p8(cc2) , vget_low_p8(bb) );
        rh2 ^= vmull_high_p8( cc2 , bb );
        rl3 ^= vmull_p8( vget_low_p8(cc3) , vget_low_p8(bb) );
        rh3 ^= vmull_high_p8( cc3 , bb );
  }
  // reduce
  uint8x16_t mask_f = vdupq_n_u8( 0xf );
  uint8x16_t tab_rd0 = vld1q_u8(__gf256_bit8_11_reduce);
  uint8x16_t tab_rd1 = vld1q_u8(__gf256_bit12_15_reduce);

  uint8x16_t r0 = _gf256v_reduce_tbl_neon( rl0 , rh0 , mask_f , tab_rd0 , tab_rd1 );
  uint8x16_t r1 = _gf256v_reduce_tbl_neon( rl1 , rh1 , mask_f , tab_rd0 , tab_rd1 );
  uint8x16_t r2 = _gf256v_reduce_tbl_neon( rl2 , rh2 , mask_f , tab_rd0 , tab_rd1 );
  uint8x16_t r3 = _gf256v_reduce_tbl_neon( rl3 , rh3 , mask_f , tab_rd0 , tab_rd1 );

  vst1q_u8( c    , r0 );
  vst1q_u8( c+16 , r1 );
  vst1q_u8( c+32 , r2 );
  vst1q_u8( c+48 , r3 );
}


#endif




void test_6_1(uint8_t * c0, const uint8_t * mat, const uint8x16_t * multabs, int w)
{
#if 3 == BLOCKLEN
    gf256mat_block3_prod_multab( c0, mat , 48 , (const uint8_t *)multabs , w );
#elif 4 == BLOCKLEN
    gf256mat_block4_prod_multab( c0, mat , 64 , (const uint8_t *)multabs , w );
#else
error ---
#endif
}


void test_6_2(uint8_t * c0, const uint8_t * mat, const uint8_t * b, int w)
{
#if 3 == BLOCKLEN
  gf256mat_block3_prod_lazy( c0, mat , 48 , b , w );
#elif 4 == BLOCKLEN
  gf256mat_block4_prod_lazy( c0, mat , 64 , b , w );
#else
error ----
#endif
}


void test_6_3(uint8_t * c0, const uint8_t * mat, const uint8_t * b , int w)
{
  // gf256 BLOCKLEN*16 x BLOCKLEN*16 mat-vec with multab
    uint8x16_t z = vdupq_n_u8(0);
    uint8x16_t r[BLOCKLEN];
    for(int i=0;i<BLOCKLEN;i++) r[i] = z;

    const uint8_t * ptr = mat;
    for( int i=0;i<w;i++ ) {
        for( int j=0;j<BLOCKLEN; j++) {
            r[j] ^= gf256v_mul_neon(vld1q_u8(ptr),b[i]); ptr += 16;
        }
    }
    for( int j=0;j<BLOCKLEN; j++) { vst1q_u8( c0+j*16 , r[j] ); }
}



int is_vec_eq(const uint8_t *v0, const uint8_t *v1, int len )
{
  uint8_t r=0;
  for(int i=0;i<len;i++) r |= v0[i]^v1[i];
  return (0==r);
}

#include "stdio.h"
#include "stdlib.h"


int main(int argc, char** argv)
{
	for(int i=128-1;i>=0;i--)     b[i]=rand();
	for(int i=128*128-1;i>=0;i--) mat[i]=rand();

	char msg[256];
	struct benchmark bm1,bm2,bm3;

	int ww[] = { 4 , 8 , 16 , 24 , 32 , 40 , 48 , 56 , 64 };

// gf256
    for(int j = 0 ; j < (int)(sizeof(ww)/sizeof(int)) ; j++) {

	printf("\nmat x vec:  (%d,%d) x (%d)\n", BLOCKLEN*16 , ww[j] , BLOCKLEN*16 );
	bm_init(&bm1);
	bm_init(&bm2);
	bm_init(&bm3);

	for(int i=10240;i>0;i--) {
	test_6_0( ww[j] );
BENCHMARK( bm1 , {
	test_6_1( c0 , mat , multabs , ww[j] );
} );
BENCHMARK( bm2 , {
	test_6_2( c1 , mat , b , ww[j] );
} );
BENCHMARK( bm3 , {
	test_6_3( c2 , mat , b , ww[j] );
} );
	}

	bm_dump(msg,256,&bm1);
	printf("TBL  : %s\n", msg );

	bm_dump(msg,256,&bm2);
	printf("lazy : %s\n", msg );

	bm_dump(msg,256,&bm3);
	printf("MUL  : %s\n", msg );

  if( ! is_vec_eq( c0 , c1 , BLOCKLEN*16 ) )  { printf("vec neq!!\n"); return -1; }

  }

    (void)argc;
    (void)argv;
	return 0;
}

