.syntax unified
.cpu cortex-m4
.thumb

#include "gf16mat_prod.i"

//void gf16mat_prod_m4f_2048_96_normal_normal(uint32_t *c, uint32_t *a, uint8_t *b);
.global gf16mat_prod_m4f_2048_96_normal_normal
.type gf16mat_prod_m4f_2048_96_normal_normal, %function
.align 2
gf16mat_prod_m4f_2048_96_normal_normal:
    gf16_mat_prod 2048, 96


//void gf16mat_prod_m4f_48_64_normal_normal(uint32_t *c, uint32_t *a, uint8_t *b);
.global gf16mat_prod_m4f_48_64_normal_normal
.type gf16mat_prod_m4f_48_64_normal_normal, %function
.align 2
gf16mat_prod_m4f_48_64_normal_normal:
    gf16_mat_prod 48, 64

//void gf16mat_prod_m4f_32_X_normal_normal(uint8_t *c, const uint8_t *matA, const uint8_t *b, size_t n_A_width);
.global gf16mat_prod_m4f_32_X_normal_normal
.type gf16mat_prod_m4f_32_X_normal_normal, %function
.align 2
gf16mat_prod_m4f_32_X_normal_normal:
    gf16_mat_prod_x 32
