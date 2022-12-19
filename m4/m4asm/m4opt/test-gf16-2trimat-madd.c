#include <stdlib.h>
#include "randombytes.h"
#include "hal.h"
#include "sendfn.h"

#include "gf16_asm.h"
#include "uov_config.h"
#include "uov_keypair.h"
#include "blas_u32.h"
#include "blas.h"
#define printcycles(S, U) send_unsignedll((S), (U))

static inline
unsigned idx_of_trimat( unsigned i_row , unsigned j_col , unsigned dim )
{
    return (dim + dim - i_row + 1 )*i_row/2 + j_col - i_row;
}
static inline
unsigned idx_of_2trimat( unsigned i_row , unsigned j_col , unsigned n_var )
{
   if( i_row > j_col ) return idx_of_trimat(j_col,i_row,n_var);
   else return idx_of_trimat(i_row,j_col,n_var);
}


static
void batch_2trimat_madd_gf16( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch )
{

    int ctr = 0;
    
    unsigned Aheight = Bheight;
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                if(i==k) continue;
                gf16v_madd( bC , & btriA[ size_batch*(idx_of_2trimat(i,k,Aheight)) ] , gf16v_get_ele( &B[j*size_Bcolvec] , k ) , size_batch );
                ctr++;
            }
            bC += size_batch;
        }
    }
}



static int test(){
    int err = 0;
    unsigned char c[_O1_BYTE * _V1*_O1];
    unsigned char c2[_O1_BYTE * _V1*_O1];
    unsigned char a[_O1_BYTE * N_TRIANGLE_TERMS(_V1)];
    unsigned char b[_V1_BYTE*_O1];
    unsigned char str[100];

    for(int i=0;i<2;i++){

        memset(c2, 0, sizeof c2);
        memset(c, 0, sizeof c);
        randombytes(a, sizeof a);
        randombytes(b, sizeof b);

        batch_2trimat_madd_gf16_96_48_64_32_m4f(c, a, b);
        batch_2trimat_madd_gf16(c2, a, b, 96, 48, 64, 32);

        if(memcmp(c, c2, sizeof c)){
            hal_send_str("ERROR");
            err++;
        } else {
            hal_send_str("OK");
        }
    }
    return err;
}
static void bench(){
    unsigned char c[_O1_BYTE * _V1*_O1];
    unsigned char c2[_O1_BYTE * _V1*_O1];
    unsigned char a[_O1_BYTE * N_TRIANGLE_TERMS(_V1)];
    unsigned char b[_V1_BYTE*_O1];
    unsigned char str[100];
    uint64_t t0, t1;

    t0 = hal_get_time();
    batch_2trimat_madd_gf16(c2, a, b, 96, 48, 64, 32);
    t1 = hal_get_time();
    printcycles("batch_2trimat_madd_gf16(96,48,64,32) cycles:", t1-t0);

    t0 = hal_get_time();
    batch_2trimat_madd_gf16_96_48_64_32_m4f(c, a, b);
    t1 = hal_get_time();
    printcycles("batch_2trimat_madd_gf16_96_48_64_32_m4f cycles:", t1-t0);

}

int main(void){
    hal_setup(CLOCK_BENCHMARK);
    hal_send_str("==========================\n");
    bench();
    unsigned int errcnt = test();
    send_unsigned("errcnt=", errcnt);
    hal_send_str("#\n");
    while(1);
    return 0;
}