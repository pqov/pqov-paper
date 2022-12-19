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


#define _V1 96
#define _O1 64
#define _O1_BYTE (_O1/2)
#define _PUB_N  (_V1+_O1)
#define _PUB_N_BYTE (_PUB_N/2)
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

static void gf16mat_rowmat_mul_ref(uint8_t *matC, const uint8_t *matA, unsigned height_A, unsigned width_A_byte, const uint8_t *matB, unsigned width_B_byte)
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


static void gf16mat_colmat_mul_ref(uint8_t *mat_c, const uint8_t *mat_a, unsigned a_veclen_byte, unsigned a_n_vec, const uint8_t *mat_b, unsigned b_n_vec)
{
    gf16mat_rowmat_mul_ref( mat_c , mat_b , b_n_vec , (a_n_vec+1)>>1 , mat_a , a_veclen_byte );
}



static unsigned gf16mat_LDUinv_m4f(uint8_t *mat_U_AinvB, uint8_t *mat_Ainv, 
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



#define _MAX_LEN  256
static void gf16mat_prod_ref(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b) {
    gf256v_set_zero(c, n_A_vec_byte);
    for (unsigned i = 0; i < n_A_width; i++) {
        uint8_t bb = gf16v_get_ele(b, i);
        gf16v_madd(c, matA, bb, n_A_vec_byte);
        matA += n_A_vec_byte;
    }
}
// LDU_inv = [ 1  -A^-1 B ] [ A^-1         0       ] [    1      0 ]    x  [b_u]
//           [ 0     1    ] [  0     (D-CA^-1B)^-1 ] [ -C A^-1   1 ]       [b_b]

static void gf16mat_LDUinv_prod_ref(uint8_t *c, const uint8_t *mat_U_AinvB, const uint8_t *mat_Ainv, const uint8_t *mat_CAinvB_inv, const uint8_t *mat_L_C,
        const uint8_t * b , unsigned veclen_byte)
{
    uint8_t temp[_MAX_LEN];
    unsigned veclen_byte_2 = veclen_byte/2;
    unsigned n_vec_2 = veclen_byte;

    // TODO: replace those with asm
    gf16mat_prod_ref( c       , mat_Ainv , veclen_byte_2 , n_vec_2 , b );  //   A^-1 x b_u

    gf16mat_prod_ref( temp , mat_L_C , veclen_byte_2 , n_vec_2 , c );    //  C x  (A^-1xb_u)
    gf256v_add( temp , b+veclen_byte_2 , veclen_byte_2 );     //   C x  (A^-1xb_u) + b_b
    gf16mat_prod_ref( c+veclen_byte_2 , mat_CAinvB_inv , veclen_byte_2 , n_vec_2 , temp );  //   (D-CA^-1B)^-1  x  (C x  (A^-1xb_u) + b_b)

    gf16mat_prod_ref( temp , mat_U_AinvB , veclen_byte_2 , n_vec_2 , c+veclen_byte_2 );
    gf256v_add( c , temp , veclen_byte_2 );
}



static
unsigned gf16mat_gauss_elim_row_echolen( uint8_t * mat , unsigned h , unsigned w_byte )
{
    unsigned r8 = 1;

    for(unsigned i=0;i<h;i++) {
        uint8_t * ai = mat + w_byte*i;
        //unsigned i_start = i-(i&(_BLAS_UNIT_LEN_-1));
        unsigned i_start = i>>1;

        for(unsigned j=i+1;j<h;j++) {
            uint8_t * aj = mat + w_byte*j;
            gf256v_conditional_add( ai + i_start , !gf16_is_nonzero(gf16v_get_ele(ai,i)) , aj + i_start , w_byte - i_start );
        }
        uint8_t pivot = gf16v_get_ele(ai,i);
        r8 &= gf16_is_nonzero(pivot);
        pivot = gf16_inv( pivot );
        gf16v_mul_scalar( ai + i_start  , pivot , w_byte - i_start );
        for(unsigned j=i+1;j<h;j++) {
            uint8_t * aj = mat + w_byte*j;
            gf16v_madd( aj + i_start , ai + i_start , gf16v_get_ele(aj,i) , w_byte - i_start );
        }
    }
    return r8;
}

void asm_dump(uint8_t *mat_ptr){
    hal_send_str("asm_extmat=");
    unsigned char str[100];
    mat_ptr+= 32;
    for(unsigned i=0;i<64;i++) {
        for(unsigned j=0;j<1;j++) {
            sprintf(str, "%02x", *mat_ptr);
            mat_ptr += 36;
            hal_send_str(str);
        }
    }
}

void asm_ext_matrix(uint8_t *mat, uint8_t *sqmat_a, uint8_t *constant){
    unsigned height = 64;
    unsigned width_o  = 64/2;
    unsigned width_n  = width_o+4;
    for(unsigned i=0;i<height;i++) {
        uint8_t * ai = mat + i*width_n;
        for(unsigned j=0;j<height;j++) {
           // transpose since sqmat_a is col-major
           gf16v_set_ele( ai , j , gf16v_get_ele(sqmat_a+j*width_o,i) );
        }
        ai[width_o] = gf16v_get_ele(constant,i);
    }
}

void asm_extract(uint8_t *sqmat_a, uint8_t *constant, uint8_t *mat){
    unsigned height = 64;
    unsigned width_o  = 64/2;
    unsigned width_n  = width_o+4;
    for(unsigned i=0;i<height;i++) {
        uint8_t * ai = mat + i*width_n;
        memcpy( sqmat_a+i*width_o , ai  , width_o ); // output a row-major matrix
        gf16v_set_ele(constant,i, ai[width_o] );
    }
}


static unsigned gf16mat_gaussian_elim_ref(uint8_t *sqmat_a , uint8_t *constant, unsigned len)
{
    const unsigned MAX_H=64;
    uint8_t mat[MAX_H*(MAX_H+4)];

    unsigned height = len;
    unsigned width_o  = len/2;
    unsigned width_n  = width_o+4;

    for(unsigned i=0;i<height;i++) {
        uint8_t * ai = mat + i*width_n;
        for(unsigned j=0;j<height;j++) {
           // transpose since sqmat_a is col-major
           gf16v_set_ele( ai , j , gf16v_get_ele(sqmat_a+j*width_o,i) );
        }
        ai[width_o] = gf16v_get_ele(constant,i);
    }

    unsigned char r8 = gf16mat_gauss_elim_row_echolen( mat , height , width_n );


    for(unsigned i=0;i<height;i++) {
        uint8_t * ai = mat + i*width_n;
        memcpy( sqmat_a+i*width_o , ai  , width_o ); // output a row-major matrix
        gf16v_set_ele(constant,i, ai[width_o] );
    }
    return r8;
}

static void gf16mat_back_substitute_ref( uint8_t *constant, const uint8_t *sq_row_mat_a, unsigned len)
{
    // const unsigned MAX_H=64;
    uint8_t column[64] = {0};
    unsigned width_byte = (len+1)/2;
    for(int i=len-1;i>0;i--) {
        for(int j=0;j<i;j++) {
           // row-major -> column-major, i.e., transpose
           uint8_t ele = gf16v_get_ele( sq_row_mat_a+width_byte*j , i );
           gf16v_set_ele( column , j , ele );
        }
        gf16v_set_ele( column , i , 0 );  // pad to last byte
        gf16v_madd( constant , column , gf16v_get_ele(constant,i) , (i+1)/2 );
    }
}


static unsigned gf16mat_gaussian_elim_m4f(uint8_t *sqmat_a , uint8_t *constant)
{
    uint8_t mat[_O1*(_O1_BYTE+4)];
    for(unsigned i=0;i<_O1;i++) {
        uint8_t * ai = mat + i*(_O1_BYTE+4);
        for(unsigned j=0;j<_O1;j++) {
           // transpose since sqmat_a is col-major
           gf16v_set_ele( ai , j , gf16v_get_ele(sqmat_a+j*_O1_BYTE,i) );
        }
        ai[_O1_BYTE] = gf16v_get_ele(constant,i);
    }

    unsigned char r8 = gf16mat_gauss_elim_row_echolen_64_asm(mat);

    for(unsigned i=0;i<_O1;i++) {
        uint8_t * ai = mat + i*(_O1_BYTE+4);
        memcpy( sqmat_a+i*_O1_BYTE , ai  , _O1_BYTE ); // output a row-major matrix
        gf16v_set_ele(constant,i, ai[_O1_BYTE] );
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
    int l1_succ = gf16mat_LDUinv_m4f( submat_B , submat_A , submat_D , submat_C , mat1 , _O1 );
    if( !l1_succ ) hal_send_str("not invertible");
    gf16mat_LDUinv_prod_ref( x_o1 , submat_B , submat_A , submat_D , submat_C , y , _O1_BYTE );
    t1 = hal_get_time();
    printcycles("linear equation solving using LDUinv:", t1-t0);



    t0 = hal_get_time();
    l1_succ = gf16mat_gaussian_elim_m4f(mat1, r_l1_F1);
    // if( !l1_succ ) hal_send_str("not invertible");
    gf16mat_back_substitute_ref(r_l1_F1, mat1, _O1);
    memcpy( x_o1 , r_l1_F1 , _O1_BYTE );
    t1 = hal_get_time();
    printcycles("linear equation solving using Gaussian elimination:", t1-t0);

    t0 = hal_get_time();
    l1_succ = gf16mat_gaussian_elim_m4f(mat1 , r_l1_F1);
    if( !l1_succ ) hal_send_str("not invertible");
    t1 = hal_get_time();
    printcycles("\tGaussian elimination:", t1-t0);


    t0 = hal_get_time();
    gf16mat_back_substitute_ref(r_l1_F1, mat1, _O1);
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

    // gf16mat_gaussian_elim_m4f(mat1, y1);
    // //gf16mat_gauss_elim_m4f_64(mat1, y1);
    // gf16mat_gaussian_elim_ref(mat2, y2, _O1);

    // if(memcmp(y1,y2,sizeof y1)){
    //     hal_send_str("ERROR (sub)!");
    // } else {
    //     hal_send_str("OK (sub)!");
    // }
    randombytes(mat1, sizeof mat1);
    randombytes(y1, sizeof y1);
    memcpy(mat2, mat1, sizeof mat1);
    memcpy(y2, y1, sizeof y1);

    // gf16mat_gaussian_elim_m4f(mat1, y1);
    gf16mat_gaussian_elim_m4f(mat1, y1);
    gf16mat_gaussian_elim_ref(mat2, y2, _O1);

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