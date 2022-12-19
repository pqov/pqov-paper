#include "api.h"
#include "hal.h"
#include "sendfn.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#ifdef KEYS_IN_FLASH
#include "hal-flash.h"
#endif

#define MLEN 59

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

#define printcycles(S, U) send_unsignedll((S), (U))

#ifdef KEYS_IN_FLASH
static uint64_t do_keypair_sk(unsigned char pk_seed[32]){
  unsigned char sktmp[MUPQ_CRYPTO_SECRETKEYBYTES];
  uint64_t t0,t1;
  MUPQ_crypto_sign_keypair_sk(sktmp, pk_seed);
  t0 = hal_get_time();
  write_sk_to_flash(sktmp);
  t1 = hal_get_time();
  return t1-t0;
}

static uint64_t do_keypair_pk(const unsigned char *sk, unsigned char pk_seed[32]){
  unsigned char pktmp[MUPQ_CRYPTO_PUBLICKEYBYTES];
  uint64_t t0,t1;
  MUPQ_crypto_sign_keypair_pk(pktmp, sk, pk_seed);
  t0 = hal_get_time();
  write_pk_to_flash(pktmp);
  t1 = hal_get_time();
  return t1-t0;
}
#endif

int main(void)
{
  #ifdef KEYS_IN_FLASH
  const unsigned char *sk = get_sk_flash();
  const unsigned char *pk = get_pk_flash();
  unsigned char pk_seed[32];
  #else
  unsigned char sk[MUPQ_CRYPTO_SECRETKEYBYTES];
  unsigned char pk[MUPQ_CRYPTO_PUBLICKEYBYTES];
  #endif

  unsigned char sm[MLEN+MUPQ_CRYPTO_BYTES];
  size_t smlen;
  unsigned long long t0, t1;
  int i;

  hal_setup(CLOCK_BENCHMARK);

  hal_send_str("==========================");


  // Key-pair generation
  t0 = hal_get_time();
  #ifdef KEYS_IN_FLASH
  uint64_t skflashcycles = do_keypair_sk(pk_seed);
  uint64_t pkflashcycles = do_keypair_pk(sk, pk_seed);
  t1 = hal_get_time();
  printcycles("keypair cycles:", t1-t0);
  printcycles("flashing cycles:", skflashcycles+pkflashcycles);
  printcycles("keypair (w/o writing to flash) cycles:", t1-t0-skflashcycles-pkflashcycles);
  #else
  MUPQ_crypto_sign_keypair(pk, sk);
  t1 = hal_get_time();
  printcycles("keypair cycles:", t1-t0);
  #endif

  for(i=0;i<MUPQ_ITERATIONS; i++)
  {
    // Signing
    t0 = hal_get_time();
    MUPQ_crypto_sign(sm, &smlen, sm, MLEN, sk);
    t1 = hal_get_time();
    printcycles("sign cycles:", t1-t0);

    // Verification
    t0 = hal_get_time();
    MUPQ_crypto_sign_open(sm, &smlen, sm, smlen, pk);
    t1 = hal_get_time();
    printcycles("verify cycles:", t1-t0);

    hal_send_str("+");
  }
  hal_send_str("#");
  return 0;
}
