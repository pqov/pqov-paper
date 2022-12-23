
#include <stdio.h>

#include "gf16.h"

//#include "blas.h"
//#include "blas_comm.h"
//#include "blas_matrix.h"

#include "utils_prng.h"

#include "utils.h"

#include "string.h"






#include "benchmark.h"


int main()
{
	struct benchmark bm1;
	struct benchmark bm2;
	bm_init( &bm1 );
	bm_init( &bm2 );


        printf("====== unit test ======\n");
        printf("Testing  gf_ele * gf_ele^-1 -> 1\n\n" );


	printf("\n\n============= GF(16) ==============\n");

	uint8_t a, b, c;
	uint32_t a_vec, c_vec;

	a = 0;
	b = gf16_inv(a);
	c = gf16_mul(a,b);

	a_vec = a;
	c_vec = gf16v_mul_u32( a_vec , b );

	if( 0 != c || 0 != c_vec ) {
		printf("a:%x ==^-1==> b:%x, axb->%x\n", a , b , c );
		printf("a_vec:%x ==^-1==> b:%x, a_vecxb->%x\n", a_vec , b , c_vec );
		printf("test fail.\n");
		return -1;
	}

BENCHMARK( bm1, {
	for(unsigned i=1;i<16;i++) {
		a = i;
		b = gf16_inv(a);
		c = gf16_mul(a,b);

		a_vec = a;
		c_vec = gf16v_mul_u32( a_vec , b );

		if( 1 != c || 1 != c_vec ) {
			printf("a:%x ==^-1==> b:%x, axb->%x\n", a , b , c );
			printf("a_vec:%x ==^-1==> b:%x, a_vecxb->%x\n", a_vec , b , c_vec );
			printf("test fail.\n");
			return -1;
		}
	}
} );

	printf("\n\n============= GF(256) ==============\n");

	a = 0;
	b = gf256_inv(a);
	c = gf256_mul(a,b);

	a_vec = a;
	c_vec = gf256v_mul_u32( a_vec , b );

	if( 0 != c || 0 != c_vec ) {
		printf("a:%x ==^-1==> b:%x, axb->%x\n", a , b , c );
		printf("a_vec:%x ==^-1==> b:%x, a_vecxb->%x\n", a_vec , b , c_vec );
		printf("test fail.\n");
		return -1;
	}

	for(unsigned i=1;i<256;i++) {
		a = i;
		b = gf256_mul(a,a);
		c = gf256_squ(a);

		a_vec = a;
		uint32_t b_vec = gf256v_mul_u32(a_vec,a);
		c_vec = gf256v_squ_u32(a_vec);

		if( b != c || b_vec != c_vec ) {
			printf("a:%x , axa-> %x , a^2-> %x\n", a , b , c );
			printf("a:%x , axa-> %x , a^2-> %x\n", a , b_vec , c_vec );
			return -1;
		}
	}

BENCHMARK( bm2, {
	for(unsigned i=1;i<256;i++) {
		a = i;

		b = gf256_inv(a);
		c = gf256_mul(a,b);

		a_vec = a;
		c_vec = gf256v_mul_u32( a_vec , b );

		if( 1 != c || 1 != c_vec ) {
			printf("a:%x ==^-1==> b:%x, axb->%x\n", a , b , c );
			printf("a_vec:%x ==^-1==> b:%x, a_vecxb->%x\n", a_vec , b , c_vec );
			printf("test fail.\n");
			return -1;
		}
	}
} );


	printf("if no error message: -> test pass.\n");

	char msg[256];
	bm_dump( msg , 256 , &bm1 );
	printf("bm1 (gf16_inv()+...): %s\n\n", msg );
	bm_dump( msg , 256 , &bm2 );
	printf("bm2 (gf256_inv()+...): %s\n\n", msg );

	return 0;
}

