//// @file blas_matrix.c
/// @brief The standard implementations for blas_matrix.h
///

#include "blas_comm.h"
#include "blas_matrix.h"
#include "blas.h"
#include "params.h"



// choosing the implementations depends on the macros _BLAS_AVX2_ and _BLAS_SSE_


#if defined( _BLAS_AVX2_ )

#include "blas_matrix_avx2.h"

#define gf16mat_prod_impl             gf16mat_prod_avx2
#define gf256mat_prod_impl            gf256mat_prod_avx2

#define gf16mat_inv_impl              gf16mat_inv_avx2
#define gf256mat_inv_impl             gf256mat_inv_avx2

#define gf16mat_prod_multab_impl      gf16mat_prod_multab_avx2
#define gf256mat_prod_multab_impl     gf256mat_prod_multab_avx2


#include "blas_matrix_ref.h"

#define gf16mat_rowmat_mul_impl             gf16mat_rowmat_mul_ref
#define gf256mat_rowmat_mul_impl            gf256mat_rowmat_mul_ref
#define gf16mat_colmat_mul_impl             gf16mat_colmat_mul_ref
#define gf256mat_colmat_mul_impl            gf256mat_colmat_mul_ref

#define gf256mat_LDUinv_impl          gf256mat_LDUinv_ref
#define gf256mat_LDUinv_prod_impl     gf256mat_LDUinv_prod_ref
#define gf16mat_LDUinv_impl          gf16mat_LDUinv_ref
#define gf16mat_LDUinv_prod_impl     gf16mat_LDUinv_prod_ref


#define gf256mat_gaussian_elim_impl   gf256mat_gaussian_elim_avx2
#define gf256mat_back_substitute_impl gf256mat_back_substitute_avx2
#define gf16mat_gaussian_elim_impl   gf16mat_gaussian_elim_avx2
#define gf16mat_back_substitute_impl gf16mat_back_substitute_avx2


#elif defined( _BLAS_SSE_ )

#include "blas_matrix_sse.h"

#define gf16mat_prod_impl             gf16mat_prod_sse
#define gf256mat_prod_impl            gf256mat_prod_sse

#define gf16mat_inv_impl              gf16mat_inv_sse
#define gf256mat_inv_impl             gf256mat_inv_sse

#define gf16mat_prod_multab_impl      gf16mat_prod_multab_sse
#define gf256mat_prod_multab_impl     gf256mat_prod_multab_sse


#include "blas_matrix_ref.h"

#define gf16mat_rowmat_mul_impl             gf16mat_rowmat_mul_ref
#define gf256mat_rowmat_mul_impl            gf256mat_rowmat_mul_ref
#define gf16mat_colmat_mul_impl             gf16mat_colmat_mul_ref
#define gf256mat_colmat_mul_impl            gf256mat_colmat_mul_ref

#define gf256mat_LDUinv_impl          gf256mat_LDUinv_ref
#define gf256mat_LDUinv_prod_impl     gf256mat_LDUinv_prod_ref
#define gf16mat_LDUinv_impl          gf16mat_LDUinv_ref
#define gf16mat_LDUinv_prod_impl     gf16mat_LDUinv_prod_ref

#define gf256mat_gaussian_elim_impl   gf256mat_gaussian_elim_ref
#define gf256mat_back_substitute_impl gf256mat_back_substitute_ref
#define gf16mat_gaussian_elim_impl   gf16mat_gaussian_elim_ref
#define gf16mat_back_substitute_impl gf16mat_back_substitute_ref


#elif defined( _BLAS_NEON_ )

#include "blas_matrix_neon.h"

#define gf16mat_prod_impl             gf16mat_prod_neon
#define gf16mat_inv_impl              gf16mat_inv_neon

#define gf256mat_prod_impl            gf256mat_prod_neon
#define gf256mat_inv_impl             gf256mat_inv_neon

#define gf16mat_prod_multab_impl      gf16mat_prod_multab_neon
#define gf256mat_prod_multab_impl     gf256mat_prod_multab_neon

#include "blas_matrix_ref.h"

#define gf16mat_rowmat_mul_impl             gf16mat_rowmat_mul_ref
#define gf256mat_rowmat_mul_impl            gf256mat_rowmat_mul_ref
#define gf16mat_colmat_mul_impl             gf16mat_colmat_mul_ref
#define gf256mat_colmat_mul_impl            gf256mat_colmat_mul_ref

#define gf256mat_LDUinv_impl          gf256mat_LDUinv_ref
#define gf256mat_LDUinv_prod_impl     gf256mat_LDUinv_prod_ref
#define gf16mat_LDUinv_impl          gf16mat_LDUinv_ref
#define gf16mat_LDUinv_prod_impl     gf16mat_LDUinv_prod_ref


#define gf256mat_gaussian_elim_impl   gf256mat_gaussian_elim_neon
#define gf256mat_back_substitute_impl gf256mat_back_substitute_neon
#define gf16mat_gaussian_elim_impl    gf16mat_gaussian_elim_neon
#define gf16mat_back_substitute_impl  gf16mat_back_substitute_neon


#elif defined( _BLAS_M4F_)

#include "blas_matrix_m4f.h"
#include "blas_matrix_ref.h"

#ifdef _USE_GF16
#define gf16mat_prod_impl             gf16mat_prod_m4f
#define gf16mat_inv_impl              gf16mat_inv_m4f
#define gf16mat_rowmat_mul_impl       gf16mat_rowmat_mul_ref
#define gf16mat_colmat_mul_impl       gf16mat_colmat_mul_ref

#define gf16mat_LDUinv_impl           gf16mat_LDUinv_m4f
//TODO: check how this is implemented
#define gf16mat_LDUinv_prod_impl      gf16mat_LDUinv_prod_ref

#define gf16mat_gaussian_elim_impl   gf16mat_gaussian_elim_m4f
#define gf16mat_back_substitute_impl gf16mat_back_substitute_ref

#else
#define gf256mat_prod_impl            gf256mat_prod_m4f
#define gf256mat_inv_impl             gf256mat_inv_m4f
#define gf256mat_rowmat_mul_impl      gf256mat_rowmat_mul_ref
#define gf256mat_colmat_mul_impl      gf256mat_colmat_mul_ref
#define gf256mat_LDUinv_impl          gf256mat_LDUinv_m4f
//TODO: check how this is implemented
#define gf256mat_LDUinv_prod_impl     gf256mat_LDUinv_prod_ref

#define gf256mat_gaussian_elim_impl   gf256mat_gaussian_elim_m4f
#define gf256mat_back_substitute_impl gf256mat_back_substitute_ref

#endif

#else

#include "blas_matrix_ref.h"

#define gf16mat_prod_impl             gf16mat_prod_ref
#define gf256mat_prod_impl            gf256mat_prod_ref

#define gf16mat_inv_impl              gf16mat_inv_ref
#define gf256mat_inv_impl             gf256mat_inv_ref

#define gf16mat_rowmat_mul_impl             gf16mat_rowmat_mul_ref
#define gf256mat_rowmat_mul_impl            gf256mat_rowmat_mul_ref
#define gf16mat_colmat_mul_impl             gf16mat_colmat_mul_ref
#define gf256mat_colmat_mul_impl            gf256mat_colmat_mul_ref

#define gf256mat_LDUinv_impl          gf256mat_LDUinv_ref
#define gf256mat_LDUinv_prod_impl     gf256mat_LDUinv_prod_ref
#define gf16mat_LDUinv_impl          gf16mat_LDUinv_ref
#define gf16mat_LDUinv_prod_impl     gf16mat_LDUinv_prod_ref

#define gf256mat_gaussian_elim_impl   gf256mat_gaussian_elim_ref
#define gf256mat_back_substitute_impl gf256mat_back_substitute_ref
#define gf16mat_gaussian_elim_impl   gf16mat_gaussian_elim_ref
#define gf16mat_back_substitute_impl gf16mat_back_substitute_ref

#endif


#ifdef _USE_GF16
void gf16mat_prod(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b)
{
    gf16mat_prod_impl( c, matA, n_A_vec_byte, n_A_width, b);
}

#if defined(_MUL_WITH_MULTAB_)

void gf16mat_prod_multab(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b)
{
    gf16mat_prod_multab_impl( c, matA, n_A_vec_byte, n_A_width, b);
}
#endif

void gf16mat_rowmat_mul(uint8_t *matC, const uint8_t *matA, unsigned height_A, unsigned width_A_byte, const uint8_t *matB, unsigned width_B_byte)
{
    gf16mat_rowmat_mul_impl( matC, matA, height_A, width_A_byte, matB, width_B_byte);
}

void gf16mat_colmat_mul(uint8_t *mat_c, const uint8_t *mat_a, unsigned a_veclen_byte, unsigned a_n_vec, const uint8_t *mat_b, unsigned b_n_vec)
{
    gf16mat_colmat_mul_impl( mat_c , mat_a , a_veclen_byte , a_n_vec , mat_b , b_n_vec );
}

unsigned gf16mat_inv( uint8_t * inv_a , const uint8_t * a , unsigned len )
{
    return gf16mat_inv_impl( inv_a , a , len );
}
unsigned gf16mat_LDUinv(uint8_t *mat_U_AinvB, uint8_t *mat_Ainv, uint8_t *mat_CAinvB_inv, uint8_t *mat_L_C, const uint8_t *matA , unsigned len)
{
    return gf16mat_LDUinv_impl( mat_U_AinvB , mat_Ainv , mat_CAinvB_inv , mat_L_C , matA , len );
}

void gf16mat_LDUinv_prod(uint8_t *c, const uint8_t *mat_U_AinvB, const uint8_t *mat_Ainv, const uint8_t *mat_CAinvB_inv, const uint8_t *mat_L_C, const uint8_t * b , unsigned len)
{
    gf16mat_LDUinv_prod_impl( c , mat_U_AinvB , mat_Ainv , mat_CAinvB_inv , mat_L_C , b , len );
}

unsigned gf16mat_gaussian_elim(uint8_t *sqmat_a , uint8_t *constant, unsigned len)
{
    return gf16mat_gaussian_elim_impl(sqmat_a, constant, len );

}

void gf16mat_back_substitute( uint8_t *constant, const uint8_t *sqmat_a, unsigned len)
{
    gf16mat_back_substitute_impl( constant , sqmat_a , len );
}

#else
void gf256mat_prod(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b)
{
    gf256mat_prod_impl( c, matA, n_A_vec_byte, n_A_width, b);
}

#if defined(_MUL_WITH_MULTAB_)
void gf256mat_prod_multab(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b)
{
    gf256mat_prod_multab_impl( c, matA, n_A_vec_byte, n_A_width, b);
}


#endif

void gf256mat_rowmat_mul(uint8_t *matC, const uint8_t *matA, unsigned height_A, unsigned width_A_byte, const uint8_t *matB, unsigned width_B_byte)
{
    gf256mat_rowmat_mul_impl( matC, matA, height_A, width_A_byte, matB, width_B_byte);
}

void gf256mat_colmat_mul(uint8_t *mat_c, const uint8_t *mat_a, unsigned a_veclen_byte, unsigned a_n_vec, const uint8_t *mat_b, unsigned b_n_vec)
{
    gf256mat_colmat_mul_impl( mat_c , mat_a , a_veclen_byte , a_n_vec , mat_b , b_n_vec );
}

unsigned gf256mat_inv( uint8_t * inv_a , const uint8_t * a , unsigned len )
{
    return gf256mat_inv_impl( inv_a , a , len );
}

unsigned gf256mat_LDUinv(uint8_t *mat_U_AinvB, uint8_t *mat_Ainv, uint8_t *mat_CAinvB_inv, uint8_t *mat_L_C, const uint8_t *matA , unsigned len)
{
    return gf256mat_LDUinv_impl( mat_U_AinvB , mat_Ainv , mat_CAinvB_inv , mat_L_C , matA , len );
}

void gf256mat_LDUinv_prod(uint8_t *c, const uint8_t *mat_U_AinvB, const uint8_t *mat_Ainv, const uint8_t *mat_CAinvB_inv, const uint8_t *mat_L_C, const uint8_t * b , unsigned len)
{
    gf256mat_LDUinv_prod_impl( c , mat_U_AinvB , mat_Ainv , mat_CAinvB_inv , mat_L_C , b , len );
}



unsigned gf256mat_gaussian_elim(uint8_t *sqmat_a , uint8_t *constant, unsigned len)
{
    return gf256mat_gaussian_elim_impl(sqmat_a, constant, len );

}

void gf256mat_back_substitute( uint8_t *constant, const uint8_t *sqmat_a, unsigned len)
{
    gf256mat_back_substitute_impl( constant , sqmat_a , len );
}


#endif
