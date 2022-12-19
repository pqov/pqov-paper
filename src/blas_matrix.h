/// @file blas_matrix.h
/// @brief linear algebra functions for matrix op.
///
#ifndef _BLAS_MATRIX_H_
#define _BLAS_MATRIX_H_

#include <stdint.h>



#ifdef  __cplusplus
extern  "C" {
#endif


///////////////// Section: multiplications  ////////////////////////////////
///// matrix-vector /////

/// @brief matrix-vector multiplication:  c = matA * b , in GF(16)
///
/// @param[out]  c         - the output vector c
/// @param[in]   matA      - a column-major matrix A.
/// @param[in]   n_A_vec_byte  - the size of column vectors in bytes.
/// @param[in]   n_A_width   - the width of matrix A.
/// @param[in]   b          - the vector b.
///
void gf16mat_prod(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b);


/// @brief matrix-vector multiplication:  c = matA * b , in GF(256)
///
/// @param[out]  c         - the output vector c
/// @param[in]   matA      - a column-major matrix A.
/// @param[in]   n_A_vec_byte  - the size of column vectors in bytes.
/// @param[in]   n_A_width   - the width of matrix A.
/// @param[in]   b          - the vector b.
///
void gf256mat_prod(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b);


/// @brief matrix-vector multiplication:  c = matA * b , in GF(16)
///
/// @param[out]  c         - the output vector c
/// @param[in]   matA      - a column-major matrix A.
/// @param[in]   n_A_vec_byte  - the size of column vectors in bytes.
/// @param[in]   n_A_width   - the width of matrix A.
/// @param[in]   multab_b     - the multiplication tables of the vector b.
///
void gf16mat_prod_multab(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *multab_b);


/// @brief matrix-vector multiplication:  c = matA * b , in GF(256)
///
/// @param[out]  c         - the output vector c
/// @param[in]   matA      - a column-major matrix A.
/// @param[in]   n_A_vec_byte  - the size of column vectors in bytes.
/// @param[in]   n_A_width   - the width of matrix A.
/// @param[in]   multab_b     - the multiplication tabls of the vector b.
///
void gf256mat_prod_multab(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *multab_b);


///// matrix-matrix /////


/// @brief matrix multiplication:  matC = matA * matB , in GF(16)
///
/// @param[out]  matC         - the output row-major matrix C
/// @param[in]   matA         - a row-major matrix A.
/// @param[in]   height_A     - the number of row vectors in the matrix A.
/// @param[in]   width_A_byte  - the size of row vectors of A in bytes.
/// @param[in]   matB            - a row-major matrix B.
/// @param[in]   width_B_byte  - the size of row vectors of B in bytes.
///
void gf16mat_rowmat_mul(uint8_t *matC, const uint8_t *matA, unsigned height_A, unsigned width_A_byte, const uint8_t *matB, unsigned width_B_byte);


/// @brief (column-major) matrix multiplication:  matC = matA * matB , in GF(16)
///
/// @param[out]  matC         - the output column-major matrix C
/// @param[in]   mat_a          - a column-major matrix A.
/// @param[in]   a_veclen_byte  - the vector length (height) of the matrix A in byte.
/// @param[in]   a_n_vec        - the number of vectors (width) in the matrix A.
/// @param[in]   mat_b          - a column-major matrix B.
/// @param[in]   b_n_vec        - the number of vectors in the matrix B.
///
void gf16mat_colmat_mul(uint8_t *mat_c, const uint8_t *mat_a, unsigned a_veclen_byte, unsigned a_n_vec, const uint8_t *mat_b, unsigned b_n_vec);


/// @brief matrix multiplication:  matC = matA * matB , in GF(16)
///
/// @param[out]  matC         - the output row-major matrix C
/// @param[in]   matA         - a row-major matrix A.
/// @param[in]   height_A     - the number of row vectors in the matrix A.
/// @param[in]   width_A_byte  - the size of row vectors of A in bytes.
/// @param[in]   matB            - a row-major matrix B.
/// @param[in]   width_B_byte  - the size of row vectors of B in bytes.
///
void gf256mat_rowmat_mul(uint8_t *matC, const uint8_t *matA, unsigned height_A, unsigned width_A_byte, const uint8_t *matB, unsigned width_B_byte);


/// @brief (column-major) matrix multiplication:  matC = matA * matB , in GF(256)
///
/// @param[out]  matC         - the output column-major matrix C
/// @param[in]   mat_a          - a column-major matrix A.
/// @param[in]   a_veclen_byte  - the vector length (height) of the matrix A in byte.
/// @param[in]   a_n_vec        - the number of vectors (width) in the matrix A.
/// @param[in]   mat_b          - a column-major matrix B.
/// @param[in]   b_n_vec        - the number of vectors in the matrix B.
///
void gf256mat_colmat_mul(uint8_t *mat_c, const uint8_t *mat_a, unsigned a_veclen_byte, unsigned a_n_vec, const uint8_t *mat_b, unsigned b_n_vec);



/////////////////////////////////////////////////////




/// @brief Computing the inverse matrix, in GF(16)
///
/// @param[out]  inv_a     - the inverse of matrix a.
/// @param[in]   a         - a matrix a.
/// @param[in]   len       - the width of the matrix a, number of gf elements.
/// @return   1(true) if success. 0(false) if the matrix is singular.
///
unsigned gf16mat_inv(uint8_t *inv_a, const uint8_t *a , unsigned len);


/// @brief Computing the inverse matrix, in GF(256)
///
/// @param[out]  inv_a     - the inverse of matrix a.
/// @param[in]   a         - a matrix a.
/// @param[in]   len       - the width of the matrix a, number of gf elements.
/// @return   1(true) if success. 0(false) if the matrix is singular.
///
unsigned gf256mat_inv(uint8_t *inv_a, const uint8_t *a , unsigned len);





//////////////////////////  Gaussian for solving lienar equations ///////////////////////////




/// @brief Computing the row echelon form of a matrix, in GF(16)
///
/// @param[in,out]  sq_col_mat_a   - square matrix parts of a linear system. a is a column major matrix.
///                                  The returned matrix of row echelon form is a row major matrix. 
/// @param[in,out]  constant       - constant parts of a linear system.
/// @param[in]           len       - the width of the matrix a, i.e., the number of column vectors.
/// @return   1(true) if success. 0(false) if the matrix is singular.
///
unsigned gf16mat_gaussian_elim(uint8_t *sq_col_mat_a , uint8_t *constant, unsigned len);

/// @brief Back substitution of the constant terms with a row echelon form of a matrix, in GF(16)
///
/// @param[in,out]  constant       - constant parts of a linear system.
/// @param[in]     sq_row_mat_a    - row echelon form of a linear system.
/// @param[in]           len       - the height of the matrix a, i.e., the number of row vectors.
///
void gf16mat_back_substitute( uint8_t *constant, const uint8_t *sq_row_mat_a, unsigned len);

/// @brief Computing the row echelon form of a matrix, in GF(256)
///
/// @param[in,out]  sq_col_mat_a   - square matrix parts of a linear system. a is a column major matrix.
///                                  The returned matrix of row echelon form is a row major matrix. 
/// @param[in,out]  constant       - constant parts of a linear system.
/// @param[in]           len       - the width of the matrix a, i.e., the number of column vectors.
/// @return   1(true) if success. 0(false) if the matrix is singular.
///
unsigned gf256mat_gaussian_elim(uint8_t *sq_col_mat_a , uint8_t *constant, unsigned len);

/// @brief Back substitution of the constant terms with a row echelon form of a matrix, in GF(16)
///
/// @param[in,out]  constant       - constant parts of a linear system.
/// @param[in]     sq_row_mat_a    - row echelon form of a linear system.
/// @param[in]           len       - the height of the matrix a, i.e., the number of row vectors.
///
void gf256mat_back_substitute( uint8_t *constant, const uint8_t *sq_row_mat_a, unsigned len);




///////////////////  LDU decomposition  /////////////////////

/// @brief Computing the inverse matrix, LDU decomposition form, in GF(256)
///
/// @param[out]  inv_a     - the inverse of matrix a.
/// @param[in]   matA         - a matrix A.
/// @param[in]   len       - the width of the matrix A, number of gf elements.
/// @return   1(true) if success. 0(false) if the matrix is singular.
///
unsigned gf256mat_LDUinv(uint8_t *mat_U_AinvB, uint8_t *mat_Ainv, uint8_t *mat_CAinvB_inv, uint8_t *mat_L_C, const uint8_t *matA , unsigned len);

void gf256mat_LDUinv_prod(uint8_t *c, const uint8_t *mat_U_AinvB, const uint8_t *mat_Ainv, const uint8_t *mat_CAinvB_inv, const uint8_t *mat_L_C, const uint8_t * b , unsigned len);



unsigned gf16mat_LDUinv(uint8_t *mat_U_AinvB, uint8_t *mat_Ainv, uint8_t *mat_CAinvB_inv, uint8_t *mat_L_C, const uint8_t *matA , unsigned mat_dim);

void gf16mat_LDUinv_prod(uint8_t *c, const uint8_t *mat_U_AinvB, const uint8_t *mat_Ainv, const uint8_t *mat_CAinvB_inv, const uint8_t *mat_L_C, const uint8_t * b , unsigned veclen_byte);





#ifdef  __cplusplus
}
#endif

#endif  // _BLAS_MATRIX_H_

