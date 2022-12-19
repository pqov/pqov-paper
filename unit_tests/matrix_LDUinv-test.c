
#include <stdio.h>



#include "blas.h"
#include "blas_comm.h"
#include "blas_matrix.h"

#include "utils_prng.h"

#include "utils.h"

#include "string.h"


#if 0
static inline
void gf256mat_transpose( uint8_t * mat , unsigned len )
{
  for(unsigned i=0;i<len;i++) {
    for(unsigned j=i+1;j<len;j++) {
      uint8_t tmp = mat[i*len+j];
      mat[i*len+j] = mat[j*len+i];
      mat[j*len+i] = tmp;
    }
  }
}
#endif

static inline
void gf256mat_submat_fill( uint8_t * mat , unsigned veclen_byte , unsigned st , const uint8_t *submat, unsigned s_veclen_byte, unsigned n )
{
  for(unsigned i=0;i<n;i++) {
    for(unsigned j=0;j<s_veclen_byte;j++) mat[i*veclen_byte+st+j] = submat[i*s_veclen_byte+j];
  }
}

static inline
void gf256mat_identity( uint8_t *mat , unsigned w )
{
  gf256v_set_zero( mat , w*w );
  for(unsigned i=0;i<w;i++) mat[i*w+i] = 1;
}


#include "benchmark.h"

//#define LEN  32
//#define LEN  44
//#define LEN  72
#define LEN  96


#define LEN_2  (LEN/2)

#define TEST_RUN 100



int main()
{
	struct benchmark bm0, bm1;
	bm_init( &bm0 );
	bm_init( &bm1 );


	printf("====== unit test ======\n");
	printf("mat[%dx%d]: testing if LDU inversion and Gauss elimination produce same inverse matrix.\n\n", LEN , LEN );


	printf("\n\n============= setup PRNG ==============\n");

	prng_t _prng;
	prng_t * prng0 = &_prng;
	uint8_t prng_seed[32] = {0};
	prng_set( prng0 , prng_seed );

	printf("\n\n============= random matrix generation ==============\n");

	uint8_t matA[ LEN*LEN ];
	uint8_t matB[ LEN*LEN ];
	uint8_t matC[ LEN*LEN ];

	uint8_t submat_A[ LEN_2*LEN_2];
	uint8_t submat_B[ LEN_2*LEN_2];
	uint8_t submat_C[ LEN_2*LEN_2];
	uint8_t submat_D[ LEN_2*LEN_2];

	uint8_t tmp[ LEN_2*LEN_2 ];

	uint8_t mat1[LEN*LEN];
	uint8_t mat2[LEN*LEN];
	uint8_t mat3[LEN*LEN];

for(int j=0;j<TEST_RUN;j++) {
	prng_gen( prng0 , matA , LEN*LEN );
	//gf256v_set_zero( matA , sizeof(matA) );
	//for(int k=0;k<LEN;k++) matA[k*LEN+k] = 1;

	//for(int i=0;i<LEN;i++) {
	//	byte_fdump( stdout , "matA: " , &matA[i*LEN/2] , LEN/2 ); printf("\n");
	//}
	int inv1;
BENCHMARK( bm0 , {
	inv1 = gf256mat_inv( matB , matA , LEN );
} );
	//printf("inv: %d\n", inv );
	//gf256mat_transpose( matB , LEN );
	//gf256v_set_zero( matB , sizeof(matB) );
	//for(int k=0;k<LEN;k++) matB[k*LEN+k] = 1;
	//for(int i=0;i<LEN;i++) {
	//	byte_fdump( stdout , "matB: " , &matB[i*LEN/2] , LEN/2 ); printf("\n");
	//}

	int inv2;
BENCHMARK( bm1 , {
	inv2 = gf256mat_LDUinv( submat_B , submat_A , submat_D , submat_C , matA , LEN );
} );

	if( inv1 != inv2 ) {
		printf("inv1 != inv2:  %d!=%d\n", inv1 , inv2 );
		continue;
	}
//
//  return : [ 1 B ] [ A 0 ] [ 1 0 ]
//           [ 0 1 ] [ 0 D ] [ C 1 ]
// however,
// mat_inv = [ 1  B ] [ A  0 ] [ 1   0 ]
//           [ 0  1 ] [ 0  D ] [ CxA 1 ]
//
#if 1
	// column-major code
	// CA
	gf256mat_colmat_mul( tmp , submat_C , LEN_2 , LEN_2 , submat_A , LEN_2 );  // C x A , column-major matrix
	gf256mat_identity( mat1 , LEN );
	gf256mat_submat_fill( mat1 , LEN , LEN_2 , tmp , LEN_2 , LEN_2 );

	// A , D
	gf256v_set_zero( mat2 , LEN*LEN );
	gf256mat_submat_fill( mat2 , LEN , 0 , submat_A , LEN_2 , LEN_2 );
	gf256mat_submat_fill( mat2+LEN_2*LEN , LEN , LEN_2 , submat_D , LEN_2 , LEN_2 );

	gf256mat_colmat_mul( mat3 , mat2 , LEN , LEN , mat1 , LEN );
	// [ A 0 ] x  [ 1   0 ]
	// [ 0 D ]    [ CxA 1 ]

	gf256mat_identity( mat1 , LEN );
	gf256mat_submat_fill( mat1+LEN*LEN_2 , LEN , 0 , submat_B , LEN_2 , LEN_2 );

	gf256mat_colmat_mul( matC , mat1 , LEN , LEN , mat3 , LEN );
#else
	// row-major code
	// CA^-1
	gf256mat_rowmat_mul( tmp , submat_C , LEN_2 , LEN_2 , submat_A , LEN_2 );
	gf256mat_identity( mat1 , LEN );
	gf256mat_submat_fill( mat1 + LEN_2*LEN , LEN , 0 , tmp , LEN_2 , LEN_2 );

	// A , D
	gf256v_set_zero( mat2 , LEN*LEN );
	gf256mat_submat_fill( mat2 , LEN , 0 , submat_A , LEN_2 , LEN_2 );
	gf256mat_submat_fill( mat2+LEN_2*LEN , LEN , LEN_2 , submat_D , LEN_2 , LEN_2 );

	gf256mat_rowmat_mul( mat3 , mat2 , LEN , LEN , mat1 , LEN );

	// A^-1B
	gf256mat_identity( mat1 , LEN );
	gf256mat_submat_fill( mat1 , LEN , LEN_2 , submat_B , LEN_2 , LEN_2 );

	gf256mat_rowmat_mul( matC , mat1 , LEN , LEN , mat3 , LEN );
#endif

	// test equal
	memcpy( mat1 , matB , LEN*LEN );
	gf256v_add( mat1 , matC , LEN*LEN );
	if( !gf256v_is_zero( mat1 , LEN*LEN ) ) {
		printf("[%d] two results differ\n", j );
		break;
	}
}
	printf("if no error message -> [%d] test pass.\n\n", TEST_RUN );


	char msg[256];
	bm_dump( msg , 256 , &bm0 );
	printf("mat inv with gaussian: %s\n", msg );
	bm_dump( msg , 256 , &bm1 );
	printf("mat inv with LDU decomp: %s\n", msg );
	printf("\n\n");

	return 0;
}

