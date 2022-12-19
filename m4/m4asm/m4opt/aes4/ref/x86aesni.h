#ifndef _X86AESNI_H_
#define _X86AESNI_H_

#include "stdint.h"

void AES256_Key_Expansion (const unsigned char *userkey, unsigned char *key);

void AES256_CTR_Encrypt ( unsigned char *out, unsigned long n_16B, const unsigned char *key, const unsigned char nonce[12], uint32_t ctr );


#endif  // _X86AESNI_H_
