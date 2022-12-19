#include <stdlib.h>
#include "randombytes.h"
#include "hal.h"
#include "sendfn.h"
#include "gf16_asm.h"
#include "blas_comm.h"
#include "blas_u32.h"
#include "blas.h"
#include <string.h>
#include <stdint.h>

#define printcycles(S, U) send_unsignedll((S), (U))

#define _V1 68
#define _O1 44
#define _V1_BYTE (_V1)
#define _O1_BYTE (_O1)

void gf256mat_prod_ref(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b) {
    gf256v_set_zero(c, n_A_vec_byte);
    for (unsigned i = 0; i < n_A_width; i++) {
        gf256v_madd(c, matA, b[i], n_A_vec_byte);
        matA += n_A_vec_byte;
    }
}



static inline
void gf256mat_submat( uint8_t * mat2 , unsigned veclen2_byte , unsigned st , const uint8_t * mat , unsigned veclen_byte , unsigned n_vec )
{
    for(unsigned i=0;i<n_vec;i++) {
        for(unsigned j=0;j<veclen2_byte;j++) mat2[i*veclen2_byte+j] = mat[i*veclen_byte+st+j];
    }
}

void gf256mat_rowmat_mul_ref(uint8_t *matC, const uint8_t *matA, unsigned src_A_n_vec, unsigned src_A_veclen_byte, const uint8_t *matB, unsigned dest_B_veclen_byte)
{
    gf256v_set_zero( matC , src_A_n_vec*dest_B_veclen_byte );
    for( unsigned i=0; i<src_A_n_vec; i++) {
      for( unsigned j=0; j< src_A_veclen_byte; j++ ) {
          uint8_t ai_j = matA[j];
          gf256v_madd( matC , matB + j*dest_B_veclen_byte , ai_j , dest_B_veclen_byte );
      }
      matC += dest_B_veclen_byte;
      matA += src_A_veclen_byte;
    }
}

void gf256mat_colmat_mul_ref(uint8_t *mat_c, const uint8_t *mat_a, unsigned a_veclen_byte, unsigned a_n_vec, const uint8_t *mat_b, unsigned b_n_vec)
{
    gf256mat_rowmat_mul_ref( mat_c , mat_b , b_n_vec , a_n_vec , mat_a , a_veclen_byte );
}

unsigned gf256mat_LDUinv_m4f(uint8_t *mat_U_AinvB, uint8_t *mat_Ainv, uint8_t *mat_CAinvB_inv, uint8_t *mat_L_C, const uint8_t *matA , unsigned len) {
  #if _O1 != 44
  #error not implemented
  #endif

  // column-major matrices
  unsigned a_veclen_byte = len;
  unsigned a_n_vec = len;
  unsigned a_veclen_byte_2 = a_veclen_byte/2;
  unsigned a_n_vec_2 = a_n_vec/2;

  uint8_t * temp = mat_L_C;

  gf256mat_submat( temp, a_veclen_byte_2 , 0 , matA , a_veclen_byte , a_n_vec_2 );  // A
  unsigned r = gf256mat_inv_m4f_22( mat_Ainv , temp);
  if( 0==r ) return 0;

  gf256mat_submat( temp , a_veclen_byte_2 , 0 , matA+a_veclen_byte*a_n_vec_2 , a_veclen_byte , a_n_vec_2 );  // B
  gf256mat_colmat_mul_ref( mat_U_AinvB , mat_Ainv , a_veclen_byte_2 , a_n_vec_2  , temp , a_n_vec_2 );  // A^-1 x B

  gf256mat_submat( temp , a_veclen_byte_2 , a_veclen_byte_2  , matA , a_veclen_byte , a_n_vec_2 );  // C
  gf256mat_colmat_mul_ref( mat_CAinvB_inv , temp , a_veclen_byte_2 , a_n_vec_2 , mat_U_AinvB , a_n_vec_2 );

  gf256mat_submat( temp , a_veclen_byte_2 , a_veclen_byte_2 , matA+a_veclen_byte*a_n_vec_2 , a_veclen_byte , a_n_vec_2 );  // D
  gf256v_add( temp , mat_CAinvB_inv , a_veclen_byte_2*a_n_vec_2 );  // (D-CA^-1B)
  r = gf256mat_inv_m4f_22( mat_CAinvB_inv , temp);
  if( 0==r ) return 0;

  gf256mat_submat( mat_L_C , a_veclen_byte_2 , a_veclen_byte_2 , matA , a_veclen_byte , a_n_vec_2 );  // C
  return 1;
}
#define _MAX_LEN  256
void gf256mat_LDUinv_prod_ref(uint8_t *c, const uint8_t *mat_U_AinvB, const uint8_t *mat_Ainv, const uint8_t *mat_CAinvB_inv, const uint8_t *mat_L_C,
        const uint8_t * b , unsigned len)
{
    uint8_t temp[_MAX_LEN];
    unsigned len_2 = len/2;

    gf256mat_prod_ref( c       , mat_Ainv , len_2 , len_2 , b );  //   A^-1 x b_u
    //gf256mat_prod_ref( c+len_2 , mat_Ainv , len_2 , len_2 , b+len_2 );

    gf256mat_prod_ref( temp , mat_L_C , len_2 , len_2 , c );    //  C x  (A^-1xb_u)
    gf256v_add( temp , b+len_2 , len_2 );     //   C x  (A^-1xb_u) + b_b
    gf256mat_prod_ref( c+len_2 , mat_CAinvB_inv , len_2 , len_2 , temp );  //   (D-CA^-1B)^-1  x  (C x  (A^-1xb_u) + b_b)

    gf256mat_prod_ref( temp , mat_U_AinvB , len_2 , len_2 , c+len_2 );
    gf256v_add( c , temp , len_2 );
}


static
unsigned gf256mat_gauss_elim_row_echolen( uint8_t * mat , unsigned h , unsigned w )
{
    unsigned r8 = 1;

    for(unsigned i=0;i<h;i++) {
        uint8_t * ai = mat + w*i;
        //unsigned i_start = i-(i&(_BLAS_UNIT_LEN_-1));
        unsigned i_start = i;

        for(unsigned j=i+1;j<h;j++) {
            uint8_t * aj = mat + w*j;
            gf256v_conditional_add( ai + i_start , !gf256_is_nonzero(ai[i]) , aj + i_start , w - i_start );
        }
        r8 &= gf256_is_nonzero(ai[i]);
        uint8_t pivot = ai[i];
        pivot = gf256_inv( pivot );
        gf256v_mul_scalar( ai + i_start  , pivot , w - i_start );
        for(unsigned j=i+1;j<h;j++) {
            uint8_t * aj = mat + w*j;
            gf256v_madd( aj + i_start , ai+ i_start , aj[i] , w - i_start );
        }
    }
    return r8;
}

static
unsigned gf256mat_gaussian_elim_ref(uint8_t *sqmat_a , uint8_t *constant, unsigned len)
{
    const unsigned MAX_H=96;
    uint8_t mat[MAX_H*(MAX_H+4)];

    unsigned height = len;
    unsigned width  = len+4;

    for(unsigned i=0;i<height;i++) {
        uint8_t * ai = mat + i*width;
        for(unsigned j=0;j<height;j++) ai[j] = sqmat_a[j*len+i];  // transpose since sqmat_a is col-major
        ai[height] = constant[i];
    }
    unsigned char r8 = gf256mat_gauss_elim_row_echolen( mat , height , width );

    for(unsigned i=0;i<height;i++) {
        uint8_t * ai = mat + i*width;
        memcpy( sqmat_a + i*len , ai , len );     // output a row-major matrix
        constant[i] = ai[len];
    }
    return r8;
}
static
void gf256mat_back_substitute_ref( uint8_t *constant, const uint8_t *sq_row_mat_a, unsigned len)
{
    const unsigned MAX_H=96;
    uint8_t column[MAX_H];
    for(int i=len-1;i>0;i--) {
        for(int j=0;j<i;j++) column[j] = sq_row_mat_a[j*len+i];   // row-major -> column-major, i.e., transpose
        gf256v_madd( constant , column , constant[i] , i );
    }
}



static
unsigned char gf256mat_gaussian_elim_m4f(uint8_t *sqmat_a , uint8_t *constant){
    uint8_t mat[_O1*(_O1_BYTE+4)];
    for(unsigned i=0;i<_O1;i++) {
        uint8_t * ai = mat + i*(_O1_BYTE+4);
        for(unsigned j=0;j<_O1;j++) {
            // transpose since sqmat_a is col-major
            ai[j] = sqmat_a[j*_O1_BYTE+i];
        }
        ai[_O1_BYTE] = constant[i];
    }

    unsigned char r8 = gf256mat_gauss_elim_row_echolen_44_asm(mat);

    for(unsigned i=0;i<_O1;i++) {
        uint8_t * ai = mat + i*(_O1_BYTE+4);
        memcpy( sqmat_a + i*_O1_BYTE , ai , _O1_BYTE);     // output a row-major matrix
        constant[i] = ai[_O1_BYTE];
    }
    return r8;
}


static void bench(void){
    uint64_t t0, t1;
    unsigned char mat1[_O1*_O1_BYTE];
    uint8_t submat_A[(_O1/2)*(_O1_BYTE/2)];
    uint8_t submat_B[(_O1/2)*(_O1_BYTE/2)];
    uint8_t submat_C[(_O1/2)*(_O1_BYTE/2)];
    uint8_t submat_D[(_O1/2)*(_O1_BYTE/2)];
    uint8_t x_o1[_O1_BYTE];
    uint8_t r_l1_F1[_O1_BYTE];
    uint8_t y[_PUB_N_BYTE];

    randombytes(mat1, sizeof mat1);
    randombytes(r_l1_F1, sizeof r_l1_F1);

    t0 = hal_get_time();
    int l1_succ = gf256mat_LDUinv_m4f( submat_B , submat_A , submat_D , submat_C , mat1 , _O1 );
    if( !l1_succ ) hal_send_str("not invertible");
    gf256mat_LDUinv_prod_ref( x_o1 , submat_B , submat_A , submat_D , submat_C , y , _O1_BYTE );
    t1 = hal_get_time();
    printcycles("linear equation solving using LDUinv:", t1-t0);

    t0 = hal_get_time();
    l1_succ = gf256mat_gaussian_elim_m4f(mat1, r_l1_F1);
    if( !l1_succ ) hal_send_str("not invertible");
    gf256mat_back_substitute_ref(r_l1_F1, mat1, _O1);
    memcpy( x_o1 , r_l1_F1 , _O1_BYTE );
    t1 = hal_get_time();
    printcycles("linear equation solving using Gaussian elimination:", t1-t0);

    t0 = hal_get_time();
    l1_succ = gf256mat_gaussian_elim_m4f(mat1 , r_l1_F1);
    if( !l1_succ ) hal_send_str("not invertible");
    t1 = hal_get_time();
    printcycles("\tGaussian elimination:", t1-t0);


    t0 = hal_get_time();
    gf256mat_back_substitute_ref(r_l1_F1, mat1, _O1);
    t1 = hal_get_time();
    printcycles("\tback subtitution:", t1-t0);

}

static void test(void){
    unsigned char mat1[_O1*_O1_BYTE];
    unsigned char mat2[_O1*_O1_BYTE];
    uint8_t y1[_O1_BYTE];
    uint8_t y2[_O1_BYTE];
    randombytes(mat1, sizeof mat1);
    randombytes(y1, sizeof y1);
    memcpy(mat2, mat1, sizeof mat1);
    memcpy(y2, y1, sizeof y1);

    gf256mat_gaussian_elim_m4f(mat1, y1);
    //gf16mat_gauss_elim_m4f_64(mat1, y1);
    gf256mat_gaussian_elim_ref(mat2, y2, _O1);

    if(memcmp(y1,y2,sizeof y1)){
        hal_send_str("ERROR (sub)!");
    } else {
        hal_send_str("OK (sub)!");
    }
    randombytes(mat1, sizeof mat1);
    randombytes(y1, sizeof y1);
    memcpy(mat2, mat1, sizeof mat1);
    memcpy(y2, y1, sizeof y1);

    // gf16mat_gaussian_elim_m4f(mat1, y1);
    gf256mat_gaussian_elim_m4f(mat1, y1);
    gf256mat_gaussian_elim_ref(mat2, y2, _O1);

    if(memcmp(y1,y2,sizeof y1)){
        hal_send_str("ERROR (full)!");
    } else {
        hal_send_str("OK (full)!");
    }


}


int main(void){
    hal_setup(CLOCK_BENCHMARK);
    hal_send_str("==========================\n");
    test();
    // unsigned int errcnt = test();
    bench();
    // send_unsigned("errcnt=", errcnt);

    hal_send_str("#\n");
    while(1);
    return 0;
}