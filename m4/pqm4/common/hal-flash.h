#ifndef HAL_FLASH_H
#define HAL_FLASH_H

#include "api.h"

// for classic and CZ it's sufficient to generate sk and pk separately and put
// those into flash
void write_sk_to_flash(unsigned char *sk);
void write_pk_to_flash(unsigned char *pk);

const unsigned char *get_sk_flash();
const unsigned char *get_pk_flash();

// for compressed, we additionally need to put one expanded secret key into
// flash during key gen
#ifdef _OV_PKC_SKC
void write_tmp_to_flash(unsigned char *tmp);
const unsigned char *get_tmp_flash();
#endif

#endif