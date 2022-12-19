/// @file utils_prng.c
/// @brief The implementation of PRNG related functions.
///

#include "utils_prng.h"

#include <stdlib.h>
#include <string.h>


#include "config.h"
#include "params.h"

// TODO: With the current configuration, we have to run the key expansion only once
// We should improve that

#if defined(_UTILS_OPENSSL_) && !defined(_NIST_KAT_)
#include <openssl/rand.h>

void randombytes(unsigned char *x, unsigned long long xlen)
{
  RAND_bytes(x,xlen);
}

#elif defined( _DEBUG_RANDOMBYTES_ )

void randombytes(unsigned char *x, unsigned long long xlen)
{
  while(xlen--) { *x++=rand()&0xff; }
}

#endif


////////////////////////////////// crypto_stream_aes256ctr //////////////////////////////


//
//#if defined(_UTILS_SUPERCOP_)
//
//#include "crypto_stream_aes256ctr.h"
//
// crypto_stream_aes256ctr(unsigned char *x,unsigned xlen, const unsigned char *nonce, const unsigned char *key)
//#define aes256ctr  crypto_stream_aes256ctr
//#error "needs to be implemented"
//


//
// Defining prng_set(), prng_set_publicinputs(), aes256ctr(), and aes256ctr_publicinputs()
//
//
#if defined(_UTILS_PQM4_)

int prng_set_publicinputs(prng_publicinputs_t *ctx, const unsigned char prng_seed[16])
{
    #ifdef _4ROUND_AES_
    aes128_4rounds_ctr_keyexp_publicinputs(&ctx->ctx, prng_seed);
    #else
    aes128_ctr_keyexp_publicinputs(&ctx->ctx, prng_seed);
    #endif
    ctx->used = RNG_OUTPUTLEN;
    ctx->ctr = 0;
    return 0;
}



static
int aes128ctr_publicinputs( unsigned char *out, unsigned nblocks, const unsigned char *n, uint32_t ctr, const prng_publicinputs_t *ctx )
{
#ifdef _4ROUND_AES_
  aes128_4rounds_ctr_publicinputs(out, nblocks*RNG_OUTPUTLEN, n, ctr, &ctx->ctx);
#else
  aes128_ctr_publicinputs(out, nblocks*RNG_OUTPUTLEN, n, ctr, &ctx->ctx);
#endif
  return 0;
}


#elif defined(_UTILS_AESNI_)

#include "x86aesni/x86aesni.h"

int prng_set_publicinputs(prng_publicinputs_t *ctx, const unsigned char prng_seed[16])
{
    //memcpy(ctx->key, prng_seed, 32);
    ctx->used = RNG_OUTPUTLEN;
    ctx->ctr = 0;

    ctx->key_offset = (((uint64_t)(ctx->key))&0xf)? 16-(((uint64_t)(ctx->key))&0xf) : 0;
#ifdef _4ROUND_AES_
    AES128_4R_Key_Expansion ( ctx->key+ctx->key_offset , prng_seed );
#else
    AES128_Key_Expansion ( ctx->key+ctx->key_offset , prng_seed );
#endif
    return 0;
}


static
int aes128ctr_publicinputs( unsigned char *out, unsigned nblocks, const unsigned char *n, uint32_t ctr, const prng_publicinputs_t *ctx)
{
#ifdef _4ROUND_AES_
    AES128_4R_CTR_Encrypt ( out, (RNG_OUTPUTLEN/16)*nblocks , ctx->key+ctx->key_offset, n, ctr );
#else
    AES128_CTR_Encrypt ( out, (RNG_OUTPUTLEN/16)*nblocks , ctx->key+ctx->key_offset, n, ctr );
#endif
    return 0;
}


#elif defined(_UTILS_NEONAES_) && defined(_MAC_OS_)

#include "aes_neonaes.h"

int prng_set_publicinputs(prng_publicinputs_t *ctx, const unsigned char prng_seed[16])
{
    ctx->used = RNG_OUTPUTLEN;
    ctx->ctr = 0;
#ifdef _4ROUND_AES_
    aes128_4r_keyexp_neonaes( ctx->key , prng_seed );
#else
    aes128_keyexp_neonaes( ctx->key , prng_seed );
#endif
    return 0;
}


static
int aes128ctr_publicinputs( unsigned char *out, unsigned nblocks, const unsigned char *n, uint32_t ctr, const prng_publicinputs_t *ctx)
{
    while(nblocks--) {
#ifdef _4ROUND_AES_
      aes128ctrx4_4r_enc_neonaes( out, n, ctr, ctx->key );
#else
      aes128ctrx4_enc_neonaes( out, n, ctr, ctx->key );
#endif
      ctr += 4;
      out += 64;
    }
    return 0;
}

#elif defined(_UTILS_NEONAES_)

#define aes128ctr_publicinputs   aes256ctr_publicinputs


#include "aes128_4r_ffs.h"
#include "aes256_keyexp_ffs.h"
#include "neon_aes.h"

int prng_set_publicinputs(prng_publicinputs_t *ctx, const unsigned char prng_seed[16])
{
    ctx->used = RNG_OUTPUTLEN;
    ctx->ctr = 0;

#ifdef _4ROUND_AES_
    aes128_4r_keyschedule_ffs_lut( ctx->key, prng_seed);
#else
    aes128_keyschedule_ffs_lut( ctx->key, prng_seed );
#endif
    return 0;
}



static
int aes128ctr_publicinputs( unsigned char *out, unsigned nblocks, const unsigned char *n, uint32_t ctr, const prng_publicinputs_t *ctx)
{
    while(nblocks--) {
#ifdef _4ROUND_AES_
        neon_aes128ctrx8_4r_encrypt_ffs(out , n, ctr , ctx->key );
#else
        neon_aes128ctrx8_encrypt_ffs(out , n, ctr , ctx->key );
#endif
        out += 16*8;
        ctr += 8;
    }
    return 0;
}

#elif defined(_UTILS_OPENSSL_)&&(!defined(_4ROUND_AES_))

int prng_set_publicinputs(prng_publicinputs_t *ctx, const unsigned char prng_seed[16])
{
    memcpy(ctx->key, prng_seed, AES128CTR_KEYLEN );
    ctx->used = RNG_OUTPUTLEN;
    ctx->ctr = 0;
    return 0;
}

#ifdef _4ROUND_AES_

error -- Openssl does not support 4RAES.

#endif


#include <openssl/evp.h>

static inline uint32_t br_swap32(uint32_t x)
{
	x = ((x & (uint32_t)0x00FF00FF) << 8)
		| ((x >> 8) & (uint32_t)0x00FF00FF);
	return (x << 16) | (x >> 16);
}


static
int aes128ctr_publicinputs( unsigned char *out, unsigned nblocks, const unsigned char *n, uint32_t ctr, const prng_publicinputs_t *ctx)
{
  uint32_t ivw[4];
  memcpy( (uint8_t*)ivw , n, AES128CTR_NONCELEN );
  uint32_t cc = ctr + br_swap32(ivw[3]); // be->le and then += ctr
  ivw[3] = br_swap32(cc);

  uint8_t in[RNG_OUTPUTLEN] = {0};
  unsigned inlen = RNG_OUTPUTLEN;

  EVP_CIPHER_CTX *cctx;
  int ok;
  int outl;

  cctx = EVP_CIPHER_CTX_new();
  if (!cctx) return -111;

  ok = EVP_EncryptInit_ex(cctx,EVP_aes_128_ctr(),NULL,ctx->key,(uint8_t *)ivw);
  if (ok == 1) ok = EVP_CIPHER_CTX_set_padding(cctx, 0);
  while( nblocks-- ) {
    if (ok == 1) ok = EVP_EncryptUpdate(cctx, out, &outl, in, inlen);
    else break;
    out += inlen;
  }
  if (ok == 1) ok = EVP_EncryptFinal_ex(cctx, out, &outl);
  EVP_CIPHER_CTX_cleanup(cctx);
  return ok == 1 ? 0 : -111;
}




#else

//
// default
//



#include "aes128_4r_ffs.h"


int prng_set_publicinputs(prng_publicinputs_t *ctx, const unsigned char prng_seed[16])
{
    ctx->used = RNG_OUTPUTLEN;
    ctx->ctr = 0;
#ifdef _4ROUND_AES_
    aes128_4r_keyschedule_ffs_lut(ctx->key, prng_seed);
#else
    aes128_keyschedule_ffs_lut(ctx->key, prng_seed);
#endif
    return 0;
}


static inline uint32_t br_swap32(uint32_t x)
{
	x = ((x & (uint32_t)0x00FF00FF) << 8)
		| ((x >> 8) & (uint32_t)0x00FF00FF);
	return (x << 16) | (x >> 16);
}



static
int aes128ctr_publicinputs( unsigned char *out, unsigned nblocks, const unsigned char *n, uint32_t ctr, const prng_publicinputs_t *pctx )
{
  uint32_t ptext0[4];
  uint32_t ptext1[4];
  uint8_t * p0 = (uint8_t*)ptext0;
  uint8_t * p1 = (uint8_t*)ptext1;
  memcpy( p0 , n , AES128CTR_NONCELEN );
  memcpy( p1 , n , AES128CTR_NONCELEN );

  while(nblocks--) {
    uint32_t c0 = ctr;
    uint32_t c1 = ctr + 1;
    ptext0[3] = br_swap32(c0);
    ptext1[3] = br_swap32(c1);
#ifdef _4ROUND_AES_
    aes128_4r_encrypt_ffs(out, out+16, p0, p1, pctx->key);
#else
    aes128_encrypt_ffs(out, out+16, p0, p1, pctx->key);
#endif
    out += 32;

    uint32_t c2 = ctr + 2;
    uint32_t c3 = ctr + 3;
    ptext0[3] = br_swap32(c2);
    ptext1[3] = br_swap32(c3);
#ifdef _4ROUND_AES_
    aes128_4r_encrypt_ffs(out, out+16, p0, p1, pctx->key);
#else
    aes128_encrypt_ffs(out, out+16, p0, p1, pctx->key);
#endif
    out += 32;
    ctr += 4;
  }
  return 0;
}


#endif






int prng_gen_publicinputs(prng_publicinputs_t *ctx, unsigned char *out, unsigned long outlen){
  unsigned long long xlen = outlen;
  unsigned long long ready;
  uint8_t nonce[AES128CTR_NONCELEN] = {0};

  if(ctx->used < RNG_OUTPUTLEN){
    ready = RNG_OUTPUTLEN - ctx->used;
    if (xlen <= ready) ready = xlen;
    memcpy(out, &ctx->buf[ctx->used], ready);
    ctx->used += ready;
    xlen -= ready;
    out += ready;
  }


  if(xlen >= RNG_OUTPUTLEN){
    uint32_t nblocks = xlen / RNG_OUTPUTLEN;
    aes128ctr_publicinputs(out, nblocks, nonce, ctx->ctr, ctx);
    ctx->ctr += (RNG_OUTPUTLEN/AES256_BLOCKSIZE)*nblocks;
    xlen -= nblocks * RNG_OUTPUTLEN;
    out += nblocks * RNG_OUTPUTLEN;
  }

  if(xlen > 0){
    aes128ctr_publicinputs(ctx->buf, 1, nonce, ctx->ctr, ctx);
    ctx->ctr += (RNG_OUTPUTLEN/AES256_BLOCKSIZE);
    memcpy(out, ctx->buf, xlen);
    ctx->used = xlen;
  }
  return outlen;
}


void prng_skip_publicinputs(prng_publicinputs_t *ctx, unsigned long outlen)
{
  if(ctx->used+outlen <= RNG_OUTPUTLEN ) { ctx->used += outlen; return; }
  outlen -= (RNG_OUTPUTLEN-ctx->used);

  unsigned long n_blocks_skip = outlen/RNG_OUTPUTLEN;
  unsigned long rem = outlen - n_blocks_skip*RNG_OUTPUTLEN;
  uint8_t nonce[AES128CTR_NONCELEN] = {0};
  if(rem) {
    ctx->ctr += n_blocks_skip*(RNG_OUTPUTLEN/AES256_BLOCKSIZE);
    ctx->used = rem;
    aes128ctr_publicinputs(ctx->buf, 1, nonce, ctx->ctr, ctx);
    ctx->ctr += (RNG_OUTPUTLEN/AES256_BLOCKSIZE);
  } else {  // 0 == rem
    ctx->ctr += n_blocks_skip*(RNG_OUTPUTLEN/AES256_BLOCKSIZE);
    ctx->used = RNG_OUTPUTLEN;
  }
}

