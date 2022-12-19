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


static inline
void gf256mat_submat( uint8_t * mat2 , unsigned veclen2_byte , unsigned st , const uint8_t * mat , unsigned veclen_byte , unsigned n_vec )
{
    for(unsigned i=0;i<n_vec;i++) {
        for(unsigned j=0;j<veclen2_byte;j++) mat2[i*veclen2_byte+j] = mat[i*veclen_byte+st+j];
    }
}


#define _BLAS_UNIT_LEN_ 4
static
unsigned gf16mat_gauss_elim_ref(uint8_t *mat, unsigned h, unsigned w) {
    const unsigned w_byte = (w+1)>>1;

    unsigned r8 = 1;
    for (unsigned i = 0; i < h; i++) {
        unsigned i_start = ((i>>1)&(~(_BLAS_UNIT_LEN_-1)));
        //unsigned i_start = (i>>1);
        uint8_t *ai = mat + i*w_byte;
        for (unsigned j = i + 1; j < h; j++) {
            uint8_t *aj = mat + j*w_byte;
            gf256v_conditional_add(ai + i_start, !gf16_is_nonzero(gf16v_get_ele(ai, i)), aj + i_start, w_byte - i_start );
        }
        uint8_t pivot = gf16v_get_ele(ai, i);
        r8 &= gf16_is_nonzero(pivot);
        pivot = gf16_inv(pivot);
        gf16v_mul_scalar(ai + i_start, pivot, w_byte - i_start );
        for (unsigned j = 0; j < h; j++) {
            if (i == j) continue;
            uint8_t *aj = mat + j*w_byte;
            gf16v_madd(aj + i_start, ai + i_start, gf16v_get_ele(aj, i), w_byte-i_start);
        }
    }
    return r8;
}

static
unsigned gf16mat_inv_ref(uint8_t *inv_a, const uint8_t *a , unsigned H )
{
    // if( 32==H ) return gf16mat_inv_32x32_ref( inv_a , a );

    const unsigned MAX_H=64;
    uint8_t mat[MAX_H*MAX_H];  // max: 64x128

    unsigned h_byte = (H+1)>>1;
    for (unsigned i = 0; i < H; i++) {
        uint8_t *ai = mat + i * H;
        gf256v_set_zero(ai, H );
        gf256v_add(ai, a + i * h_byte, h_byte);
        gf16v_set_ele(ai + h_byte, i, 1);
    }
    uint8_t r8 = gf16mat_gauss_elim_ref(mat, H , H*2);
    gf256mat_submat(inv_a, h_byte, h_byte, mat, H, H);

    return r8;
}

void gf16mat_rowmat_mul_ref(uint8_t *matC, const uint8_t *matA, unsigned height_A, unsigned width_A_byte, const uint8_t *matB, unsigned width_B_byte)
{
    gf256v_set_zero( matC , height_A*width_B_byte );
    for( unsigned i=0; i<height_A; i++) {
      for( unsigned j=0; j<width_A_byte*2; j++ ) {
          uint8_t ai_j = gf16v_get_ele( matA , j );
          gf16v_madd( matC , matB + j*width_B_byte , ai_j , width_B_byte );
      }
      matC += width_B_byte;
      matA += width_A_byte;
    }
}


void gf16mat_colmat_mul_ref(uint8_t *mat_c, const uint8_t *mat_a, unsigned a_veclen_byte, unsigned a_n_vec, const uint8_t *mat_b, unsigned b_n_vec)
{
    gf16mat_rowmat_mul_ref( mat_c , mat_b , b_n_vec , (a_n_vec+1)>>1 , mat_a , a_veclen_byte );
}



unsigned gf16mat_LDUinv_m4f(uint8_t *mat_U_AinvB, uint8_t *mat_Ainv, 
                             uint8_t *mat_CAinvB_inv, uint8_t *mat_L_C, 
                             const uint8_t *matA , unsigned len)
{
    // column-major matrices
    unsigned a_veclen_byte = len/2;
    unsigned a_n_vec = len;
    unsigned a_veclen_byte_2 = a_veclen_byte/2;
    unsigned a_n_vec_2 = a_n_vec/2;

    uint8_t * temp = mat_L_C;

    gf256mat_submat( temp, a_veclen_byte_2 , 0 , matA , a_veclen_byte , a_n_vec_2 );  // A
    unsigned r = gf16mat_inv_m4f_32( mat_Ainv , temp );
    if( 0==r ) return 0;

    gf256mat_submat( temp , a_veclen_byte_2 , 0 , matA+a_veclen_byte*a_n_vec_2 , a_veclen_byte , a_n_vec_2 );  // B
    gf16mat_colmat_mul_ref( mat_U_AinvB , mat_Ainv , a_veclen_byte_2 , a_n_vec_2  , temp , a_n_vec_2 );  // A^-1 x B

    gf256mat_submat( temp , a_veclen_byte_2 , a_veclen_byte_2  , matA , a_veclen_byte , a_n_vec_2 );  // C
    gf16mat_colmat_mul_ref( mat_CAinvB_inv , temp , a_veclen_byte_2 , a_n_vec_2 , mat_U_AinvB , a_n_vec_2 );
    gf256mat_submat( temp , a_veclen_byte_2 , a_veclen_byte_2 , matA+a_veclen_byte*a_n_vec_2 , a_veclen_byte , a_n_vec_2 );  // D
    gf256v_add( temp , mat_CAinvB_inv , a_veclen_byte_2*a_n_vec_2 );  // (D-CA^-1B)

    r &= gf16mat_inv_m4f_32( mat_CAinvB_inv , temp );
    if( 0==r ) return 0;

    gf256mat_submat( mat_L_C , a_veclen_byte_2 , a_veclen_byte_2 , matA , a_veclen_byte , a_n_vec_2 );  // C

    return r;
}

#define _O1 64
#define _O1_BYTE (_O1/2)
static void bench(void){
    unsigned char mat1[64*32], mat2[64*32];

    uint8_t submat_A[(_O1/2)*(_O1_BYTE/2)];
    uint8_t submat_B[(_O1/2)*(_O1_BYTE/2)];
    uint8_t submat_C[(_O1/2)*(_O1_BYTE/2)];
    uint8_t submat_D[(_O1/2)*(_O1_BYTE/2)];
    uint64_t t0, t1;

    for(int i=0; i<10; i++){
        hal_send_str("------");
        randombytes(mat1, sizeof mat1);
        memcpy(mat2, mat1, sizeof mat1);
        t0 = hal_get_time();
        gf16mat_inv_ref( mat1, mat1 , 32);
        t1 = hal_get_time();
        printcycles("gf16mat_inv(32) cycles:", t1-t0);


        t0 = hal_get_time();
        gf16mat_inv_m4f_32(mat2, mat2);
        t1 = hal_get_time();
        printcycles("gf16mat_inv_m4f_32 cycles:", t1-t0);

        t0 = hal_get_time();
        gf16mat_inv_ref( mat1, mat1 , 64);
        t1 = hal_get_time();
        printcycles("gf16mat_inv(64) cycles:", t1-t0);


        t0 = hal_get_time();
        gf16mat_inv_m4f_64(mat2, mat2);
        t1 = hal_get_time();
        printcycles("gf16mat_inv_m4f_64 cycles:", t1-t0);

        t0 = hal_get_time();
        gf16mat_LDUinv_m4f( submat_A, submat_B, submat_C, submat_D, mat1 , 64);
        t1 = hal_get_time();
        printcycles("gf16mat_LDUinv_m4f(64) cycles:", t1-t0);
    }

}


static int test(void){
    unsigned char mat1[64*64], mat2[64*64];

    int errcnt = 0;

    for(uint64_t i=0; i<(1LL<<4); i++){
        // gf16mat_inv_m4f_32
        randombytes(mat1, sizeof mat1);
        memcpy(mat2, mat1, sizeof mat1);

        gf16mat_inv_ref(mat1, mat1 , 32);

        gf16mat_inv_m4f_32(mat2, mat2);
        if(memcmp(mat1, mat2, sizeof mat1)){
            hal_send_str("gf16mat_inv_m4f_32 ERROR\n");
            errcnt++;
        } else {
            hal_send_str("OK");
        }

        // gf16mat_inv_m4f_64
        randombytes(mat1, sizeof mat1);
        memcpy(mat2, mat1, sizeof mat1);

        gf16mat_inv_ref(mat1, mat1 , 64);

        gf16mat_inv_m4f_64(mat2, mat2);
        if(memcmp(mat1, mat2, sizeof mat1)){
            hal_send_str("gf16mat_inv_m4f_64 ERROR\n");

            errcnt++;
        } else {
            hal_send_str("OK");
        }

    }
    return errcnt;
}


int main(void){
    hal_setup(CLOCK_BENCHMARK);
    hal_send_str("==========================\n");

    unsigned int errcnt = test();
    bench();
    send_unsigned("errcnt=", errcnt);

    hal_send_str("#\n");
    while(1);
    return 0;
}