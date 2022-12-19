#ifndef _AES256_KEYEXP_FFS_H_
#define _AES256_KEYEXP_FFS_H_

#include "stdint.h"

void _aes256_keyschedule_ffs(uint32_t rkeys[120], const unsigned char key0[32],
                                const unsigned char key1[32]);

#endif

