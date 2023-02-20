
#include <stdio.h>



#include "blas.h"
#include "blas_comm.h"
#include "blas_matrix.h"
#include "blas_matrix_ref.h"

#include "utils_prng.h"

#include "utils.h"

#include "string.h"






#include "benchmark.h"
struct benchmark bmm;


#if 0
#define VEC_LEN  16
#define N_VEC    32
#else
#define VEC_LEN  8
#define N_VEC    16
#endif

#define TEST_RUN 100

int main(int argc, char** argv)
{
	bm_init( &bmm );


        printf("====== unit test ======\n");
        printf("gf16 matrix[%dx%d(byte)]-vector product test\n\n", N_VEC , VEC_LEN );


	printf("\n\n============= setup PRNG ==============\n");

	prng_t _prng;
	prng_t * prng0 = &_prng;
	uint8_t prng_seed[32] = {0};
	prng_set( prng0 , prng_seed );

	printf("\n\n============= random matrix generation ==============\n");

	uint8_t matA[ VEC_LEN*N_VEC ];
	uint8_t vec_b[ N_VEC ];
	uint8_t vec_c0[ VEC_LEN ];
	uint8_t vec_c1[ VEC_LEN ];


	int fail = 0;
for(int j=0;j<TEST_RUN;j++) {
	prng_gen( prng0 , matA , sizeof(matA) );
	//memset(  matA , 0 , sizeof(matA) );
	//for(int k=0;k<N_VEC;k++) gf16v_set_ele( matA+VEC_LEN*k , k , 1);

	prng_gen( prng0 , vec_b , sizeof(vec_b) );


	gf16mat_prod_ref( vec_c0 , matA , VEC_LEN , N_VEC  , vec_b );
BENCHMARK( bmm, {
	gf16mat_prod( vec_c1 , matA , VEC_LEN , N_VEC  , vec_b );
} );

	gf256v_add( vec_c0 , vec_c1 , VEC_LEN );

	if( !gf256v_is_zero( vec_c0 , VEC_LEN ) ) {
		gf256v_add( vec_c0 , vec_c1 , VEC_LEN );

		printf("in-correct:\n");

		byte_fdump( stdout , "vec_b : " , vec_b , N_VEC ); printf("\n");

		byte_fdump( stdout , "vec_c0: " , vec_c0 , VEC_LEN ); printf("\n");
		byte_fdump( stdout , "vec_c1: " , vec_c1 , VEC_LEN ); printf("\n");

		fail = 1;
		break;
	}
}
	printf((fail)? "TEST FAIL.!\n" : "test PASS.\n" );

	char msg[256];
	bm_dump(msg,256,&bmm);
	puts(msg);

    (void)argc;
    (void)argv;
	return 0;
}

