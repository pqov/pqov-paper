#include <stdlib.h>
#include "randombytes.h"
#include "hal.h"
#include "sendfn.h"
#include "gf256_asm.h"
#include "blas_comm.h"
#include "blas_u32.h"
#include "blas.h"

// #include <string.h>
// #include <stdint.h>


#define printcycles(S, U) send_unsignedll((S), (U))

#define _V1 68
#define _O1 44
#define _V1_BYTE (_V1)
#define _O1_BYTE (_O1)



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



static void bench(void){
    unsigned char mat1[_O1*_O1_BYTE], mat2[_O1*_O1_BYTE];

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
        gf256mat_inv_m4f_44(mat2, mat2);
        t1 = hal_get_time();
        printcycles("gf256mat_inv_m4f_44 cycles:", t1-t0);


        t0 = hal_get_time();
        gf256mat_inv_m4f_22(mat2, mat2);
        t1 = hal_get_time();
        printcycles("gf256mat_inv_m4f_22 cycles:", t1-t0);

        t0 = hal_get_time();
        gf256mat_LDUinv_m4f( submat_A, submat_B, submat_C, submat_D, mat1 , 44);
        t1 = hal_get_time();
        printcycles("gf256mat_LDUinv_m4f(44) cycles:", t1-t0);
    }

}

int main(void){
    hal_setup(CLOCK_BENCHMARK);
    hal_send_str("==========================\n");
    bench();

    hal_send_str("#\n");
    while(1);
    return 0;
}