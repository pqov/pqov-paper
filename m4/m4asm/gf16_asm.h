#ifndef GF16_ASM__H
#define GF16_ASM__H

#include <stdint.h>
#include "utils_prng.h"

extern const uint8_t gf16mul_lut[];
// gf16mat_prod.S
void gf16mat_prod_m4f_2048_96_normal_normal(uint8_t *c, const uint8_t *matA, const uint8_t *b);
void gf16mat_prod_m4f_48_64_normal_normal(uint8_t *c, const uint8_t *matA, const uint8_t *b);
void gf16mat_prod_m4f_32_X_normal_normal(uint8_t *c, const uint8_t *matA, const uint8_t *b, size_t n_A_width);

// gf16mat_inv_32.S
unsigned gf16mat_inv_m4f_32(uint8_t *inv, const uint8_t *mat);

// gf16mat_inv_64.S
unsigned gf16mat_inv_m4f_64(uint8_t *inv, const uint8_t *mat);

// gf16trimat_eval_96_32.S
void gf16trimat_eval_m4f_96_32(uint8_t * y, const uint8_t * trimat, const uint8_t * x);

// gf16trimat_eval_160_32_publicinputs.S
void gf16trimat_eval_m4f_160_32_publicinputs(uint8_t * y, const uint8_t * trimat, const uint8_t * x, const uint8_t *lut);

// gf16trimat_eval_160_32_incremental_publicinputs.S
void gf16trimat_eval_m4f_160_32_incremental_publicinputs(uint8_t * y, const uint8_t * trimat, const uint8_t * x, const uint8_t *lut, prng_publicinputs_t *prng);

// gf16trimat_2trimat_madd_96_48_64_32.S
void gf16trimat_2trimat_madd_m4f_96_48_64_32(uint8_t *c, const uint8_t *a, const uint8_t *b);

// gf16mat_gauss_elim_64.S
uint8_t gf16mat_gauss_elim_row_echolen_m4f_64(uint8_t *mat);

#endif