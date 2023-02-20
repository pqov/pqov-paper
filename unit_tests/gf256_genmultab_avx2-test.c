

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "api.h"

#include "benchmark.h"


#include "gf16_avx2.h"



// AVX2
#include <immintrin.h>



#define NUMYMM 1024

__m256i multabs[NUMYMM];
uint8_t b[NUMYMM];




static inline __m256i gf256_multab_1( uint8_t b , __m256i tab0, __m256i tab1, __m256i tab2, __m256i tab3, __m256i tab4, __m256i tab5, __m256i tab6, __m256i tab7 , __m256i mask )
{
    __m256i bx = _mm256_set1_epi8( b );

    return ( tab0 & _mm256_cmpeq_epi8(mask,bx&mask) )
         ^ ( tab1 & _mm256_cmpeq_epi8(mask,_mm256_srli_epi16(bx,1)&mask) )
         ^ ( tab2 & _mm256_cmpeq_epi8(mask,_mm256_srli_epi16(bx,2)&mask) )
         ^ ( tab3 & _mm256_cmpeq_epi8(mask,_mm256_srli_epi16(bx,3)&mask) )
         ^ ( tab4 & _mm256_cmpeq_epi8(mask,_mm256_srli_epi16(bx,4)&mask) )
         ^ ( tab5 & _mm256_cmpeq_epi8(mask,_mm256_srli_epi16(bx,5)&mask) )
         ^ ( tab6 & _mm256_cmpeq_epi8(mask,_mm256_srli_epi16(bx,6)&mask) )
         ^ ( tab7 & _mm256_cmpeq_epi8(mask,_mm256_srli_epi16(bx,7)&mask) );
}


void test_1()
{
  __m256i tab0 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*0));
  __m256i tab1 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*1));
  __m256i tab2 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*2));
  __m256i tab3 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*3));
  __m256i tab4 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*4));
  __m256i tab5 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*5));
  __m256i tab6 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*6));
  __m256i tab7 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*7));

  __m256i mask = _mm256_set1_epi8(1);

  for(int i=NUMYMM;i>0;i--){
    multabs[i] = gf256_multab_1(b[i], tab0, tab1, tab2, tab3, tab4, tab5, tab6, tab7, mask );
  }
}




#if 1

// remove shift-right
static inline __m256i gf256_multab_2( uint8_t b )
{
    __m256i bx = _mm256_set1_epi16( b );
    __m256i b1 = _mm256_srli_epi16( bx , 1 );

    __m256i tab0 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*0));
    __m256i tab1 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*1));
    __m256i tab2 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*2));
    __m256i tab3 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*3));
    __m256i tab4 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*4));
    __m256i tab5 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*5));
    __m256i tab6 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*6));
    __m256i tab7 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*7));

    __m256i mask_1  = _mm256_set1_epi16(1);
    __m256i mask_4  = _mm256_set1_epi16(4);
    __m256i mask_16 = _mm256_set1_epi16(16);
    __m256i mask_64 = _mm256_set1_epi16(64);
    __m256i mask_0  = _mm256_setzero_si256();

    return ( tab0 & _mm256_cmpgt_epi16( bx&mask_1  , mask_0) )
         ^ ( tab1 & _mm256_cmpgt_epi16( b1&mask_1  , mask_0) )
         ^ ( tab2 & _mm256_cmpgt_epi16( bx&mask_4  , mask_0) )
         ^ ( tab3 & _mm256_cmpgt_epi16( b1&mask_4  , mask_0) )
         ^ ( tab4 & _mm256_cmpgt_epi16( bx&mask_16 , mask_0) )
         ^ ( tab5 & _mm256_cmpgt_epi16( b1&mask_16 , mask_0) )
         ^ ( tab6 & _mm256_cmpgt_epi16( bx&mask_64 , mask_0) )
         ^ ( tab7 & _mm256_cmpgt_epi16( b1&mask_64 , mask_0) );
}

void test_2()
{
  for(int i=NUMYMM;i>0;i--){
    multabs[i] = gf256_multab_2(b[i]);
  }
}



#else

// remove shift-right
static inline __m256i gf256_multab_2( uint8_t b , __m256i tab0, __m256i tab1, __m256i tab2, __m256i tab3, __m256i tab4, __m256i tab5, __m256i tab6, __m256i tab7 
  , __m256i mask_1 , __m256i mask_4 , __m256i mask_16 , __m256i mask_64 , __m256i mask_0 )
{
    __m256i bx = _mm256_set1_epi16( b );
    __m256i b1 = _mm256_srli_epi16( bx , 1 );

    return ( tab0 & _mm256_cmpgt_epi16( bx&mask_1  , mask_0) )
         ^ ( tab1 & _mm256_cmpgt_epi16( b1&mask_1  , mask_0) )
         ^ ( tab2 & _mm256_cmpgt_epi16( bx&mask_4  , mask_0) )
         ^ ( tab3 & _mm256_cmpgt_epi16( b1&mask_4  , mask_0) )
         ^ ( tab4 & _mm256_cmpgt_epi16( bx&mask_16 , mask_0) )
         ^ ( tab5 & _mm256_cmpgt_epi16( b1&mask_16 , mask_0) )
         ^ ( tab6 & _mm256_cmpgt_epi16( bx&mask_64 , mask_0) )
         ^ ( tab7 & _mm256_cmpgt_epi16( b1&mask_64 , mask_0) );
}

void test_2()
{
  __m256i tab0 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*0));
  __m256i tab1 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*1));
  __m256i tab2 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*2));
  __m256i tab3 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*3));
  __m256i tab4 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*4));
  __m256i tab5 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*5));
  __m256i tab6 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*6));
  __m256i tab7 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*7));

    __m256i mask_1  = _mm256_set1_epi16(1);
    __m256i mask_4  = _mm256_set1_epi16(4);
    __m256i mask_16 = _mm256_set1_epi16(16);
    __m256i mask_64 = _mm256_set1_epi16(64);
    __m256i mask_0  = _mm256_setzero_si256();

  for(int i=NUMYMM;i>0;i--){
    multabs[i] = gf256_multab_2(b[i], tab0, tab1, tab2, tab3, tab4, tab5, tab6, tab7, mask_1 , mask_4 , mask_16 , mask_64 , mask_0 );
  }
}

#endif

// use mullo
static inline __m256i gf256_multab_3( uint8_t b , __m256i tab0, __m256i tab1, __m256i tab2, __m256i tab3, __m256i tab4, __m256i tab5, __m256i tab6, __m256i tab7 
   , __m256i mask_1 )
{
    __m256i bx = _mm256_set1_epi16( b );
    //__m256i mask_1  = _mm256_set1_epi16(1);

    return _mm256_mullo_epi16( tab0 , bx&mask_1 )
         ^ _mm256_mullo_epi16( tab1 , _mm256_srli_epi16(bx,1)&mask_1 )
         ^ _mm256_mullo_epi16( tab2 , _mm256_srli_epi16(bx,2)&mask_1 )
         ^ _mm256_mullo_epi16( tab3 , _mm256_srli_epi16(bx,3)&mask_1 )
         ^ _mm256_mullo_epi16( tab4 , _mm256_srli_epi16(bx,4)&mask_1 )
         ^ _mm256_mullo_epi16( tab5 , _mm256_srli_epi16(bx,5)&mask_1 )
         ^ _mm256_mullo_epi16( tab6 , _mm256_srli_epi16(bx,6)&mask_1 )
         ^ _mm256_mullo_epi16( tab7 , _mm256_srli_epi16(bx,7)&mask_1 );
}


void test_3()
{
  __m256i tab0 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*0));
  __m256i tab1 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*1));
  __m256i tab2 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*2));
  __m256i tab3 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*3));
  __m256i tab4 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*4));
  __m256i tab5 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*5));
  __m256i tab6 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*6));
  __m256i tab7 = _mm256_load_si256((__m256i const *) (__gf256_mulbase + 32*7));

  __m256i mask = _mm256_set1_epi16(1);

  for(int i=NUMYMM;i>0;i--){
    multabs[i] = gf256_multab_3(b[i], tab0, tab1, tab2, tab3, tab4, tab5, tab6, tab7, mask );
  }
}


#include "gf256_tabs.h"


static inline
void gf256v_16_multab_1( __m256i *multabs , const uint8_t * a
   , __m256i broadcast_x1 , __m256i broadcast_x2 , __m256i broadcast_x4 , __m256i broadcast_x8
   , __m256i tab0 , __m256i tab1 , __m256i tab2 , __m256i tab3 , __m256i tab4 , __m256i tab5 , __m256i tab6 , __m256i tab7 , __m256i mask_f )
{
    __m128i _a = _mm_loadu_si128( (const __m128i*) a );
    __m256i aa = _mm256_setr_m128i( _a , _a );
    __m256i a_lo = aa&mask_f;
    __m256i a_hi = _mm256_srli_epi16(aa,4)&mask_f;
    __m256i bx1 =  _mm256_shuffle_epi8( tab0  ,a_lo) ^ _mm256_shuffle_epi8( tab1  ,a_hi);
    __m256i bx2 =  _mm256_shuffle_epi8( tab2  ,a_lo) ^ _mm256_shuffle_epi8( tab3  ,a_hi);
    __m256i bx4 =  _mm256_shuffle_epi8( tab4  ,a_lo) ^ _mm256_shuffle_epi8( tab5  ,a_hi);
    __m256i bx8 =  _mm256_shuffle_epi8( tab6  ,a_lo) ^ _mm256_shuffle_epi8( tab7  ,a_hi);

    multabs[0] =  _mm256_shuffle_epi8(bx1,broadcast_x1) ^ _mm256_shuffle_epi8(bx2,broadcast_x2)
                ^ _mm256_shuffle_epi8(bx4,broadcast_x4) ^ _mm256_shuffle_epi8(bx8,broadcast_x8);

    for(unsigned i=1;i<16;i++) {
        bx1 = _mm256_srli_si256( bx1 , 1 );
        bx2 = _mm256_srli_si256( bx2 , 1 );
        bx4 = _mm256_srli_si256( bx4 , 1 );
        bx8 = _mm256_srli_si256( bx8 , 1 );

        multabs[i] =  _mm256_shuffle_epi8(bx1,broadcast_x1) ^ _mm256_shuffle_epi8(bx2,broadcast_x2)
                      ^ _mm256_shuffle_epi8(bx4,broadcast_x4) ^ _mm256_shuffle_epi8(bx8,broadcast_x8);
    }
}

void test_4()
{
    __m256i broadcast_x1 = _mm256_set_epi8( 0,-16,0,-16, 0,-16,0,-16,  0,-16,0,-16, 0,-16,0,-16,  0,-16,0,-16, 0,-16,0,-16,  0,-16,0,-16, 0,-16,0,-16 );
    __m256i broadcast_x2 = _mm256_set_epi8( 0,0,-16,-16, 0,0,-16,-16,  0,0,-16,-16, 0,0,-16,-16,  0,0,-16,-16, 0,0,-16,-16,  0,0,-16,-16, 0,0,-16,-16 );
    __m256i broadcast_x4 = _mm256_set_epi8( 0,0,0,0, -16,-16,-16,-16,  0,0,0,0, -16,-16,-16,-16,  0,0,0,0, -16,-16,-16,-16,  0,0,0,0, -16,-16,-16,-16 );
    __m256i broadcast_x8 = _mm256_set_epi8( 0,0,0,0, 0,0,0,0,  -16,-16,-16,-16, -16,-16,-16,-16,  0,0,0,0, 0,0,0,0,  -16,-16,-16,-16, -16,-16,-16,-16 );

  __m256i tab0 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*0));
  __m256i tab1 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*1));
  __m256i tab2 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*2));
  __m256i tab3 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*3));
  __m256i tab4 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*4));
  __m256i tab5 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*5));
  __m256i tab6 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*6));
  __m256i tab7 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*7));

    __m256i mask_f = _mm256_set1_epi8(0xf);

  for(int i=0;i<1024;i+=16){
    gf256v_16_multab_1( multabs+i , b+i , broadcast_x1 , broadcast_x2 , broadcast_x4 , broadcast_x8 ,
                 tab0, tab1, tab2, tab3, tab4, tab5, tab6, tab7, mask_f );
  }
}


#if 1

static inline
void gf256v_16_multab_2( __m256i *multabs , const uint8_t * a )
{
    __m256i tab0 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*0));
    __m256i tab1 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*1));
    __m256i tab2 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*2));
    __m256i tab3 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*3));
    __m256i tab4 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*4));
    __m256i tab5 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*5));
    __m256i tab6 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*6));
    __m256i tab7 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*7));
    __m256i mask_f = _mm256_set1_epi8(0xf);

    __m128i _a = _mm_loadu_si128( (const __m128i*) a );
    __m256i aa = _mm256_setr_m128i( _a , _a );
    __m256i a_lo = aa&mask_f;
    __m256i a_hi = _mm256_srli_epi16(aa,4)&mask_f;
    __m256i bx1 =  _mm256_shuffle_epi8( tab0  ,a_lo) ^ _mm256_shuffle_epi8( tab1  ,a_hi);
    __m256i bx2 =  _mm256_shuffle_epi8( tab2  ,a_lo) ^ _mm256_shuffle_epi8( tab3  ,a_hi);
    __m256i bx4 =  _mm256_shuffle_epi8( tab4  ,a_lo) ^ _mm256_shuffle_epi8( tab5  ,a_hi);
    __m256i bx8 =  _mm256_shuffle_epi8( tab6  ,a_lo) ^ _mm256_shuffle_epi8( tab7  ,a_hi);

    __m256i broadcast_x1 = _mm256_set_epi8( 0,-16,0,-16, 0,-16,0,-16,  0,-16,0,-16, 0,-16,0,-16,  0,-16,0,-16, 0,-16,0,-16,  0,-16,0,-16, 0,-16,0,-16 );
    __m256i broadcast_x2 = _mm256_set_epi8( 0,0,-16,-16, 0,0,-16,-16,  0,0,-16,-16, 0,0,-16,-16,  0,0,-16,-16, 0,0,-16,-16,  0,0,-16,-16, 0,0,-16,-16 );
    __m256i broadcast_x4 = _mm256_set_epi8( 0,0,0,0, -16,-16,-16,-16,  0,0,0,0, -16,-16,-16,-16,  0,0,0,0, -16,-16,-16,-16,  0,0,0,0, -16,-16,-16,-16 );
    __m256i broadcast_x8 = _mm256_set_epi8( 0,0,0,0, 0,0,0,0,  -16,-16,-16,-16, -16,-16,-16,-16,  0,0,0,0, 0,0,0,0,  -16,-16,-16,-16, -16,-16,-16,-16 );
    __m256i broadcast_x1_2 = _mm256_set_epi8( 1,-16,1,-16, 1,-16,1,-16,  1,-16,1,-16, 1,-16,1,-16,  1,-16,1,-16, 1,-16,1,-16,  1,-16,1,-16, 1,-16,1,-16 );
    __m256i broadcast_x2_2 = _mm256_set_epi8( 1,1,-16,-16, 1,1,-16,-16,  1,1,-16,-16, 1,1,-16,-16,  1,1,-16,-16, 1,1,-16,-16,  1,1,-16,-16, 1,1,-16,-16 );
    __m256i broadcast_x4_2 = _mm256_set_epi8( 1,1,1,1, -16,-16,-16,-16,  1,1,1,1, -16,-16,-16,-16,  1,1,1,1, -16,-16,-16,-16,  1,1,1,1, -16,-16,-16,-16 );
    __m256i broadcast_x8_2 = _mm256_set_epi8( 1,1,1,1, 1,1,1,1,  -16,-16,-16,-16, -16,-16,-16,-16,  1,1,1,1, 1,1,1,1,  -16,-16,-16,-16, -16,-16,-16,-16 );

    multabs[0] =  _mm256_shuffle_epi8(bx1,broadcast_x1) ^ _mm256_shuffle_epi8(bx2,broadcast_x2)
                ^ _mm256_shuffle_epi8(bx4,broadcast_x4) ^ _mm256_shuffle_epi8(bx8,broadcast_x8);
    multabs[1] =  _mm256_shuffle_epi8(bx1,broadcast_x1_2) ^ _mm256_shuffle_epi8(bx2,broadcast_x2_2)
                ^ _mm256_shuffle_epi8(bx4,broadcast_x4_2) ^ _mm256_shuffle_epi8(bx8,broadcast_x8_2);

    for(unsigned i=2;i<16;i+=2) {
        bx1 = _mm256_srli_si256( bx1 , 2 );
        bx2 = _mm256_srli_si256( bx2 , 2 );
        bx4 = _mm256_srli_si256( bx4 , 2 );
        bx8 = _mm256_srli_si256( bx8 , 2 );
        multabs[i] =  _mm256_shuffle_epi8(bx1,broadcast_x1) ^ _mm256_shuffle_epi8(bx2,broadcast_x2)
                      ^ _mm256_shuffle_epi8(bx4,broadcast_x4) ^ _mm256_shuffle_epi8(bx8,broadcast_x8);
        multabs[i+1] =  _mm256_shuffle_epi8(bx1,broadcast_x1_2) ^ _mm256_shuffle_epi8(bx2,broadcast_x2_2)
                      ^ _mm256_shuffle_epi8(bx4,broadcast_x4_2) ^ _mm256_shuffle_epi8(bx8,broadcast_x8_2);
    }
}

void test_5()
{


  for(int i=0;i<1024;i+=16){
    gf256v_16_multab_2( multabs+i , b+i );
  }
}

#else

static inline
void gf256v_16_multab_2( __m256i *multabs , const uint8_t * a
   , __m256i broadcast_x1 , __m256i broadcast_x2 , __m256i broadcast_x4 , __m256i broadcast_x8
   , __m256i broadcast_x1_2 , __m256i broadcast_x2_2 , __m256i broadcast_x4_2 , __m256i broadcast_x8_2
   , __m256i tab0 , __m256i tab1 , __m256i tab2 , __m256i tab3 , __m256i tab4 , __m256i tab5 , __m256i tab6 , __m256i tab7 , __m256i mask_f )
{
    __m128i _a = _mm_loadu_si128( (const __m128i*) a );
    __m256i aa = _mm256_setr_m128i( _a , _a );
    __m256i a_lo = aa&mask_f;
    __m256i a_hi = _mm256_srli_epi16(aa,4)&mask_f;
    __m256i bx1 =  _mm256_shuffle_epi8( tab0  ,a_lo) ^ _mm256_shuffle_epi8( tab1  ,a_hi);
    __m256i bx2 =  _mm256_shuffle_epi8( tab2  ,a_lo) ^ _mm256_shuffle_epi8( tab3  ,a_hi);
    __m256i bx4 =  _mm256_shuffle_epi8( tab4  ,a_lo) ^ _mm256_shuffle_epi8( tab5  ,a_hi);
    __m256i bx8 =  _mm256_shuffle_epi8( tab6  ,a_lo) ^ _mm256_shuffle_epi8( tab7  ,a_hi);

    multabs[0] =  _mm256_shuffle_epi8(bx1,broadcast_x1) ^ _mm256_shuffle_epi8(bx2,broadcast_x2)
                ^ _mm256_shuffle_epi8(bx4,broadcast_x4) ^ _mm256_shuffle_epi8(bx8,broadcast_x8);
    multabs[1] =  _mm256_shuffle_epi8(bx1,broadcast_x1_2) ^ _mm256_shuffle_epi8(bx2,broadcast_x2_2)
                ^ _mm256_shuffle_epi8(bx4,broadcast_x4_2) ^ _mm256_shuffle_epi8(bx8,broadcast_x8_2);

    for(unsigned i=2;i<16;i+=2) {
        bx1 = _mm256_srli_si256( bx1 , 2 );
        bx2 = _mm256_srli_si256( bx2 , 2 );
        bx4 = _mm256_srli_si256( bx4 , 2 );
        bx8 = _mm256_srli_si256( bx8 , 2 );

        multabs[i] =  _mm256_shuffle_epi8(bx1,broadcast_x1) ^ _mm256_shuffle_epi8(bx2,broadcast_x2)
                      ^ _mm256_shuffle_epi8(bx4,broadcast_x4) ^ _mm256_shuffle_epi8(bx8,broadcast_x8);
        multabs[i+1] =  _mm256_shuffle_epi8(bx1,broadcast_x1_2) ^ _mm256_shuffle_epi8(bx2,broadcast_x2_2)
                      ^ _mm256_shuffle_epi8(bx4,broadcast_x4_2) ^ _mm256_shuffle_epi8(bx8,broadcast_x8_2);
    }
}

void test_5()
{
    __m256i broadcast_x1 = _mm256_set_epi8( 0,-16,0,-16, 0,-16,0,-16,  0,-16,0,-16, 0,-16,0,-16,  0,-16,0,-16, 0,-16,0,-16,  0,-16,0,-16, 0,-16,0,-16 );
    __m256i broadcast_x2 = _mm256_set_epi8( 0,0,-16,-16, 0,0,-16,-16,  0,0,-16,-16, 0,0,-16,-16,  0,0,-16,-16, 0,0,-16,-16,  0,0,-16,-16, 0,0,-16,-16 );
    __m256i broadcast_x4 = _mm256_set_epi8( 0,0,0,0, -16,-16,-16,-16,  0,0,0,0, -16,-16,-16,-16,  0,0,0,0, -16,-16,-16,-16,  0,0,0,0, -16,-16,-16,-16 );
    __m256i broadcast_x8 = _mm256_set_epi8( 0,0,0,0, 0,0,0,0,  -16,-16,-16,-16, -16,-16,-16,-16,  0,0,0,0, 0,0,0,0,  -16,-16,-16,-16, -16,-16,-16,-16 );

    __m256i broadcast_x1_2 = _mm256_set_epi8( 1,-16,1,-16, 1,-16,1,-16,  1,-16,1,-16, 1,-16,1,-16,  1,-16,1,-16, 1,-16,1,-16,  1,-16,1,-16, 1,-16,1,-16 );
    __m256i broadcast_x2_2 = _mm256_set_epi8( 1,1,-16,-16, 1,1,-16,-16,  1,1,-16,-16, 1,1,-16,-16,  1,1,-16,-16, 1,1,-16,-16,  1,1,-16,-16, 1,1,-16,-16 );
    __m256i broadcast_x4_2 = _mm256_set_epi8( 1,1,1,1, -16,-16,-16,-16,  1,1,1,1, -16,-16,-16,-16,  1,1,1,1, -16,-16,-16,-16,  1,1,1,1, -16,-16,-16,-16 );
    __m256i broadcast_x8_2 = _mm256_set_epi8( 1,1,1,1, 1,1,1,1,  -16,-16,-16,-16, -16,-16,-16,-16,  1,1,1,1, 1,1,1,1,  -16,-16,-16,-16, -16,-16,-16,-16 );

  __m256i tab0 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*0));
  __m256i tab1 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*1));
  __m256i tab2 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*2));
  __m256i tab3 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*3));
  __m256i tab4 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*4));
  __m256i tab5 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*5));
  __m256i tab6 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*6));
  __m256i tab7 = _mm256_load_si256((__m256i const *) (__gf256_mulbase_avx + 32*7));

    __m256i mask_f = _mm256_set1_epi8(0xf);

  for(int i=0;i<1024;i+=16){
    gf256v_16_multab_2( multabs+i , b+i , broadcast_x1 , broadcast_x2 , broadcast_x4 , broadcast_x8 ,
                  broadcast_x1_2 , broadcast_x2_2 , broadcast_x4_2 , broadcast_x8_2 ,
                 tab0, tab1, tab2, tab3, tab4, tab5, tab6, tab7, mask_f );
  }
}

#endif




#include "stdio.h"
#include "stdlib.h"

int main(int argc, char** argv)
{
	struct benchmark bm1,bm2,bm3, bm4,bm5;
	bm_init(&bm1);
	bm_init(&bm2);
	bm_init(&bm3);
	bm_init(&bm4);
	bm_init(&bm5);

	for(int i=NUMYMM;i>0;i--) b[i]=rand();

	for(int i=1024;i>0;i--) {
BENCHMARK( bm1 , {
	test_1();
} );
BENCHMARK( bm2 , {
	test_2();
} );
BENCHMARK( bm3 , {
	test_3();
} );
BENCHMARK( bm4 , {
	test_4();
} );
BENCHMARK( bm5 , {
	test_5();
} );

	}

	char msg[256];

	bm_dump(msg,256,&bm1);
	printf("cmpeq  : %s\n\n", msg );

	bm_dump(msg,256,&bm2);
	printf("no shr : %s\n\n", msg );

	bm_dump(msg,256,&bm3);
	printf("mullo  : %s\n\n", msg );

	bm_dump(msg,256,&bm4);
	printf("gen16 1: %s\n\n", msg );

	bm_dump(msg,256,&bm5);
	printf("gen16 2: %s\n\n", msg );


    (void)argc;
    (void)argv;
	return 0;
}

