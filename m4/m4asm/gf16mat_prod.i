#include "gf16_bitslice.i"
#include "gf16_madd_bitsliced.i"

.macro gf16_mat_prod_x n_A_vec_byte

  .if \n_A_vec_byte % 16 != 0
    ERROR n_A_vec_byte % 8 != 0 not implemented
  .endif


  push {r4-r11, lr}

  cptr .req r0
  aptr .req r1
  bptr .req r2
  n_A_width .req r3

  bb .req r3

  accu0 .req r4
  accu1 .req r5
  accu2 .req r6
  accu3 .req r7


  tmp1 .req r12
  tmp2 .req r14
  tmp3 .req r2
  tmp4 .req r0

  b_ptr_orig_f .req s0
  b_ptr_f .req s1
  c_ptr_f .req s2
  ctrf0 .req s3
  ctrf1 .req s4
  offsetf .req s5
  n_A_widthf .req s6


  vmov.w b_ptr_orig_f, bptr
  vmov.w b_ptr_f, bptr
  vmov.w c_ptr_f, cptr
  vmov.w n_A_widthf, n_A_width

  add.w r4, cptr, #\n_A_vec_byte
  vmov.w ctrf0, r4

  mov.w r4, #\n_A_vec_byte
  mul.w r4, r4, n_A_width
  sub.w r4, r4, #16
  vmov.w offsetf, r4

  1:
    mov.w accu0, #0
    mov.w accu1, #0
    mov.w accu2, #0
    mov.w accu3, #0


    vmov.w tmp1, n_A_widthf
    2:
        ldr.w bb, [bptr], #4
        vmov.w b_ptr_f, bptr

        // check if more than 8 elements
        cmp.w tmp1, #8
        bge.w 3f

        4:
          vmov.w ctrf1, tmp1
          ldr.w tmp1, [aptr, #0*4]
          ldr.w tmp2, [aptr, #1*4]
          ldr.w tmp3, [aptr, #2*4]
          ldr.w tmp4, [aptr, #3*4]
          add.w aptr, #\n_A_vec_byte
          gf16_bitslice r8, r9, r10, r11, tmp1, tmp2, tmp3, tmp4
          gf16_madd_bitsliced accu0, accu1, accu2, accu3, r8, r9, r10, r11, bb, tmp1, tmp2, tmp3, tmp4
          lsr.w bb, bb, #4

        vmov.w tmp1, ctrf1
        subs.w tmp1, tmp1, #1
        bne 4b
        b 5f

        3:
        vmov.w ctrf1, tmp1

        .set kk, 0
        .rept 8
            ldr.w tmp1, [aptr, #0*4]
            ldr.w tmp2, [aptr, #1*4]
            ldr.w tmp3, [aptr, #2*4]
            ldr.w tmp4, [aptr, #3*4]
            add.w aptr, #\n_A_vec_byte

            gf16_bitslice r8, r9, r10, r11, tmp1, tmp2, tmp3, tmp4
            gf16_madd_bitsliced accu0, accu1, accu2, accu3, r8, r9, r10, r11, bb, tmp1, tmp2, tmp3, tmp4

            .if kk != 7
            lsr.w bb, bb, #4
            .endif
            .set kk, kk+1
        .endr
        vmov.w bptr, b_ptr_f
        vmov.w tmp1, ctrf1
        subs.w tmp1, tmp1, #8
        bne 2b
    5:

    gf16_bitslice r8, r9, r10, r11, r4, r5, r6, r7

    vmov.w bptr, b_ptr_orig_f

    // (\n_A_vec_byte*\n_A_width-16)
    vmov.w r4, offsetf
    sub.w aptr, r4

    vmov.w cptr, c_ptr_f
    str.w r9, [cptr, #1*4]
    str.w r10, [cptr, #2*4]
    str.w r11, [cptr, #3*4]
    str.w r8, [cptr], #16
    vmov.w c_ptr_f, cptr

    vmov.w r4, ctrf0
    cmp.w r0, r4
    bne.w 1b

  pop {r4-r11, pc}
.endm


.macro gf16_mat_prod n_A_vec_byte, n_A_width

  .if \n_A_width % 8 != 0
    ERROR n_A_width % 8 != 0 not implemented
  .endif

  .if \n_A_vec_byte % 16 != 0
    ERROR n_A_vec_byte % 8 != 0 not implemented
  .endif


  push {r4-r11, lr}

  cptr .req r0
  aptr .req r1
  bptr .req r2

  bb .req r3

  accu0 .req r4
  accu1 .req r5
  accu2 .req r6
  accu3 .req r7


  tmp1 .req r12
  tmp2 .req r14
  tmp3 .req r2
  tmp4 .req r0

  b_ptr_orig_f .req s0
  b_ptr_f .req s1
  c_ptr_f .req s2
  ctrf0 .req s3
  ctrf1 .req s4
  offsetf .req s5


  vmov.w b_ptr_orig_f, bptr
  vmov.w b_ptr_f, bptr
  vmov.w c_ptr_f, cptr

  add.w r4, cptr, #\n_A_vec_byte
  vmov.w ctrf0, r4


  movw.w r4, #:lower16:(\n_A_vec_byte*\n_A_width-16)
  movt.w r4, #:upper16:(\n_A_vec_byte*\n_A_width-16)
  vmov.w offsetf, r4

  1:
    mov.w accu0, #0
    mov.w accu1, #0
    mov.w accu2, #0
    mov.w accu3, #0

    add.w tmp1, bptr, #\n_A_width/2
    vmov.w ctrf1, tmp1

    2:
        ldr.w bb, [bptr], #4
        vmov.w b_ptr_f, bptr
        .set kk, 0
        .rept 8
            ldr.w tmp1, [aptr, #0*4]
            ldr.w tmp2, [aptr, #1*4]
            ldr.w tmp3, [aptr, #2*4]
            ldr.w tmp4, [aptr, #3*4]
            add.w aptr, #\n_A_vec_byte

            gf16_bitslice r8, r9, r10, r11, tmp1, tmp2, tmp3, tmp4
            gf16_madd_bitsliced accu0, accu1, accu2, accu3, r8, r9, r10, r11, bb, tmp1, tmp2, tmp3, tmp4

            .if kk != 7
            lsr.w bb, bb, #4
            .endif
            .set kk, kk+1
        .endr
        vmov.w bptr, b_ptr_f
        vmov.w tmp1, ctrf1
        cmp.w bptr, tmp1
        bne 2b


    gf16_bitslice r8, r9, r10, r11, r4, r5, r6, r7

    vmov.w bptr, b_ptr_orig_f

    // (\n_A_vec_byte*\n_A_width-16)
    vmov.w r4, offsetf
    sub.w aptr, r4

    vmov.w cptr, c_ptr_f
    str.w r9, [cptr, #1*4]
    str.w r10, [cptr, #2*4]
    str.w r11, [cptr, #3*4]
    str.w r8, [cptr], #16
    vmov.w c_ptr_f, cptr

    vmov.w r4, ctrf0
    cmp.w r0, r4
    bne.w 1b

  pop {r4-r11, pc}
.endm