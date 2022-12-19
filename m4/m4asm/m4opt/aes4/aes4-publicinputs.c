/*
 * AES implementation based on code from BearSSL (https://bearssl.org/)
 * by Thomas Pornin.
 *
 *
 * Copyright (c) 2016 Thomas Pornin <pornin@bolet.org>
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <stdint.h>
#include <string.h>

#include "aes4-publicinputs.h"

#ifdef PROFILE_HASHING
#include "hal.h"
extern unsigned long long hash_cycles;
#endif

extern void aes256_4rounds_keyexp_publicinputs_asm(const uint8_t *key, uint8_t *rk);
extern void aes256_4rounds_encrypt_publicinputs_asm(const uint8_t *rk, const uint8_t *in, uint8_t *out);


static inline uint32_t br_swap32(uint32_t x) {
    x = ((x & (uint32_t)0x00FF00FF) << 8)
        | ((x >> 8) & (uint32_t)0x00FF00FF);
    return (x << 16) | (x >> 16);
}


static inline void inc1_be(uint32_t *x) {
    uint32_t t = br_swap32(*x) + 1;
    *x = br_swap32(t);
}



static void aes_ctr(unsigned char *out, size_t outlen, const unsigned char *iv, uint32_t ctr, const uint64_t *rkeys, void (*aes_encrypt_asm)(const uint8_t *, const uint8_t *, uint8_t *)) {
    uint32_t ivw[4] = {0};
    uint8_t buf[AES_BLOCKBYTES];
    size_t i;

    memcpy(ivw, iv, AESCTR_NONCEBYTES);

    ivw[3] = br_swap32(ctr);

    while (outlen > AES_BLOCKBYTES) {
        aes_encrypt_asm((uint8_t *)rkeys, (uint8_t *)ivw, out);
        inc1_be(ivw + 3);
        out += AES_BLOCKBYTES;
        outlen -= AES_BLOCKBYTES;
    }
    if (outlen > 0) {
        aes_encrypt_asm((unsigned char *)rkeys, (unsigned char *)ivw, buf);
        for (i = 0; i < outlen; i++) {
            out[i] = buf[i];
        }
    }
}



static void aes256_keyexp_publicinputs(aes256_4rounds_ctx_publicinputs *r, const unsigned char *key) {
#ifdef PROFILE_HASHING
    uint64_t t0 = hal_get_time();
#endif

    memcpy((uint8_t *)r->sk_exp, key, AES256_KEYBYTES);
    aes256_4rounds_keyexp_publicinputs_asm(key, ((uint8_t *)r->sk_exp) + AES256_KEYBYTES);

#ifdef PROFILE_HASHING
    uint64_t t1 = hal_get_time();
    hash_cycles += (t1-t0);
#endif
}

void aes256_4rounds_ctr_keyexp_publicinputs(aes256_4rounds_ctx_publicinputs *r, const unsigned char *key) {
    aes256_keyexp_publicinputs(r, key);
}


void aes256_4rounds_ctr_publicinputs(unsigned char *out, size_t outlen, const unsigned char *iv, uint32_t ctr, const aes256_4rounds_ctx_publicinputs *ctx) {
#ifdef PROFILE_HASHING
    uint64_t t0 = hal_get_time();
#endif

    aes_ctr(out, outlen, iv, ctr, ctx->sk_exp, aes256_4rounds_encrypt_publicinputs_asm);

#ifdef PROFILE_HASHING
    uint64_t t1 = hal_get_time();
    hash_cycles += (t1-t0);
#endif
}