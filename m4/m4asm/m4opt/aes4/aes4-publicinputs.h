#ifndef AES4_PUBLICINPUTS_H
#define AES4_PUBLICINPUTS_H

#include <stdint.h>
#include <stdlib.h>

#define AES128_KEYBYTES 16
#define AES192_KEYBYTES 24
#define AES256_KEYBYTES 32
#define AESCTR_NONCEBYTES 12
#define AES_BLOCKBYTES 16


typedef struct {
    uint64_t sk_exp[50];
} aes256_4rounds_ctx_publicinputs;



void aes256_4rounds_ctr_keyexp_publicinputs(aes256_4rounds_ctx_publicinputs *r, const unsigned char *key);
void aes256_4rounds_ctr_publicinputs(unsigned char *out, size_t outlen, const unsigned char *iv, uint32_t ctr, const aes256_4rounds_ctx_publicinputs *ctx);
#endif
