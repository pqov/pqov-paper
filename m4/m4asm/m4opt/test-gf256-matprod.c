#include <stdlib.h>
#include "randombytes.h"
#include "hal.h"
#include "sendfn.h"
#include "gf256_asm.h"
#include "blas_comm.h"
#include "blas_u32.h"
#include "blas.h"
#include <string.h>
#include <stdio.h>

#define _V1 68
#define _O1 44
#define _V1_BYTE (_V1)
#define _O1_BYTE (_O1)

#define printcycles(S, U) send_unsignedll((S), (U))


static void gf256mat_prod_ref(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b) {
    gf256v_set_zero(c, n_A_vec_byte);
    for (unsigned i = 0; i < n_A_width; i++) {
        gf256v_madd(c, matA, b[i], n_A_vec_byte);
        matA += n_A_vec_byte;
    }
}



static inline void precompute(uint32_t bs[8], uint8_t b){
    uint32_t tmp1;
    uint32_t btmp = b;
    bs[0] = b;

    for(int i=1;i<8;i++){
        tmp1 = 0x01010101 & (btmp >> 7);
        btmp = btmp ^ (tmp1 << 7);
        tmp1 = tmp1 * 0x1b;
        btmp = tmp1 ^ (btmp << 1);
        bs[i] = btmp;
    }
}

static inline void precompute_x4(uint32_t bs[8], uint32_t b){
    uint32_t tmp1;
    uint32_t btmp = b;
    bs[0] = b;

    for(int i=1;i<8;i++){
        tmp1 = 0x01010101 & (btmp >> 7);
        btmp = btmp ^ (tmp1 << 7);
        tmp1 = tmp1 * 0x1b;
        btmp = tmp1 ^ (btmp << 1);
        bs[i] = btmp;
    }
}


#define unalign_load_u32(v, src) (v) = *((uint32_t *)(src))
#define unaligned_store_u32(dst, v) *((uint32_t *)(dst)) = (v)

static inline void gf256v_madd_1936(uint8_t c[1936], uint8_t mat[1936], uint8_t b){
    uint32_t bs[8];

    uint32_t btmp;
    uint32_t tmp0;
    uint32_t aa0;
    uint32_t acc0;

    precompute(bs, b);

    for(int k=0;k<1936; k+=4){
        unalign_load_u32(acc0, c+k);
        unalign_load_u32(aa0, mat+k);
        for(int i=0;i<8;i++){
            tmp0 = 0x01010101 & (aa0 >> i);
            btmp = bs[i];
            tmp0 = tmp0*btmp;
            acc0 = acc0 ^ tmp0;
        }
        unaligned_store_u32(c+k, acc0);
    }
}

#define ACCLEN 48
static inline void gf256v_madd_u32_x4(uint32_t acc[ACCLEN], uint8_t *aa, uint32_t b){
    uint32_t bs[8];

    uint32_t btmp;
    uint32_t tmp0;
    uint32_t aa0;

    precompute_x4(bs, b);

    for(int j=0;j<4;j++){
        for(int k=0;k<ACCLEN;k++){
            unalign_load_u32(aa0, aa+k*4+j*1936);
            for(int i=0;i<8;i++){
                tmp0 = 0x01010101 & (aa0 >> i);
                btmp = (bs[i] >> (j*8)) & 0xFF;
                tmp0 = tmp0*btmp;
                acc[k] = acc[k] ^ tmp0;
            }
        }
    }
}

static inline void gf256v_madd_u32(uint32_t acc[1], uint8_t *aa, uint8_t b){
    uint32_t bs[8];

    uint32_t btmp;
    uint32_t tmp0;
    uint32_t aa0;
    precompute(bs, b);


    for(int k=0;k<1;k++){
        unalign_load_u32(aa0, aa+k*4);
        for(int i=0;i<8;i++){
            tmp0 = 0x01010101 & (aa0 >> i);
            btmp = bs[i];
            tmp0 = tmp0*btmp;
            acc[k] = acc[k] ^ tmp0;
        }
    }

}




void gf256mat_prod_1936_68_new(uint8_t *c, const uint8_t *matA, const uint8_t *b) {
    const unsigned n_A_vec_byte = 1936;
    const unsigned n_A_width = 68;
    uint32_t bs[8];
    uint32_t acc[ACCLEN];
    uint32_t aa0;
    uint32_t bb;

    unsigned num_iter = (n_A_vec_byte/(4*ACCLEN));

    //gf256v_set_zero(c, n_A_vec_byte);

    for(unsigned i = 0; i < num_iter*ACCLEN*4; i += 4*ACCLEN){
        for(unsigned k=0;k<ACCLEN;k++) acc[k] = 0;
        for (unsigned k = 0; k < n_A_width; k+=4) {
            unalign_load_u32(bb, b+k);
            gf256v_madd_u32_x4(acc, matA+i+k*n_A_vec_byte, bb);
        }
        for(unsigned k=0;k<ACCLEN;k++) {
            unaligned_store_u32(c+i+k*4, acc[k]);
        }
    }
    unsigned num_bytes = n_A_vec_byte % (4*ACCLEN);
    if(num_bytes > 0){
        for(unsigned i = n_A_vec_byte - num_bytes; i < n_A_vec_byte; i += 4){
            acc[0] = 0;
            for (unsigned k = 0; k < n_A_width; k++) {
                gf256v_madd_u32(acc, matA+i+k*n_A_vec_byte, b[k]);
            }
            unaligned_store_u32(c+i, acc[0]);
        }

    }


    // for (unsigned i = 0; i < n_A_width; i++) {
    //     //gf256v_madd(c, matA, b[i], n_A_vec_byte);
    //     gf256v_madd_1936(c, matA, b[i]);
    //     matA += n_A_vec_byte;
    //     //return;
    // }
}




static int test(void){
    int err = 0;
    unsigned n_A_vec_byte = 1936;
    unsigned n_A_width = 68;
    uint64_t t0, t1;
    uint8_t cold[n_A_vec_byte];
    uint8_t cnew[n_A_vec_byte];
    uint8_t cref[n_A_vec_byte];
    uint8_t matA[n_A_width*n_A_vec_byte];
    uint8_t b[n_A_width];

    randombytes(matA, sizeof matA);
    randombytes(b, sizeof b);
    // should be overwritten
    randombytes(cold, sizeof cold);
    randombytes(cnew, sizeof cnew);
    randombytes(cref, sizeof cref);


    t0 = hal_get_time();
    gf256mat_prod_ref(cref, matA, n_A_vec_byte, n_A_width, b);
    t1 = hal_get_time();
    printcycles("gf256mat_prod_ref:", t1-t0);

    t0 = hal_get_time();
    gf256mat_prod_m4f_1936_68_normal_normal(cold, matA, b);
    t1 = hal_get_time();
    printcycles("gf256mat_prod_m4f_1936_68_normal_normal:", t1-t0);

    t0 = hal_get_time();
    gf256mat_prod_1936_68_new(cnew, matA, b);
    t1 = hal_get_time();
    printcycles("gf256mat_prod_new:", t1-t0);


    if(memcmp(cref, cold, sizeof cref)){
        hal_send_str("ERROR: gf256mat_prod_m4f_1936_68_normal_normal");
        err++;
    }

    if(memcmp(cref, cnew, sizeof cref)){
        hal_send_str("ERROR: gf256mat_prod_new");
        err++;
    }


    return err;
}




int main(void){
    char str[100];
    hal_setup(CLOCK_BENCHMARK);
    hal_send_str("==========================\n");
    int err = test();

    sprintf(str, "err=%d", err);
    hal_send_str(str);

    hal_send_str("#\n");
    while(1);
    return 0;
}