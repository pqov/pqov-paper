#include <string.h>

#include "hal.h"
#include "gf16_asm.h"
#include "randombytes.h"
#include "uov_config.h"
#include "uov_keypair.h"
#include "sendfn.h"
#define printcycles(S, U) send_unsignedll((S), (U))


// gf16 := gf2[x]/x^4+x+1
const uint8_t gf16mul_lut[] = {
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8,
    9, 10, 11, 12, 13, 14, 15, 0, 2, 4, 6, 8, 10, 12, 14, 3, 1, 7, 5, 11, 9, 15,
    13, 0, 3, 6, 5, 12, 15, 10, 9, 11, 8, 13, 14, 7, 4, 1, 2, 0, 4, 8, 12, 3, 7,
    11, 15, 6, 2, 14, 10, 5, 1, 13, 9, 0, 5, 10, 15, 7, 2, 13, 8, 14, 11, 4, 1,
    9, 12, 3, 6, 0, 6, 12, 10, 11, 13, 7, 1, 5, 3, 9, 15, 14, 8, 2, 4, 0, 7, 14,
    9, 15, 8, 1, 6, 13, 10, 3, 4, 2, 5, 12, 11, 0, 8, 3, 11, 6, 14, 5, 13, 12,
    4, 15, 7, 10, 2, 9, 1, 0, 9, 1, 8, 2, 11, 3, 10, 4, 13, 5, 12, 6, 15, 7, 14,
    0, 10, 7, 13, 14, 4, 9, 3, 15, 5, 8, 2, 1, 11, 6, 12, 0, 11, 5, 14, 10, 1,
    15, 4, 7, 12, 2, 9, 13, 6, 8, 3, 0, 12, 11, 7, 5, 9, 14, 2, 10, 6, 1, 13,
    15, 3, 4, 8, 0, 13, 9, 4, 1, 12, 8, 5, 2, 15, 11, 6, 3, 14, 10, 7, 0, 14,
    15, 1, 13, 3, 2, 12, 9, 7, 6, 8, 4, 10, 11, 5, 0, 15, 13, 2, 9, 6, 4, 11,
    1, 14, 12, 3, 8, 7, 5, 10};


static inline void _gf256v_add_u32(uint8_t *accu_b, const uint8_t *a, unsigned _num_byte) {
    unsigned n_u32 = _num_byte >> 2;
    uint32_t *b_u32 = (uint32_t *) accu_b;
    const uint32_t *a_u32 = (const uint32_t *) a;
    for (unsigned i = 0; i < n_u32; i++) b_u32[i] ^= a_u32[i];

    a += (n_u32 << 2);
    accu_b += (n_u32 << 2);
    unsigned rem = _num_byte & 3;
    for (unsigned i = 0; i < rem; i++) accu_b[i] ^= a[i];
}

static void gf256v_set_zero(uint8_t *b, unsigned _num_byte) {
    _gf256v_add_u32(b, b, _num_byte);
}

static inline uint8_t gf16v_get_ele(const uint8_t *a, unsigned i) {
    uint8_t r = a[i >> 1];
    uint8_t r0 = r&0xf;
    uint8_t r1 = r>>4;
    uint8_t m = (uint8_t)(-(i&1));
    return (r1&m)|((~m)&r0);
}



// gf16 := gf2[x]/(x^4+x+1)

static inline uint32_t gf16v_mul_u32(uint32_t a, uint8_t b) {
    uint32_t a_msb;
    uint32_t a32 = a;
    uint32_t b32 = b;
    uint32_t r32 = a32*(b32&1);

    a_msb = a32&0x88888888;  // MSB, 3rd bits
    a32 ^= a_msb;   // clear MSB
    a32 = (a32<<1)^((a_msb>>3)*3);
    r32 ^= (a32)*((b32>>1)&1);

    a_msb = a32&0x88888888;  // MSB, 3rd bits
    a32 ^= a_msb;   // clear MSB
    a32 = (a32<<1)^((a_msb>>3)*3);
    r32 ^= (a32)*((b32>>2)&1);

    a_msb = a32&0x88888888;  // MSB, 3rd bits
    a32 ^= a_msb;   // clear MSB
    a32 = (a32<<1)^((a_msb>>3)*3);
    r32 ^= (a32)*((b32>>3)&1);

    return r32;

}

void _gf16v_madd_u32(uint8_t *accu_c, const uint8_t *a, uint8_t gf16_b, unsigned _num_byte) {
    unsigned n_u32 = _num_byte >> 2;
    uint32_t *c_u32 = (uint32_t *) accu_c;
    const uint32_t *a_u32 = (const uint32_t *) a;
    for (unsigned i = 0; i < n_u32; i++) c_u32[i] ^= gf16v_mul_u32(a_u32[i], gf16_b);

    union tmp_32 {
        uint8_t u8[4];
        uint32_t u32;
    } t;
    accu_c += (n_u32 << 2);
    a += (n_u32 << 2);
    unsigned rem = _num_byte & 3;
    for (unsigned i = 0; i < rem; i++) t.u8[i] = a[i];
    t.u32 = gf16v_mul_u32(t.u32, gf16_b);
    for (unsigned i = 0; i < rem; i++) accu_c[i] ^= t.u8[i];
}




void gf16mat_prod(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b) {
    gf256v_set_zero(c, n_A_vec_byte);
    for (unsigned i = 0; i < n_A_width; i++) {
        uint8_t bb = gf16v_get_ele(b, i);
        _gf16v_madd_u32(c, matA, bb, n_A_vec_byte);
        matA += n_A_vec_byte;
    }
}
#define gf16v_madd _gf16v_madd_u32
void batch_quad_trimat_eval_gf16( unsigned char * y, const unsigned char * trimat, const unsigned char * x, unsigned dim , unsigned size_batch )
{
    unsigned char tmp[256];

    unsigned char _x[256];
    for(unsigned i=0;i<dim;i++) _x[i] = gf16v_get_ele( x , i );

    gf256v_set_zero( y , size_batch );
    for(unsigned i=0;i<dim;i++) {
        gf256v_set_zero( tmp , size_batch );
        for(unsigned j=i;j<dim;j++) {
           gf16v_madd( tmp , trimat , _x[j] , size_batch );
           trimat += size_batch;
        }
        gf16v_madd( y , tmp , _x[i] , size_batch );
    }
}

static int test(void){
    unsigned char y1[32]={0}; // size_batch
    uint32_t y2[32/4]={0}; // size_batch
    unsigned char trimat[(_PUB_M_BYTE) * N_TRIANGLE_TERMS(_PUB_N)]; //dim*dim*size_batch
    unsigned char x[160/2]; // dim/2

    int errcnt = 0;

    for(int i =0; i < 10;i++){
        // 160_32
        randombytes(trimat, sizeof trimat);
        randombytes(x, sizeof x);
        memset(y1, 0, sizeof y1);
        memset(y2, 0, sizeof y2);
        batch_quad_trimat_eval_gf16(y1, trimat, x, 160, 32);
        batch_quad_trimat_eval_gf16_160_32_publicinputs(y2, trimat, x, gf16mul_lut);

        if(memcmp(y1, y2, sizeof y1)){
            hal_send_str("ERROR: batch_quad_trimat_eval_gf16_160_64_publicinputs");
            errcnt++;
        } else {
            hal_send_str("OK.");
        }
    }
    return errcnt;
}


static void batch_quad_trimat_cz(unsigned char * y, const unsigned char * trimat, const unsigned char * x, const unsigned char *seed){
    unsigned char extmat[(_PUB_M_BYTE) * N_TRIANGLE_TERMS(_PUB_N)]; //o*o*size_batch

    // expand seed
    prng_t prng0;
    prng_set(&prng0 , seed);
    prng_gen(&prng0 , extmat , _O1_BYTE * N_TRIANGLE_TERMS(_V1) + _O1_BYTE * _V1*_O1);
    memcpy( extmat + _O1_BYTE * N_TRIANGLE_TERMS(_V1) + _O1_BYTE * _V1*_O1, trimat , _O1_BYTE * N_TRIANGLE_TERMS(_O1));


    batch_quad_trimat_eval_gf16(y, extmat, x, 160, 32);
}

void batch_quad_trimat_eval_gf16_first( unsigned char * y, const unsigned char * trimat, const unsigned char * x)
{
    unsigned char tmp[256];

    unsigned size_batch = 32;
    unsigned char _x[256];
    for(unsigned i=0;i<160;i++) _x[i] = gf16v_get_ele( x , i );

    //gf256v_set_zero( y , size_batch );
    for(unsigned i=0;i<96;i++) {
        gf256v_set_zero( tmp , size_batch );
        for(unsigned j=i;j<160;j++) {
           gf16v_madd( tmp , trimat , _x[j] , size_batch );
           trimat += size_batch;
        }
        gf16v_madd( y , tmp , _x[i] , size_batch );
    }
}
void batch_quad_trimat_eval_gf16_last( unsigned char * y, const unsigned char * trimat, const unsigned char * x)
{
    unsigned char tmp[256];

    unsigned size_batch = 32;
    unsigned char _x[256];
    for(unsigned i=0;i<160;i++) _x[i] = gf16v_get_ele( x , i );

    for(unsigned i=96;i<160;i++) {
        gf256v_set_zero( tmp , size_batch );
        for(unsigned j=i;j<160;j++) {
           gf16v_madd( tmp , trimat , _x[j] , size_batch );
           trimat += size_batch;
        }
        gf16v_madd( y , tmp , _x[i] , size_batch );
    }
}


static int test_cz(void){
    int errcnt =0;
    unsigned char y1[32]={0}; // size_batch
    uint32_t y2[32/4]={0}; // size_batch
    unsigned char trimat[_PUB_M_BYTE*N_TRIANGLE_TERMS(_O1)]; //o*o*size_batch
    unsigned char x[160/2]; // dim/2
    unsigned char seed[32];
    for(int i =0; i < 10;i++){
        // 160_32
        randombytes(trimat, sizeof trimat);
        randombytes(x, sizeof x);
        randombytes(seed, sizeof seed);
        memset(y1, 0, sizeof y1);
        memset(y2, 0, sizeof y2);

        batch_quad_trimat_cz(y1, trimat, x, seed);


        prng_t prng0;
        prng_set(&prng0 , seed);
        batch_quad_trimat_eval_gf16_160_32_incremental_publicinputs(y2, trimat, x, gf16mul_lut, &prng0);


        if(memcmp(y1, y2, sizeof y1)){
            hal_send_str("ERROR: batch_quad_trimat_eval_gf16_160_32_incremental_publicinputs");
            errcnt++;
        } else {
            hal_send_str("OK.");
        }
    }
    return errcnt;
}

// gf16 := gf2[x]/(x^4+x+1)
static inline uint8_t gf16_mul(uint8_t a, uint8_t b) {
    uint8_t r8 = (a&1)*b;
    r8 ^= (a&2)*b;
    r8 ^= (a&4)*b;
    r8 ^= (a&8)*b;

    // reduction
    uint8_t r4 = r8 ^ (((r8>>4)&5)*3); // x^4 = x+1  , x^6 = x^3 + x^2
    r4 ^= (((r8>>5)&1)*6);             // x^5 = x^2 + x
    return (r4&0xf);
}
static void check_mul(){
    for(unsigned int i=0;i<255;i++){
        uint8_t a = i&0xF;
        uint8_t b = i>>4;

        if(gf16_mul(a,b) != gf16mul_lut[i]){
            hal_send_str("ERROR mul!");
        }
    }
    hal_send_str("OK mul");


    for(unsigned int i=0;i<16;i++){
        for(unsigned int j=0;j<10000;j++){
            uint32_t a;
            randombytes(a, sizeof(uint32_t));

            uint32_t res = gf16v_mul_u32(a, i);

            for(int k=0;k<8;k++){
                if((res >> (k*4)) & 0xF !=  gf16_mul((a >> (k*4))&0xF, i)){
                    hal_send_str("ERROR vmul!");
                }
            }

        }
    }
    hal_send_str("OK vmul");
}


void bench(){
    uint64_t t0, t1;
    unsigned char y[32*2]={0}; // size_batch
    unsigned char trimat[(32) * N_TRIANGLE_TERMS(96)]; //dim*dim*size_batch
    unsigned char x[96]; // dim/2
    t0 = hal_get_time();
    batch_quad_trimat_eval_gf16_96_32(y, trimat, x);
    t1 = hal_get_time();
    printcycles("batch_quad_trimat_eval_gf16_96_32 cycles:", t1-t0);

}

int main(void){
    hal_setup(CLOCK_BENCHMARK);
    hal_send_str("==========================\n");
    bench();
    unsigned int errcnt = 0;
    errcnt += test_cz();
    errcnt += test();

    check_mul();
    if(errcnt) {
       hal_send_str("ERROR!");
    } else {
       hal_send_str("OK!");
    }
    hal_send_str("#\n");
    while(1);
    return 0;
}