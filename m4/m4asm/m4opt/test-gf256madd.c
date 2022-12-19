#include <stdlib.h>
#include "randombytes.h"
#include "hal.h"
#include "sendfn.h"

#include <string.h>
#include <stdio.h>

#define NTESTS 10

static uint32_t gf256v_mul_u32_ref(uint32_t a, uint8_t b) {
    uint32_t a_msb;
    uint32_t a32 = a;
    uint32_t b32 = b;
    uint32_t r32 = a32*(b32&1);

    a_msb = a32&0x80808080;  // MSB, 7th bits
    a32 ^= a_msb;   // clear MSB
    a32 = (a32<<1)^((a_msb>>7)*0x1b);
    r32 ^= (a32)*((b32>>1)&1);

    a_msb = a32&0x80808080;  // MSB, 7th bits
    a32 ^= a_msb;   // clear MSB
    a32 = (a32<<1)^((a_msb>>7)*0x1b);
    r32 ^= (a32)*((b32>>2)&1);

    a_msb = a32&0x80808080;  // MSB, 7th bits
    a32 ^= a_msb;   // clear MSB
    a32 = (a32<<1)^((a_msb>>7)*0x1b);
    r32 ^= (a32)*((b32>>3)&1);

    a_msb = a32&0x80808080;  // MSB, 7th bits
    a32 ^= a_msb;   // clear MSB
    a32 = (a32<<1)^((a_msb>>7)*0x1b);
    r32 ^= (a32)*((b32>>4)&1);

    a_msb = a32&0x80808080;  // MSB, 7th bits
    a32 ^= a_msb;   // clear MSB
    a32 = (a32<<1)^((a_msb>>7)*0x1b);
    r32 ^= (a32)*((b32>>5)&1);

    a_msb = a32&0x80808080;  // MSB, 7th bits
    a32 ^= a_msb;   // clear MSB
    a32 = (a32<<1)^((a_msb>>7)*0x1b);
    r32 ^= (a32)*((b32>>6)&1);

    a_msb = a32&0x80808080;  // MSB, 7th bits
    a32 ^= a_msb;   // clear MSB
    a32 = (a32<<1)^((a_msb>>7)*0x1b);
    r32 ^= (a32)*((b32>>7)&1);

    return r32;
}

static void gf256madd_ref(uint32_t *c, uint32_t *a, uint8_t b){
    for(int i=0;i<4;i++){
        c[i] ^= gf256v_mul_u32_ref(a[i], b);
    }
}


extern void gf256madd_asm(uint32_t *c, uint32_t *a, uint8_t b);


static int test(void){
    uint32_t a[4];
    uint32_t c[4];
    char str[100];
    uint32_t cref[4];
    uint8_t b;
    int err = 0;

    for(int i=0;i<NTESTS;i++){
        randombytes((uint8_t *)a, sizeof a);
        randombytes((uint8_t *)c, sizeof c);
        // memset(a, 1, sizeof a);
        // memset(c, 0, sizeof c);
        memcpy(cref, c, sizeof c);
        randombytes(&b, 1);
        // b = 1;


        gf256madd_asm(c, a, b);
        gf256madd_ref(cref, a, b);


        if(memcmp(c, cref, sizeof c)){
            hal_send_str("ERR");
            sprintf(str, "%08lx, %08lx, %08lx, %08lx\n %08lx, %08lx, %08lx, %08lx", cref[0], cref[1], cref[2], cref[3], c[0], c[1], c[2], c[3]);
            hal_send_str(str);


            err++;
        }
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