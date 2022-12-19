#include "gf16_bitslice.i"
#include "gf16_madd_bitsliced.i"

.macro gf16_trimat_eval dim, batch_size
  push {r4-r11, lr}
  vpush {s16-s19}
  .if \batch_size != 32
     ERROR: batch_size not implemented yet
  .endif

  tmp0 .req r4
  tmp1 .req r5
  tmp2 .req r6
  tmp3 .req r7
  tmp4 .req r8
  tmp5 .req r9
  tmp6 .req r10
  tmp7 .req r11
  tmp8 .req r3
  tmp9 .req r12
  tmp10 .req r14
  tmp11 .req r0
  iii .req r12
  jjj .req r14

  bb .req r2

  // 64 elements (0-31 bitsliced in s0-s3; 32-63 in s4-s7)
  yf0 .req s0
  yf1 .req s1
  yf2 .req s2
  yf3 .req s3
  yf4 .req s4
  yf5 .req s5
  yf6 .req s6
  yf7 .req s7

  tf0 .req s8
  tf1 .req s9
  tf2 .req s10
  tf3 .req s11
  tf4 .req s12
  tf5 .req s13
  tf6 .req s14
  tf7 .req s15

  iiif .req s16
  jjjf .req s17

  xf .req s18
  yf .req s19
  // stack: y, x
  vmov.w yf, r0
  vmov.w xf, r2

  // set y to 0
  mov.w r14, #0
  vmov.w yf0, r14
  vmov.w yf1, r14
  vmov.w yf2, r14
  vmov.w yf3, r14
  vmov.w yf4, r14
  vmov.w yf5, r14
  vmov.w yf6, r14
  vmov.w yf7, r14


  mov.w iii, #0
  vmov.w iiif, iii
  1:
    // set tmp to 0
    mov.w r14, #0
    vmov.w tf0, r14
    vmov.w tf1, r14
    vmov.w tf2, r14
    vmov.w tf3, r14
    vmov.w tf4, r14
    vmov.w tf5, r14
    vmov.w tf6, r14
    vmov.w tf7, r14

    mov.w jjj, iii
    vmov.w jjjf, jjj
    2:
        vmov.w bb, xf
        lsrs.w jjj, jjj, #1
        ldrb.w bb, [bb, jjj]
        it cs
        lsrcs.w bb, bb, #4

        // first 32 elements
        ldr.w tmp9, [r1, #1*4]
        ldr.w tmp10, [r1, #2*4]
        ldr.w tmp11, [r1, #3*4]
        ldr.w tmp8, [r1], #4*4

        gf16_bitslice tmp4, tmp5, tmp6, tmp7, tmp8, tmp9, tmp10, tmp11

        vmov.w tmp0, tf0
        vmov.w tmp1, tf1
        vmov.w tmp2, tf2
        vmov.w tmp3, tf3

        gf16_madd_bitsliced tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, bb, tmp8, tmp9, tmp10, tmp11

        vmov.w tf0, tmp0
        vmov.w tf1, tmp1
        vmov.w tf2, tmp2
        vmov.w tf3, tmp3

        // second 32 elements
        ldr.w tmp9, [r1, #1*4]
        ldr.w tmp10, [r1, #2*4]
        ldr.w tmp11, [r1, #3*4]
        ldr.w tmp8, [r1], #4*4

        gf16_bitslice tmp4, tmp5, tmp6, tmp7, tmp8, tmp9, tmp10, tmp11

        vmov.w tmp0, tf4
        vmov.w tmp1, tf5
        vmov.w tmp2, tf6
        vmov.w tmp3, tf7

        gf16_madd_bitsliced tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, bb, tmp8, tmp9, tmp10, tmp11

        vmov.w tf4, tmp0
        vmov.w tf5, tmp1
        vmov.w tf6, tmp2
        vmov.w tf7, tmp3

    vmov.w jjj, jjjf
    add.w jjj, #1
    vmov.w jjjf, jjj
    cmp.w jjj, #\dim
    bne.w 2b

  vmov.w iii, iiif
  vmov.w bb, xf
  lsrs.w iii, iii, #1
  ldrb.w bb, [bb, iii]
  it cs
  lsrcs.w bb, bb, #4

  vmov.w tmp0, yf0
  vmov.w tmp1, yf1
  vmov.w tmp2, yf2
  vmov.w tmp3, yf3

  vmov.w tmp4, tf0
  vmov.w tmp5, tf1
  vmov.w tmp6, tf2
  vmov.w tmp7, tf3

  gf16_madd_bitsliced tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, bb, tmp8, tmp9, tmp10, tmp11

  vmov.w yf0, tmp0
  vmov.w yf1, tmp1
  vmov.w yf2, tmp2
  vmov.w yf3, tmp3


  vmov.w tmp0, yf4
  vmov.w tmp1, yf5
  vmov.w tmp2, yf6
  vmov.w tmp3, yf7

  vmov.w tmp4, tf4
  vmov.w tmp5, tf5
  vmov.w tmp6, tf6
  vmov.w tmp7, tf7

  gf16_madd_bitsliced tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, bb, tmp8, tmp9, tmp10, tmp11

  vmov.w yf4, tmp0
  vmov.w yf5, tmp1
  vmov.w yf6, tmp2
  vmov.w yf7, tmp3

  vmov.w iii, iiif
  add.w iii, #1
  vmov.w iiif, iii
  cmp.w iii, #\dim
  bne.w 1b

  // store y
  vmov.w r0, yf
  vmov.w tmp0, yf0
  vmov.w tmp1, yf1
  vmov.w tmp2, yf2
  vmov.w tmp3, yf3

  gf16_bitslice tmp4, tmp5, tmp6, tmp7, tmp0, tmp1, tmp2, tmp3

  str.w tmp5, [r0, #1*4]
  str.w tmp6, [r0, #2*4]
  str.w tmp7, [r0, #3*4]
  str.w tmp4, [r0], #4*4

  vmov.w tmp0, yf4
  vmov.w tmp1, yf5
  vmov.w tmp2, yf6
  vmov.w tmp3, yf7

  gf16_bitslice tmp4, tmp5, tmp6, tmp7, tmp0, tmp1, tmp2, tmp3

  str.w tmp5, [r0, #1*4]
  str.w tmp6, [r0, #2*4]
  str.w tmp7, [r0, #3*4]
  str.w tmp4, [r0], #4*4

  vpop.w {s16-s19}
  pop.w {r4-r11, pc}
.endm