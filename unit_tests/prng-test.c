#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "utils_prng.h"

#define NTESTS 1

static int test_prng_gen(void)
{
    int i;
    for(i=0;i<NTESTS;i++)
    {
        unsigned char seed[32];
        randombytes(seed, 32);

        prng_t ctx1;
        prng_t ctx2;
        prng_set(&ctx1, seed);
        prng_set(&ctx2, seed);

        unsigned char output1[1337];
        unsigned char output2[1337];
        prng_gen(&ctx1, output1, sizeof output1);

        prng_gen(&ctx2, output2, 1000);
        prng_gen(&ctx2, output2+1000, 337);

        if(memcmp(output1, output2, sizeof output1)){
            printf("ERROR: test prng_gen\n");
            return -1;
        }
    }
    return 0;
}

#include <openssl/evp.h>

static
int openssl_aes256ctr( unsigned char *out, unsigned outlen, const unsigned char *n, const unsigned char *k )
{
  unsigned char in[outlen];
  unsigned inlen = sizeof(in);
  memset(in, 0, inlen );

  EVP_CIPHER_CTX *ctx;
  int ok;
  int outl = 0;

  ctx = EVP_CIPHER_CTX_new();
  if (!ctx) return -111;

  ok = EVP_EncryptInit_ex(ctx,EVP_aes_256_ctr(),0,k,n);
  if (ok == 1) ok = EVP_CIPHER_CTX_set_padding(ctx, 0);
  if (ok == 1) ok = EVP_EncryptUpdate(ctx, out, &outl, in, inlen);
  if (ok == 1) ok = EVP_EncryptFinal_ex(ctx, out, &outl);

  EVP_CIPHER_CTX_free(ctx);
  if( (unsigned int) outl != outlen ) ok = 0;
  return ok == 1 ? 0 : -111;

}


static int test_prng_gen_openssl(void)
{
    uint8_t nonce[16] = {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,2};  // nonce and counter in big endian
    int i;
    for(i=0;i<NTESTS;i++)
    {
        unsigned char seed[32];
        randombytes(seed, 32);

        prng_t ctx1;
        prng_set(&ctx1, seed);

        unsigned char output1[256];
        unsigned char output2[256];

        prng_skip(&ctx1,32);
        prng_gen(&ctx1, output1, sizeof output2);
        openssl_aes256ctr(output2, sizeof output2, nonce, seed);

        if(memcmp(output1, output2, sizeof output1)){
            printf("ERROR: test test_prng_gen_openssl: %d\n", i);
            return -1;
        }
    }
    return 0;
}



static int test_prng_skip(void)
{
    int i;
    for(i=0;i<NTESTS;i++)
    {
        unsigned char seed[32];
        randombytes(seed, 32);
        prng_t ctx1;
        prng_t ctx2;
        prng_set(&ctx1, seed);
        prng_set(&ctx2, seed);

        unsigned char buffer[2048];
        unsigned char output1[500];
        unsigned char output2[500];

        //prng_gen_offset(&ctx1, output1, 500, 1337);
        prng_gen( &ctx1 , buffer , 500+1337 );
        memcpy(output1, buffer+1337 , 500 );

        prng_skip(&ctx2, 1337);
        prng_gen(&ctx2, output2, 500);
        if(memcmp(output1, output2, sizeof output1)){
            printf("ERROR: test test_prng_skip\n");
            return -1;
        }

        prng_set(&ctx1, seed);
        prng_set(&ctx2, seed);

        //prng_gen_offset(&ctx1, output1, 500, 3);
        prng_gen( &ctx1 , buffer , 500+3 );
        memcpy(output1, buffer+3 , 500 );

        prng_skip(&ctx2, 3);
        prng_gen(&ctx2, output2, 500);
        if(memcmp(output1, output2, sizeof output1)){
            printf("ERROR: test test_prng_skip2\n");
            return -1;
        }

        prng_set(&ctx1, seed);
        prng_set(&ctx2, seed);

        //prng_gen_offset(&ctx1, output1, 123, 64);
        prng_gen( &ctx1 , buffer , 123+64 );
        memcpy(output1, buffer+64 , 123 );

        prng_skip(&ctx2, 64);
        prng_gen(&ctx2, output2, 123);
        if(memcmp(output1, output2, sizeof output1)){
            printf("ERROR: test test_prng_skip3\n");
            return -1;
        }

        prng_set(&ctx1, seed);
        prng_set(&ctx2, seed);

        //prng_gen_offset(&ctx1, output1, 500, 132+500);
        prng_gen( &ctx1 , buffer , 500+132+500 );
        memcpy(output1, buffer+132+500 , 500 );

        prng_gen(&ctx2, output2, 500);
        prng_skip(&ctx2, 132);
        prng_gen(&ctx2, output2, 500);


        if(memcmp(output1, output2, sizeof output1)){
            printf("ERROR: test test_prng_skip4\n");
            return -1;
        }


        prng_set(&ctx1, seed);
        prng_set(&ctx2, seed);

        //prng_gen_offset(&ctx1, output1, 500, 128);
        prng_gen( &ctx1 , buffer , 500+128 );
        memcpy(output1, buffer+128 , 500 );

        prng_gen(&ctx2, output2, 32);
        prng_skip(&ctx2, 96);

        printf("ctr=%d, offset=%d\n", ctx2.ctr, ctx2.used);
        prng_gen(&ctx2, output2, 500);


        if(memcmp(output1, output2, sizeof output1)){
            printf("ERROR: test test_prng_skip5\n");
            return -1;
        }

    }
    return 0;
}



int main(int argc, char** argv)
{
    int rc = 0;
    rc |= test_prng_gen();
    rc |= test_prng_gen_openssl();
    rc |= test_prng_skip();
    if(!rc) printf("ALL GOOD\n");

    (void)argc;
    (void)argv;
    return 0;
}
