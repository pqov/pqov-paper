
#include <stdio.h>



#include "blas.h"
#include "blas_comm.h"
#include "blas_matrix.h"

#include "utils_prng.h"

#include "utils.h"

#include "string.h"






#include "benchmark.h"
struct benchmark bmm;


//#define LEN  32
#define LEN  16
#define TEST_RUN 100

int main(int argc, char** argv)
{
	bm_init( &bmm );


        printf("====== unit test ======\n");
        printf("mat[%dx%d] * mat_inv -> I\n\n", LEN , LEN );


	printf("\n\n============= setup PRNG ==============\n");

	prng_t _prng;
	prng_t * prng0 = &_prng;
	uint8_t prng_seed[32] = {0};
	prng_set( prng0 , prng_seed );

	printf("\n\n============= random matrix generation ==============\n");

	uint8_t matA[ LEN*LEN ];
	uint8_t matB[ LEN*LEN ];
	uint8_t matC[ LEN*LEN ];
	uint8_t mat_corr[LEN*LEN];
	gf256v_set_zero( mat_corr , sizeof(mat_corr) );
	for(int i=0;i<LEN;i++) gf16v_set_ele( mat_corr + (LEN/2)*i , i , 1 );

for(int j=0;j<TEST_RUN;j++) {
	prng_gen( prng0 , matA , LEN*LEN );

	//for(int i=0;i<LEN;i++) {
	//	byte_fdump( stdout , "matA: " , &matA[i*LEN/2] , LEN/2 ); printf("\n");
	//}

	int inv=1;
BENCHMARK( bmm , {
	inv = gf16mat_inv( matB , matA , LEN );
} );
	if( 0==inv ) continue;

	//printf("inv: %d\n", inv );

	//for(int i=0;i<LEN;i++) {
	//	byte_fdump( stdout , "matB: " , &matB[i*LEN/2] , LEN/2 ); printf("\n");
	//}
	

	//gf16mat_mul( matC , matA , LEN , LEN/2 , matB , LEN/2 );
	gf16mat_colmat_mul( matC , matA , LEN/2 , LEN , matB , LEN );

	gf256v_add( matC , mat_corr , (LEN/2)*LEN );

	if( !gf256v_is_zero( matC , (LEN/2)*LEN ) ) {
		for(int i=0;i<LEN;i++) {
			byte_fdump( stdout , "matC: " , &matC[i*LEN/2] , LEN/2 ); printf("\n");
		}
		break;
	}
}
	printf("if no error message: -> test pass.\n");

	char msg[256];
	bm_dump( msg , 256 , &bmm );
	printf("bm: %s\n\n", msg );

    (void)argc;
    (void)argv;
	return 0;
}

