
#include <stdio.h>



#include "blas.h"
#include "blas_comm.h"
#include "blas_matrix.h"

#include "utils_prng.h"

#include "utils.h"

#include "string.h"


//
//
//  Not maintained anymore
//
//


static inline
void gf16mat_dump( const uint8_t * mat , const char * lmsg , unsigned dim )
{
  unsigned len_byte = dim/2;
  for(unsigned i=0;i<dim;i++) {
    byte_fdump(stdout, lmsg , mat+len_byte*i , len_byte );
    fprintf(stdout,"\n");
  }

}


static inline
void gf256mat_submat_fill( uint8_t * mat , unsigned veclen_byte , unsigned st , const uint8_t *submat, unsigned s_veclen_byte, unsigned n )
{
  for(unsigned i=0;i<n;i++) {
    for(unsigned j=0;j<s_veclen_byte;j++) mat[i*veclen_byte+st+j] = submat[i*s_veclen_byte+j];
  }
}

static inline
void gf16mat_identity( uint8_t *mat , unsigned w )
{
  unsigned w_2 = w/2;
  gf256v_set_zero( mat , w_2*w );
  for(unsigned i=0;i<w;i++) gf16v_set_ele(mat+i*w_2,i,1);
}


#include "benchmark.h"

#define LEN  32
#define LEN_2  (LEN/2)

#define TEST_RUN 100



int main()
{
	struct benchmark bm_inv;
	struct benchmark bm_ldu;

	bm_init( &bm_inv );
	bm_init( &bm_ldu );


        printf("====== unit test ======\n");
        printf("gf16mat[%dx%d]: testing if LDU inversion and Gauss elimination produce same inverse matrix.\n\n", LEN , LEN );

#if defined(_BLAS_AVX2_)
	char * arch = "avx2";
#elif defined(_BLAS_SSE_)
	char * arch = "ssse3";
#elif defined(_BLAS_UINT64_)
	char * arch = "uint64";
#else
	char * arch = "ref";
#endif
	printf("arch = %s\n", arch );

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

	unsigned pass = 1;
	int j=0;
for(;j<TEST_RUN;j++) {
	prng_gen( prng0 , matA , LEN*LEN );
	//gf256v_set_zero( matA , sizeof(matA) );
	//gf16mat_identity( matA , LEN );
	//for(int k=0;k<LEN;k++) matA[k*LEN+k] = 1;

	//gf16mat_dump( matA , "matA" , LEN );

	int inv1;
BENCHMARK( bm_inv , {
	inv1 = gf16mat_inv( matB , matA , LEN );
} );

	//printf("inv: %d\n", inv );
	//gf256mat_transpose( matB , LEN );
	//gf256v_set_zero( matB , sizeof(matB) );
	//for(int k=0;k<LEN;k++) matB[k*LEN+k] = 1;
	//for(int i=0;i<LEN;i++) {
	//	byte_fdump( stdout , "matB: " , &matB[i*LEN/2] , LEN/2 ); printf("\n");
	//}

	int inv2;
BENCHMARK( bm_ldu , {
	inv2 = gf16mat_LDUinv( submat_B , submat_A , submat_D , submat_C , matA , LEN );
} );
	if( inv1 != inv2 ) {
		printf("inv1 != inv2:  %d!=%d\n", inv1 , inv2 );
		continue;
	}
	if( 0 == inv1 ) {
		printf("singular: %d : %d\n", inv1 , inv2 );
		continue;
	}
//
//  return : [ 1 B ] [ A 0 ] [ 1 0 ]
//           [ 0 1 ] [ 0 D ] [ C 1 ]
// however,
// mat_inv = [ 1  B ] [ A  0 ] [ 1   0 ]
//           [ 0  1 ] [ 0  D ] [ CxA 1 ]
//

	// column-major code
	// CA
	gf16mat_colmat_mul( tmp , submat_C , LEN_2/2 , LEN_2 , submat_A , LEN_2 );  // C x A , column-major matrix
	gf16mat_identity( mat1 , LEN );
	gf256mat_submat_fill( mat1 , LEN_2 , LEN_2/2 , tmp , LEN_2/2 , LEN_2 );
//gf16mat_dump( mat1 , "CA" , LEN );

	// A , D
	gf256v_set_zero( mat2 , LEN_2*LEN );
	gf256mat_submat_fill( mat2 , LEN_2 , 0 , submat_A , LEN_2/2 , LEN_2 );
	gf256mat_submat_fill( mat2+LEN_2*LEN_2 , LEN_2 , LEN_2/2 , submat_D , LEN_2/2 , LEN_2 );
//gf16mat_dump( mat2 , "AD" , LEN );

	// [ A 0 ] x  [ 1   0 ]
	// [ 0 D ]    [ CxA 1 ]
	gf16mat_colmat_mul( mat3 , mat2 , LEN_2 , LEN , mat1 , LEN );
//gf16mat_dump( mat3 , "ADCA" , LEN );

	gf16mat_identity( mat1 , LEN );
	gf256mat_submat_fill( mat1+LEN_2*LEN_2 , LEN_2 , 0 , submat_B , LEN_2/2 , LEN_2 );
//gf16mat_dump( mat1 , "B" , LEN );

	gf16mat_colmat_mul( matC , mat1 , LEN_2 , LEN , mat3 , LEN );
//gf16mat_dump( matC , "INV" , LEN );

	// test equal
	memcpy( mat1 , matB , LEN_2*LEN );
	gf256v_add( mat1 , matC , LEN_2*LEN );
	if( !gf256v_is_zero( mat1 , LEN_2*LEN ) ) {
		printf("[%d] two results differ\n", j );
		gf16mat_dump( submat_B , "smatB" , LEN_2 );
		gf16mat_dump( submat_A , "smatA" , LEN_2 );
		gf16mat_dump( submat_D , "smatD" , LEN_2 );
		gf16mat_dump( submat_C , "smatC" , LEN_2 );

		gf16mat_dump( matC , "invM" , LEN );

		pass = 0;
		break;
	}
}

	printf("[%d/%d] test %s.\n\n", j , TEST_RUN , (pass)?"PASS":"FAIL" );

	char msg[256];
	bm_dump( msg , 256 , & bm_inv );
	printf("bm_inv: %s\n\n", msg );
	bm_dump( msg , 256 , & bm_ldu );
	printf("bm_ldu: %s\n\n", msg );

	return 0;
}

