

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "api.h"

#include "benchmark.h"


#include "gf16_neon.h"
#include "blas_neon.h"


#include <arm_neon.h>


#define N_TESTS  1024

uint8_t b[N_TESTS];
uint8x16_t multabs[2*N_TESTS];
uint8_t a0[256];
uint8_t c0[256];
uint8_t c1[256];
uint8_t c2[256];




int is_vec_eq(const uint8_t *v0, const uint8_t *v1, int len )
{
  uint8_t r=0;
  for(int i=0;i<len;i++) r |= v0[i]^v1[i];
  return (0==r);
}

#include "stdio.h"
#include "stdlib.h"


void test_tbl( uint8_t * c , const uint8_t * a , uint8_t bb , unsigned w )
{
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16x2_t mm = gf256v_get_multab_neon( bb );

    for(unsigned i=0;i<w;i++ ) {
        uint8x16_t aa = vld1q_u8( a ); a += 16;
        uint8x16_t cc = _gf256_tbl(aa,mm.val[0],mm.val[1],mask_f);
        vst1q_u8( c , cc );  c += 16;
    }
}

void test_pmul( uint8_t * c , const uint8_t * a, uint8_t bb , unsigned w )
{
    uint8x16_t bbb = vdupq_n_u8(bb);
    uint8x16_t mask_f = vdupq_n_u8( 0xf );
    uint8x16_t tab_rd0 = vld1q_u8(__gf256_bit8_11_reduce);
    uint8x16_t tab_rd1 = vld1q_u8(__gf256_bit12_15_reduce);

    for(unsigned i=0;i<w;i++ ) {
        uint8x16_t aa = vld1q_u8( a ); a += 16;
        uint8x16_t cc = _gf256v_mul_neon( aa , bbb , mask_f , tab_rd0 , tab_rd1 );
        vst1q_u8( c , cc );  c += 16;
    }
}



int main(int argc, char** argv)
{
	for(unsigned i=0;i<sizeof(b);i++)   b[i]=rand();
	for(unsigned i=0;i<sizeof(a0);i++) a0[i]=rand();

	char msg[256];
    struct benchmark bm0, bm1,bm2;

    unsigned ww[5] = {1,2,3,4,5};

for( int j=0;j<5;j++ ) {

	bm_init(&bm0);
	bm_init(&bm1);
	bm_init(&bm2);


	printf("\ntest vec[%d] x scalar \n\n" , ww[j]*16 );

	//for(int i=0;i<N_TESTS;i++) {
        uint8x16x2_t mm;
BENCHMARK( bm0 , {
    for(int i=0;i<N_TESTS;i++) {
        mm = gf256v_get_multab_neon( b[i] );
        multabs[i] = mm.val[0];
        multabs[i] = mm.val[1];
    }
} );
        memcpy( c0 , a0 , ww[j]*16 );
BENCHMARK( bm1 , {
        for(int i=0;i<N_TESTS;i++) test_tbl( c0 , a0 , b[i] , ww[j] );
} );
        memcpy( c1 , a0 , ww[j]*16 );
BENCHMARK( bm2 , {
        for(int i=0;i<N_TESTS;i++) test_pmul( c1 , a0 , b[i] ,  ww[j] );
} );
	//}

	bm_dump(msg,256,&bm0);
	printf("GEN TAB : %s\n", msg );

	bm_dump(msg,256,&bm1);
	printf("TBL MUL : %s\n", msg );

	bm_dump(msg,256,&bm2);
	printf("PMUL X  : %s\n", msg );

  if( ! is_vec_eq( c0 , c1 , ww[j]*16 ) )  { printf("vec neq!!\n"); return -1; }

  }

    (void)argc;
    (void)argv;
	return 0;
}

