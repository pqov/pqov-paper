.syntax unified
.cpu cortex-m4
.thumb

#include "gf16_bitslice.i"
#include "gf16_madd_bitsliced.i"

.macro madd_32 accf0, accf1, accf2, accf3, accf4, accf5, accf6, accf7, matptr, bb, tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9, tmp10, tmp11
    ldr.w \tmp9, [\matptr, #4*1]
    ldr.w \tmp10, [\matptr, #4*2]
    ldr.w \tmp11, [\matptr, #4*3]
    ldr.w \tmp8, [\matptr], #4*4

    gf16_bitslice \tmp4, \tmp5, \tmp6, \tmp7, \tmp8, \tmp9, \tmp10, \tmp11

    vmov.w \tmp0, \accf0
    vmov.w \tmp1, \accf1
    vmov.w \tmp2, \accf2
    vmov.w \tmp3, \accf3

    gf16_madd_bitsliced \tmp0, \tmp1, \tmp2, \tmp3, \tmp4, \tmp5, \tmp6, \tmp7, \bb, \tmp8, \tmp9, \tmp10, \tmp11

    vmov.w \accf0, \tmp0
    vmov.w \accf1, \tmp1
    vmov.w \accf2, \tmp2
    vmov.w \accf3, \tmp3

    ldr.w \tmp9, [\matptr, #4*1]
    ldr.w \tmp10, [\matptr, #4*2]
    ldr.w \tmp11, [\matptr, #4*3]
    ldr.w \tmp8, [\matptr], #4*4

    gf16_bitslice \tmp4, \tmp5, \tmp6, \tmp7, \tmp8, \tmp9, \tmp10, \tmp11

    vmov.w \tmp0, \accf4
    vmov.w \tmp1, \accf5
    vmov.w \tmp2, \accf6
    vmov.w \tmp3, \accf7

    gf16_madd_bitsliced \tmp0, \tmp1, \tmp2, \tmp3, \tmp4, \tmp5, \tmp6, \tmp7, \bb, \tmp8, \tmp9, \tmp10, \tmp11

    vmov.w \accf4, \tmp0
    vmov.w \accf5, \tmp1
    vmov.w \accf6, \tmp2
    vmov.w \accf7, \tmp3
.endm


//void gf16trimat_2trimat_madd_m4f_96_48_64_32(uint32_t *c, uint32_t *a, uint8_t *b);
.global gf16trimat_2trimat_madd_m4f_96_48_64_32
.type gf16trimat_2trimat_madd_m4f_96_48_64_32, %function
.align 2
gf16trimat_2trimat_madd_m4f_96_48_64_32:
    push.w {r4-r11, r14}
    vpush.w {s16-s17}

    cc .req r0
    aa .req r1
    bb .req r2

    tmp1 .req r12
    tmp2 .req r14
    tmp3 .req r0
    tmp4 .req r3

    accf0 .req s0
    accf1 .req s1
    accf2 .req s2
    accf3 .req s3
    accf4 .req s4
    accf5 .req s5
    accf6 .req s6
    accf7 .req s7

    ccf   .req s8
    aaf   .req s9
    bbbf  .req s10
    iii   .req s11
    maxaa .req s12
    kkk   .req s13
    maxbb .req s14

    origAA .req s15
    origBB  .req s16
    incrAA .req s17

    mov.w tmp1, #0
    vmov.w iii, tmp1
    vmov.w ccf, cc
    vmov.w origAA, aa
    vmov.w origBB, bb

    4:
    vmov.w aa, origAA
    vmov.w bbbf, origBB

    // aa = aa + size_batch*((Aheight + Aheight - i + 1 )*i/2 + 1);
    vmov.w tmp1, iii
    rsb.w tmp2, tmp1, #96+96+1
    mul.w tmp2, tmp1, tmp2
    asr.w tmp2, tmp2, #1
    add.w tmp2, #1
    mov.w tmp1, #32
    mla.w aa, tmp1, tmp2, aa
    vmov.w aaf, aa
    vmov.w bb, bbbf

    # maxbb = B + 64*48
    add.w tmp1, bb, #64*48
    vmov.w maxbb, tmp1
    3:
    vmov.w cc, ccf
    ldr.w r4, [cc, #4*0]
    ldr.w r5, [cc, #4*1]
    ldr.w r6, [cc, #4*2]
    ldr.w r7, [cc, #4*3]

    gf16_bitslice r8, r9, r10, r11, r4, r5, r6, r7

    vmov.w accf0, r8
    vmov.w accf1, r9
    vmov.w accf2, r10
    vmov.w accf3, r11

    ldr.w r4, [cc, #4*4]
    ldr.w r5, [cc, #4*5]
    ldr.w r6, [cc, #4*6]
    ldr.w r7, [cc, #4*7]

    gf16_bitslice r8, r9, r10, r11, r4, r5, r6, r7

    vmov.w accf4, r8
    vmov.w accf5, r9
    vmov.w accf6, r10
    vmov.w accf7, r11

    // k = 0 .. i-1
    vmov.w tmp1, iii
    cmp.w tmp1, #0
    beq.w skip_first

    // for(unsigned k=0;k<i;k++)
    vmov.w aa, origAA
    mov.w tmp2, #32 // size_batch
    mla.w aa, tmp1, tmp2, aa
    mov.w tmp1, #0
    vmov.w kkk, tmp1
    mov.w tmp1, #(96-2)*32
    vmov.w incrAA, tmp1
    1:
        vmov.w bb, bbbf
        vmov.w tmp2, kkk
        lsrs.w tmp2, tmp2, #1
        ldrb.w bb, [bb, tmp2]
        it cs
        lsrcs.w bb, bb, #4

        madd_32 accf0, accf1, accf2, accf3, accf4, accf5, accf6, accf7, aa, bb, r0, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r14

        vmov.w tmp1, incrAA
        add.w aa, aa, tmp1
        sub.w tmp1, tmp1, #32
        vmov.w incrAA, tmp1


        vmov.w tmp1, kkk
        add.w tmp1, tmp1, #1
        vmov.w kkk, tmp1
        vmov.w tmp2, iii
        cmp.w tmp1, tmp2
        bne.w 1b

    // check if i==95
    vmov.w tmp1, iii
    cmp.w tmp1, #95
    beq.w skip_second

    skip_first:

    vmov.w aa, aaf

    vmov.w tmp1, iii
    add.w tmp1, tmp1, #1
    vmov.w kkk, tmp1
    // k = i+1 .. Bheight-1
    2:
        vmov.w bb, bbbf
        vmov.w tmp2, kkk
        lsrs.w tmp2, tmp2, #1
        ldrb.w bb, [bb, tmp2]
        it cs
        lsrcs.w bb, bb, #4

        madd_32 accf0, accf1, accf2, accf3, accf4, accf5, accf6, accf7, aa, bb, r0, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r14

        vmov.w tmp1, kkk
        add.w tmp1, tmp1, #1
        vmov.w kkk, tmp1
        cmp.w tmp1, #96 //Bheight
        bne.w 2b


    skip_second:
    // store accumulators
    vmov.w cc, ccf
    vmov.w r4, accf0
    vmov.w r5, accf1
    vmov.w r6, accf2
    vmov.w r7, accf3

    gf16_bitslice r8, r9, r10, r11, r4, r5, r6, r7

    str.w r9, [cc, #4*1]
    str.w r10, [cc, #4*2]
    str.w r11, [cc, #4*3]
    str.w r8, [cc], #16

    vmov.w r4, accf4
    vmov.w r5, accf5
    vmov.w r6, accf6
    vmov.w r7, accf7

    gf16_bitslice r8, r9, r10, r11, r4, r5, r6, r7

    str.w r9, [cc, #4*1]
    str.w r10, [cc, #4*2]
    str.w r11, [cc, #4*3]
    str.w r8, [cc], #16

    vmov.w ccf, cc

    // increment bb
    vmov.w tmp1, bbbf
    add.w tmp1, #48
    vmov.w bbbf, tmp1

    vmov.w tmp2, maxbb
    cmp.w tmp1, tmp2
    bne.w 3b

    vmov.w tmp1, iii
    add.w tmp1, #1
    vmov.w iii, tmp1
    cmp.w tmp1, #96 // Bheight
    bne.w 4b

    vpop.w {s16-s17}
    pop.w {r4-r11, pc}

