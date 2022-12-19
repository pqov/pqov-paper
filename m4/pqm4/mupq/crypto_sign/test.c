#include "api.h"
#include "randombytes.h"
#include "hal.h"

#include <string.h>

#ifdef KEYS_IN_FLASH
#include "hal-flash.h"
#endif

#define NTESTS 15
#define MLEN 32

// https://stackoverflow.com/a/1489985/1711232
#define PASTER(x, y) x##y
#define EVALUATOR(x, y) PASTER(x, y)
#define NAMESPACE(fun) EVALUATOR(MUPQ_NAMESPACE, fun)


// use different names so we can have empty namespaces
#define MUPQ_CRYPTO_PUBLICKEYBYTES NAMESPACE(CRYPTO_PUBLICKEYBYTES)
#define MUPQ_CRYPTO_SECRETKEYBYTES NAMESPACE(CRYPTO_SECRETKEYBYTES)
#define MUPQ_CRYPTO_BYTES          NAMESPACE(CRYPTO_BYTES)
#define MUPQ_CRYPTO_ALGNAME        NAMESPACE(CRYPTO_ALGNAME)

#define MUPQ_crypto_sign_keypair NAMESPACE(crypto_sign_keypair)
#ifdef KEYS_IN_FLASH
#define MUPQ_crypto_sign_keypair_sk NAMESPACE(crypto_sign_keypair_sk)
#define MUPQ_crypto_sign_keypair_pk NAMESPACE(crypto_sign_keypair_pk)
#endif
#define MUPQ_crypto_sign NAMESPACE(crypto_sign)
#define MUPQ_crypto_sign_open NAMESPACE(crypto_sign_open)
#define MUPQ_crypto_sign_signature NAMESPACE(crypto_sign_signature)
#define MUPQ_crypto_sign_verify NAMESPACE(crypto_sign_verify)

#ifdef KEYS_IN_FLASH
static void do_keypair_sk(unsigned char pk_seed[32]){
  unsigned char sktmp[MUPQ_CRYPTO_SECRETKEYBYTES];
  MUPQ_crypto_sign_keypair_sk(sktmp, pk_seed);
  write_sk_to_flash(sktmp);
}

static void do_keypair_pk(const unsigned char *sk, unsigned char pk_seed[32]){
  unsigned char pktmp[MUPQ_CRYPTO_PUBLICKEYBYTES];
  MUPQ_crypto_sign_keypair_pk(pktmp, sk, pk_seed);
  write_pk_to_flash(pktmp);
}
#endif

static int test_sign(void)
{
    #ifdef KEYS_IN_FLASH
    const unsigned char *sk = get_sk_flash();
    const unsigned char *pk = get_pk_flash();
    unsigned char pk_seed[32];
    #else
    unsigned char sk[MUPQ_CRYPTO_SECRETKEYBYTES];
    unsigned char pk[MUPQ_CRYPTO_PUBLICKEYBYTES];
    #endif


    unsigned char sm[MLEN + MUPQ_CRYPTO_BYTES];
    unsigned char m[MLEN];

    size_t mlen;
    size_t smlen;

    int i;
    for (i = 0; i < NTESTS; i++) {
        #ifdef KEYS_IN_FLASH
        do_keypair_sk(pk_seed);
        do_keypair_pk(sk, pk_seed);
        #else
        MUPQ_crypto_sign_keypair(pk, sk);
        #endif
        hal_send_str("crypto_sign_keypair DONE.\n");

        randombytes(m, MLEN);
        MUPQ_crypto_sign(sm, &smlen, m, MLEN, sk);
        hal_send_str("crypto_sign DONE.\n");

        // By relying on m == sm we prevent having to allocate CRYPTO_BYTES twice
        if (MUPQ_crypto_sign_open(sm, &mlen, sm, smlen, pk))
        {
            hal_send_str("ERROR Signature did not verify correctly!\n");
        }
        else
        {
            hal_send_str("OK Signature did verify correctly!\n");
        }
        hal_send_str("crypto_sign_open DONE.\n");
    }

    return 0;
}

static int test_wrong_pk(void)
{
    #ifdef KEYS_IN_FLASH
    const unsigned char *sk = get_sk_flash();
    const unsigned char *pk = get_pk_flash();
    unsigned char pk_seed[32];
    #else
    unsigned char sk[MUPQ_CRYPTO_SECRETKEYBYTES];
    unsigned char pk[MUPQ_CRYPTO_PUBLICKEYBYTES];
    #endif
    unsigned char sm[MLEN + MUPQ_CRYPTO_BYTES];
    unsigned char m[MLEN];

    size_t mlen;
    size_t smlen;

    int i;

    for (i = 0; i < NTESTS; i++) {
        #ifdef KEYS_IN_FLASH
        do_keypair_sk(pk_seed);
        do_keypair_pk(sk, pk_seed);
        #else
        MUPQ_crypto_sign_keypair(pk, sk);
        #endif
        hal_send_str("crypto_sign_keypair DONE.\n");


        randombytes(m, MLEN);
        MUPQ_crypto_sign(sm, &smlen, m, MLEN, sk);
        hal_send_str("crypto_sign DONE.\n");

        #ifdef KEYS_IN_FLASH
        do_keypair_sk(pk_seed);
        do_keypair_pk(sk, pk_seed);
        #else
        MUPQ_crypto_sign_keypair(pk, sk);
        #endif
        hal_send_str("crypto_sign_keypair DONE.\n");

        // By relying on m == sm we prevent having to allocate CRYPTO_BYTES twice
        if (MUPQ_crypto_sign_open(sm, &mlen, sm, smlen, pk))
        {
            hal_send_str("OK Signature did not verify correctly under wrong public key!\n");
        }
        else
        {
            hal_send_str("ERROR Signature did verify correctly under wrong public key!\n");
        }
        hal_send_str("crypto_sign_open DONE.\n");
    }

    return 0;
}

int main(void)
{
    hal_setup(CLOCK_FAST);

    // marker for automated testing
    hal_send_str("==========================");

    char str[100];
    sprintf(str, "pk=%d, sk=%d, sig=%d", CRYPTO_PUBLICKEYBYTES, CRYPTO_SECRETKEYBYTES, CRYPTO_BYTES);
    hal_send_str(str);

    test_sign();
    test_wrong_pk();
    hal_send_str("#");
    return 0;
}
