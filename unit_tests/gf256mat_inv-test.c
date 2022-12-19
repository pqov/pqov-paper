
#include <stdio.h>



#include "blas.h"
#include "blas_comm.h"
#include "blas_matrix.h"

#include "utils_prng.h"

#include "utils.h"

#include "string.h"




#include "benchmark.h"

#define MAX_LEN  96

#define TEST_RUN 100


uint8_t mat_I[MAX_LEN*MAX_LEN];
void set_mat_I( unsigned len )
{
	gf256v_set_zero( mat_I , len*len );
	for(unsigned i=0;i<len;i++) mat_I[i*len+i] = 1;
}


int test( uint8_t * matC, uint8_t * matB , uint8_t * matA , unsigned len , prng_t * prng0 )
{

	struct benchmark bm0;
	bm_init( &bm0 );

	printf("====== unit test ======\n");
	printf("mat[%dx%d] * mat_inv -> I\n\n", len , len );


	set_mat_I( len );

    int succ = 1;

for(int j=0;j<TEST_RUN;j++) {
	prng_gen( prng0 , matA , len*len );
	//gf256v_set_zero( matA , sizeof(matA) );
	//for(int k=0;k<LEN;k++) matA[k*LEN+k] = 1;

	//for(int i=0;i<LEN;i++) {
	//	byte_fdump( stdout , "matA: " , &matA[i*LEN/2] , LEN/2 ); printf("\n");
	//}

	int inv;
BENCHMARK( bm0 , { 
	inv = gf256mat_inv( matB , matA , len );
} );

	//printf("inv: %d\n", inv );
	if( 0 == inv ) continue;


	//gf256v_set_zero( matB , sizeof(matB) );
	//for(int k=0;k<LEN;k++) matB[k*LEN+k] = 1;

	//for(int i=0;i<LEN;i++) {
	//	byte_fdump( stdout , "matB: " , &matB[i*LEN/2] , LEN/2 ); printf("\n");
	//}
	

	gf256mat_colmat_mul( matC , matA , len , len , matB , len );

	gf256v_add( matC , mat_I , len*len );
	if( !gf256v_is_zero( matC , len*len ) ) {
		for(unsigned i=0;i<len;i++) {
			byte_fdump( stdout , "matC: " , &matC[i*len] , len ); printf("\n");
		}
		succ = 0;
		break;
	}
}
	//printf("if no error message -> test pass.\n\n");
	char msg[256];
	bm_dump( msg , 256 , &bm0 );
	printf("bm0: %s\n\n", msg );

	return succ;
}





int main()
{
//	struct benchmark bm0, bm1;
//	bm_init( &bm0 );
//	bm_init( &bm1 );



	printf("====== unit test ======\n");
	printf("Testing mat[?x?] * mat_inv -> I\n\n" );

	printf("\n\n============= setup PRNG ==============\n");

	prng_t _prng;
	prng_t * prng0 = &_prng;
	uint8_t prng_seed[32] = {0};
	prng_set( prng0 , prng_seed );

	printf("\n\n============= random matrix generation ==============\n");

	uint8_t matA[ MAX_LEN*MAX_LEN ];
	uint8_t matB[ MAX_LEN*MAX_LEN ];
	uint8_t matC[ MAX_LEN*MAX_LEN ];

    unsigned lens[] = { 22, 32, 36, 44, 48, 64, 72, 96 };
    for(unsigned i=0;i<sizeof(lens)/sizeof(unsigned);i++) if( !test( matC , matB , matA , lens[i] , prng0 ) ) break;



	return 0;
}

