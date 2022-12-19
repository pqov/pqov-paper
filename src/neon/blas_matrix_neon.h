/// @file blas_matrix_neon.h
/// @brief linear algebra functions for matrix operations, specialized for neon instruction set.
///

#ifndef _BLAS_MATRIX_NEON_H_
#define _BLAS_MATRIX_NEON_H_


#include "stdint.h"



#ifdef  __cplusplus
extern  "C" {
#endif





///////////////////////////////  GF( 16 ) ////////////////////////////////////////////////////

/// @brief  c = matA * b , GF(16)
///
/// @param[out]   c         - the output vector c
/// @param[in]   matA       - the matrix A.
/// @param[in]   n_A_vec_byte    - the size of column vectors in A.
/// @param[in]   n_A_width       - the width of matrix A.
/// @param[in]   b_multab        - the vector b, in multiplication tables.
///
void gf16mat_prod_multab_neon( uint8_t * c , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * b_multab );


/// @brief  c = mat_a * b , GF(16)
///
/// @param[out]   c         - the output vector c
/// @param[in]   mat_a       - the matrix a.
/// @param[in]   a_h_byte    - the size of column vectors in a.
/// @param[in]   a_w        - the width of matrix a.
/// @param[in]   b           - the vector b.
///
void gf16mat_prod_neon( uint8_t * c , const uint8_t * mat_a , unsigned a_h_byte , unsigned a_w , const uint8_t * b );



///////////////////////////////  GF( 256 ) ////////////////////////////////////////////////////



/// @brief  c = matA * b , GF(256)
///
/// @param[out]   c         - the output vector c
/// @param[in]   matA       - the matrix A.
/// @param[in]   n_A_vec_byte    - the size of column vectors in A.
/// @param[in]   n_A_width       - the widht of matrix A.
/// @param[in]   b_multab        - the vector b, in multiplication tables.
///
void gf256mat_prod_multab_neon( uint8_t * c , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * multab );




/// @brief  c = matA * b , GF(256)
///
/// @param[out]   c         - the output vector c
/// @param[in]   matA       - the matrix A.
/// @param[in]   n_A_vec_byte   - the size of column vectors in a.
/// @param[in]   n_A_width    - the width of matrix a.
/// @param[in]   b           - the vector b.
///
void gf256mat_prod_neon( uint8_t * c , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * b );




////////////////////////////////


/// @brief Computing the inverse matrix, in GF(16)
///
/// @param[out]  inv_a     - the output of matrix a.
/// @param[in]   a         - a matrix a.
/// @param[in]   dim       - the dimension of the matrix a.
/// @return   1(true) if success. 0(false) if the matrix is singular.
///
unsigned gf16mat_inv_neon(uint8_t *inv_a, const uint8_t *a , unsigned dim );


////////////////////////////////


/// @brief Computing the inverse matrix, in GF(256)
///
/// @param[out]  inv_a     - the output of matrix a.
/// @param[in]   a         - a matrix a.
/// @param[in]   dim       - the dimension of the matrix a.
/// @return   1(true) if success. 0(false) if the matrix is singular.
///
unsigned gf256mat_inv_neon(uint8_t *inv_a, const uint8_t *a , unsigned dim );






unsigned gf256mat_gaussian_elim_neon(uint8_t *sq_col_mat_a , uint8_t *constant, unsigned len);

void gf256mat_back_substitute_neon( uint8_t *constant, const uint8_t *sq_row_mat_a, unsigned len);

unsigned gf16mat_gaussian_elim_neon(uint8_t *sq_col_mat_a , uint8_t *constant, unsigned len);

void gf16mat_back_substitute_neon( uint8_t *constant, const uint8_t *sq_row_mat_a, unsigned len);





#ifdef  __cplusplus
}
#endif



#endif //  _BLAS_MATRIX_NEON_H_

