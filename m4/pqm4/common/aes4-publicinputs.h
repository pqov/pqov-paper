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
    //TODO: smaller
    uint64_t sk_exp[11*16];
} aes128_4rounds_ctx_publicinputs;


void aes128_4rounds_ctr_keyexp_publicinputs(aes128_4rounds_ctx_publicinputs *r, const unsigned char *key);
void aes128_4rounds_ctr_publicinputs(unsigned char *out, size_t outlen, const unsigned char *iv, uint32_t ctr, const aes128_4rounds_ctx_publicinputs *ctx);
#endif
