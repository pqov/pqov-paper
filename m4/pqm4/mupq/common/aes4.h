#ifndef AES4_H
#define AES4_H

#include <stdint.h>
#include <stdlib.h>

#define AES128_KEYBYTES 16
#define AES192_KEYBYTES 24
#define AES256_KEYBYTES 32
#define AESCTR_NONCEBYTES 12
#define AES_BLOCKBYTES 16

// We've put these states on the heap to make sure ctx_release is used.
#define PQC_AES128_STATESIZE 88
typedef struct {
    uint64_t* sk_exp;
} aes128_4rounds_ctx;



void aes128_4rounds_ctr_keyexp(aes128_4rounds_ctx *r, const unsigned char *key);
void aes128_4rounds_ctr(unsigned char *out, size_t outlen, const unsigned char *iv, uint32_t ctr, const aes128_4rounds_ctx *ctx);

/** Frees the context **/
void aes128_4rounds_ctx_release(aes128_4rounds_ctx *r);


#endif
