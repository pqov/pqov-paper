
#include <stdio.h>



#include "blas.h"
#include "blas_comm.h"
#include "blas_matrix.h"

#include "utils_prng.h"

#include "utils.h"

#include "string.h"



static inline
void gf256mat_transpose( uint8_t * mat , unsigned len )
{
  for(int i=0;i<len;i++) {
    for(int j=i+1;j<len;j++) {
      uint8_t tmp = mat[i*len+j];
      mat[i*len+j] = mat[j*len+i];
      mat[j*len+i] = tmp;
    }
  }
}


//#include "benchmark.h"
//struct benchmark bmm;

#define LEN  32
#define LEN_2  (LEN/2)

#define TEST_RUN 10
#define TEST_INV 10

//#define _ROW_MAJOR_MATRIX_


int main()
{
//	bm_init( &bmm );


        printf("====== unit test ======\n");
        printf("teting equality of reesults of mattrix-vector multiplication from 2 inverse matrices.\n\n", LEN , LEN );


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

	uint8_t vecA[LEN];
	uint8_t vecB[LEN];
	uint8_t vecC[LEN];
	uint8_t vecD[LEN];

	int test_pass = 1;

for(int j=0;j<TEST_INV;j++) {
	prng_gen( prng0 , matA , LEN*LEN );
	//gf256v_set_zero( matA , sizeof(matA) );
	//for(int k=0;k<LEN;k++) matA[k*LEN+k] = 1;

	//for(int i=0;i<LEN;i++) {
	//	byte_fdump( stdout , "matA: " , &matA[i*LEN/2] , LEN/2 ); printf("\n");
	//}

	int inv1 = gf256mat_inv( matB , matA , LEN );
	//printf("inv: %d\n", inv );
#if defined(_ROW_MAJOR_MATRIX_)
	gf256mat_transpose( matB , LEN );
#endif

	//gf256v_set_zero( matB , sizeof(matB) );
	//for(int k=0;k<LEN;k++) matB[k*LEN+k] = 1;
	//for(int i=0;i<LEN;i++) {
	//	byte_fdump( stdout , "matB: " , &matB[i*LEN/2] , LEN/2 ); printf("\n");
	//}

	int inv2 = gf256mat_LDUinv( submat_B , submat_A , submat_D , submat_C , matA , LEN );
	if( inv1 != inv2 ) {
		printf("inv1 != inv2:  %d!=%d\n", inv1 , inv2 );
		continue;
	}
#if defined(_ROW_MAJOR_MATRIX_)
	// for row-major LDU matrix
	gf256mat_transpose( submat_B , LEN_2 );
	gf256mat_transpose( submat_A , LEN_2 );
	gf256mat_transpose( submat_D , LEN_2 );
	gf256mat_transpose( submat_C , LEN_2 );
#endif

	for(int k=0;k<TEST_RUN;k++) {
		prng_gen( prng0 , vecA , LEN );
		
		gf256mat_prod( vecB , matB , LEN , LEN , vecA );

		gf256mat_LDUinv_prod( vecC , submat_B , submat_A , submat_D , submat_C , vecA , LEN );

		memcpy( vecD , vecB , LEN );
		gf256v_add( vecD , vecC , LEN );

		if( !gf256v_is_zero( vecD , LEN ) ){
			test_pass = 0;
			printf("[%d,%d] 2 vector differ:\n", j , k );
			byte_fdump( stdout , "vecB: " , vecB , LEN ); printf("\n");
			byte_fdump( stdout , "vecC: " , vecC , LEN ); printf("\n");
			byte_fdump( stdout , "diff: " , vecD , LEN ); printf("\n");
			break;
		}
	}	
}
	if(test_pass) printf( "test pass [%dx%d].\n\n", TEST_INV , TEST_RUN);
	else printf("test FAIL.\n\n");

	return 0;
}

