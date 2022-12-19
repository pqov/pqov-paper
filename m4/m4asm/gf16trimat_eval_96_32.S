.syntax unified
.cpu cortex-m4
.thumb

#include "gf16trimat_eval.i"

//void gf16trimat_eval_m4f_96_32(uint32_t *c, uint32_t *a, uint8_t *b);
.global gf16trimat_eval_m4f_96_32
.type gf16trimat_eval_m4f_96_32, %function
.align 2
gf16trimat_eval_m4f_96_32:
    gf16_trimat_eval 96, 32
