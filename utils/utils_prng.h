/// @file utils_prng.h
/// @brief the interface for adapting PRNG functions.
///
///

#ifndef _UTILS_PRNG_H_
#define _UTILS_PRNG_H_


#ifdef  __cplusplus
extern  "C" {
#endif

#include <stdint.h>

#include "config.h"
#include "params.h"



#if defined(_UTILS_SUPERCOP_)||defined(_UTILS_PQM4_)
#include "randombytes.h"
#elif defined(_NIST_KAT_) && defined(_UTILS_OPENSSL_)
#include "rng.h"
#else  // defined(_UTILS_OPENSSL_)
void randombytes(unsigned char *x, unsigned long long xlen);
#endif



/////////////////  defination of prng_t and prng_publicinputs_t  /////////////////////////////////


#define AES256CTR_KEYLEN   32
#define AES256CTR_NONCELEN 16
#define AES256_BLOCKSIZE 16

#define AES128CTR_KEYLEN   16
#define AES128CTR_NONCELEN 16
#define AES128_BLOCKSIZE 16



#ifdef _UTILS_PQM4_
// fixsliced implementation processes two blocks in parallel
#define RNG_OUTPUTLEN 32


#include "aes.h"
#ifdef _4ROUND_AES_
#include "aes4-publicinputs.h"
#else
#include "aes-publicinputs.h"
#endif


typedef struct {
    unsigned used;
    uint32_t ctr;
    unsigned char buf[RNG_OUTPUTLEN];
    #ifdef _4ROUND_AES_
    aes128_4rounds_ctx_publicinputs ctx;
    #else
    aes128ctx_publicinputs ctx;
    #endif
} prng_publicinputs_t;


#elif defined(_UTILS_AESNI_)

// TODO: check that this is actually the best value here;
#define RNG_OUTPUTLEN 64

#include "x86aesni/x86aesni.h"

typedef struct {
    unsigned used;
    uint32_t ctr;
    unsigned char   buf[RNG_OUTPUTLEN];
    unsigned key_offset; // for_16byte_align;
#ifdef _4ROUND_AES_
    unsigned char   key[_AES128_4R_ROUNDKEY_BYTE+16];
#else  // round key of the normal aes256
    unsigned char   key[_AES128_ROUNDKEY_BYTE+16];
#endif
} prng_publicinputs_t;



#elif defined(_UTILS_NEONAES_) && defined(_MAC_OS_)

// TODO: check that this is actually the best value here;
#define RNG_OUTPUTLEN 64

#include "aes_neonaes.h"
typedef struct {
    unsigned used;
    uint32_t ctr;
    unsigned char   buf[RNG_OUTPUTLEN];
#ifdef _4ROUND_AES_
    unsigned char   key[5*16];
#else  // round key of the normal aes256
    unsigned char   key[11*16];
#endif
} prng_publicinputs_t;


#elif defined(_UTILS_NEONAES_)

#define RNG_OUTPUTLEN 128
typedef struct {
    unsigned used;
    uint32_t ctr;
    unsigned char   buf[RNG_OUTPUTLEN];
#ifdef _4ROUND_AES_
    uint32_t key[ 40 ];
#else  // round key of the normal aes128
    uint32_t key[ 88 ];
#endif
} prng_publicinputs_t;


#elif defined(_UTILS_OPENSSL_)&&(!defined(_4ROUND_AES_))


// TODO: check that this is actually the best value here;
#define RNG_OUTPUTLEN 64

//
// This is default struct of prng_t
// It is used by _UTILS_OPENSSL_ and aes256ctr.h
// The roundkey of AES256 is not stored in the struct.
// TODO: move key expansion to prng_set
//

typedef struct {
    unsigned used;
    uint32_t ctr;
    unsigned char   buf[RNG_OUTPUTLEN];
    unsigned char   key[AES128CTR_KEYLEN];
} prng_publicinputs_t;





#else

//
// default
//


// TODO: check that this is actually the best value here;
// for aes256ctr.c it needs to be 64, but for openssl, we may change it
#define RNG_OUTPUTLEN 64


typedef struct {
    unsigned used;
    uint32_t ctr;
    unsigned char   buf[RNG_OUTPUTLEN];

#ifdef _4ROUND_AES_
    uint32_t key[40];
#else  // round key of the normal aes128
    uint32_t key[88];
#endif
} prng_publicinputs_t;



#endif


///////////////// end of defination of  prng_t and prng_publicinputs_t  /////////////////////////////////

int prng_set_publicinputs(prng_publicinputs_t *ctx, const unsigned char prng_seed[16]);

int prng_gen_publicinputs(prng_publicinputs_t *ctx, unsigned char *out, unsigned long outlen);

void prng_skip_publicinputs(prng_publicinputs_t *ctx, unsigned long outlen);




#ifdef  __cplusplus
}
#endif



#endif // _UTILS_PRNG_H_


