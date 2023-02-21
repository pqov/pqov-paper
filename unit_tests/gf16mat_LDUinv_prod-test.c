
#include <stdio.h>



#include "blas.h"
#include "blas_comm.h"
#include "blas_matrix.h"

#include "utils_prng.h"

#include "utils.h"

#include "string.h"





#include "benchmark.h"


#define LEN  64
#define LEN_2  (LEN/2)

#define TEST_RUN 1000



int is_vec_eq( const uint8_t *v0 , const uint8_t *v1, int len )
{
	uint8_t r =0;
	for(int i=0;i<len;i++) r |= v0[i]^v1[i];
	return 0==r;
}



int main(int argc, char** argv)
{
	struct benchmark bm_0, bm_0_0, bm_0_1;
	struct benchmark bm_1, bm_1_0, bm_1_1;
	struct benchmark bm_2, bm_2_0, bm_2_1;

	bm_init( &bm_0 );  bm_init( &bm_0_0 );  bm_init( &bm_0_1 );
	bm_init( &bm_1 );  bm_init( &bm_1_0 );  bm_init( &bm_1_1 );
	bm_init( &bm_2 );  bm_init( &bm_2_0 );  bm_init( &bm_2_1 );


        printf("====== unit test ======\n");
        printf("teting equality of reesults of mattrix-vector multiplication from 2 inverse matrices [%dx%d].\n\n", LEN , LEN );

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

	uint8_t vecQ[LEN];
	uint8_t vec0[LEN];
	uint8_t vec1[LEN];
	uint8_t vec2[LEN];

	uint8_t vec_sol[LEN];
	//uint8_t vec_test[LEN];

	int test_pass = 1;

	int j=0;
	for(;j<TEST_RUN;j++) {
		prng_gen( prng0 , matA , LEN*LEN );
		prng_gen( prng0 , vec_sol , LEN_2 );
		gf16mat_prod( vecQ , matA , LEN_2 , LEN , vec_sol );


	int inv0;
BENCHMARK( bm_0 , {
bm_start(&bm_0_0);
		inv0 = gf16mat_inv( matB , matA , LEN );
bm_stop(&bm_0_0);
bm_start(&bm_0_1);
		gf16mat_prod( vec0 , matB , LEN_2 , LEN , vecQ );
bm_stop(&bm_0_1);
} );

	int inv1;
BENCHMARK( bm_1 , {
bm_start(&bm_1_0);
		inv1 = gf16mat_LDUinv( submat_B , submat_A , submat_D , submat_C , matA , LEN );
bm_stop(&bm_1_0);
bm_start(&bm_1_1);
		gf16mat_LDUinv_prod( vec1 , submat_B , submat_A , submat_D , submat_C , vecQ , LEN_2 );
bm_stop(&bm_1_1);
} );

#if 1
//#if defined(_BLAS_AVX2_) && (64==LEN)
    memcpy( matC , matA , sizeof(matA) );
	memcpy( vec2 , vecQ , sizeof(vecQ) );
	int inv2;
BENCHMARK( bm_2 , {
bm_start(&bm_2_0);
		inv2 = gf16mat_gaussian_elim( matC, vec2, LEN );
bm_stop(&bm_2_0);
bm_start(&bm_2_1);
		gf16mat_back_substitute( vec2, matC, LEN );
bm_stop(&bm_2_1);
} );

		if( inv0 != inv2 ) {
			printf("inv0 != inv2: %d!=%d\n", inv0 , inv2 );
			test_pass = 0;
			//break;
		}
#endif

		if( inv1 != inv0 ) {
			printf("inv1 != inv0:  %d!=%d\n", inv1 , inv0 );
			continue;
		}
		if( 0 == inv0 ) {
			printf("singular matrix.\n");
			continue;
		}

		if( !is_vec_eq( vec_sol , vec0 , LEN_2 ) ) {
			printf("wrong solution(inv): diff:\n");
			byte_fdump( stdout , "vec_sol: " , vec_sol , LEN_2 ); printf("\n");
			byte_fdump( stdout , "vec_0  : " , vec0    , LEN_2 ); printf("\n");
			test_pass = 0;
			break;
		}

#if defined(_BLAS_AVX2_) && (64==LEN)
		if( !is_vec_eq( vec_sol , vec2 , LEN_2 ) ) {
			printf("wrong solution(gaussian): diff:\n");
			byte_fdump( stdout , "vec_sol: " , vec_sol , LEN_2 ); printf("\n");
			byte_fdump( stdout , "vec_2  : " , vec2    , LEN_2 ); printf("\n");
			test_pass = 0;
			//break;
		}
#endif

		if( !is_vec_eq( vec0 , vec1 , LEN_2 ) ) {
			printf("wrong solution(gaussian vs LDU): diff:\n");
			byte_fdump( stdout , "vec_0: " , vec0 , LEN_2 ); printf("\n");
			byte_fdump( stdout , "vec_1: " , vec1 , LEN_2 ); printf("\n");
			test_pass = 0;
			break;
		}
	}

	printf("[%d/%d] test %s.\n\n", j , TEST_RUN , (test_pass)?"PASS":"FAIL" );

	char msg[256];
	bm_dump( msg , 256 , & bm_0 );  printf("bm_inv: %s\n\n", msg );
	bm_dump( msg , 256 , & bm_0_0 );  printf("  mat: %s\n\n", msg );
	bm_dump( msg , 256 , & bm_0_1 );  printf("  vec: %s\n\n", msg );
	bm_dump( msg , 256 , & bm_1 );  printf("bm_ldu: %s\n\n", msg );
	bm_dump( msg , 256 , & bm_1_0 );  printf("  mat: %s\n\n", msg );
	bm_dump( msg , 256 , & bm_1_1 );  printf("  vec: %s\n\n", msg );
	bm_dump( msg , 256 , & bm_2 );  printf("bm_sol: %s\n\n", msg );
	bm_dump( msg , 256 , & bm_2_0 );  printf("  mat: %s\n\n", msg );
	bm_dump( msg , 256 , & bm_2_1 );  printf("  vec: %s\n\n", msg );

    (void)argc;
    (void)argv;
	return 0;
}

