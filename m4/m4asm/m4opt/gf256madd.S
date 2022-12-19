.syntax unified
.cpu cortex-m4
.thumb

// 37 cycles
.macro gf256_madd_precompb fbx0, fbx1, fbx2,fbx3, fbx4, fbx5, fbx6, fbx7, bb, c01010101, pconst, tmp1
    // duplicate bb
    ubfx \bb, \bb, #0, #8
    // bx^0
    vmov.w \fbx0, \bb

    // bx^1
    and.w \tmp1, \c01010101, \bb, lsr #7
    eor.w \bb, \bb, \tmp1, lsl #7
    mul.w \tmp1, \tmp1, \pconst
    eor.w \bb, \tmp1, \bb, lsl#1
    vmov.w \fbx1, \bb

    // bx^2
    and.w \tmp1, \c01010101, \bb, lsr #7
    eor.w \bb, \bb, \tmp1, lsl #7
    mul.w \tmp1, \tmp1, \pconst
    eor.w \bb, \tmp1, \bb, lsl#1
    vmov.w \fbx2, \bb

    // bx^3
    and.w \tmp1, \c01010101, \bb, lsr #7
    eor.w \bb, \bb, \tmp1, lsl #7
    mul.w \tmp1, \tmp1, \pconst
    eor.w \bb, \tmp1, \bb, lsl#1
    vmov.w \fbx3, \bb

    // bx^4
    and.w \tmp1, \c01010101, \bb, lsr #7
    eor.w \bb, \bb, \tmp1, lsl #7
    mul.w \tmp1, \tmp1, \pconst
    eor.w \bb, \tmp1, \bb, lsl#1
    vmov.w \fbx4, \bb

    // bx^5
    and.w \tmp1, \c01010101, \bb, lsr #7
    eor.w \bb, \bb, \tmp1, lsl #7
    mul.w \tmp1, \tmp1, \pconst
    eor.w \bb, \tmp1, \bb, lsl#1
    vmov.w \fbx5, \bb

    // bx^6
    and.w \tmp1, \c01010101, \bb, lsr #7
    eor.w \bb, \bb, \tmp1, lsl #7
    mul.w \tmp1, \tmp1, \pconst
    eor.w \bb, \tmp1, \bb, lsl#1
    vmov.w \fbx6, \bb

    // bx^7
    and.w \tmp1, \c01010101, \bb, lsr #7
    eor.w \bb, \bb, \tmp1, lsl #7
    mul.w \tmp1, \tmp1, \pconst
    eor.w \bb, \tmp1, \bb, lsl#1
    vmov.w \fbx7, \bb
.endm


// 13 cc
.macro gf256_madd_inner k, acc0, acc1, acc2, acc3, aa0, aa1, aa2, aa3, fbx, c01010101, tmp0, tmp1
    vmov.w \tmp1, \fbx

    and.w \tmp0, \c01010101, \aa0, lsr\k
    mul.w \tmp0, \tmp1, \tmp0
    eor.w \acc0, \acc0, \tmp0

    and.w \tmp0, \c01010101, \aa1, lsr\k
    mul.w \tmp0, \tmp1, \tmp0
    eor.w \acc1, \acc1, \tmp0

    and.w \tmp0, \c01010101, \aa2, lsr\k
    mul.w \tmp0, \tmp1, \tmp0
    eor.w \acc2, \acc2, \tmp0

    and.w \tmp0, \c01010101, \aa3, lsr\k
    mul.w \tmp0, \tmp1, \tmp0
    eor.w \acc3, \acc3, \tmp0
.endm

// 13*8 = 104 cc
.macro gf256_madd acc0, acc1, acc2, acc3, aa0, aa1, aa2, aa3, fbx0, fbx1, fbx2, fbx3, fbx4, fbx5, fbx6, fbx7, c01010101, tmp0, tmp1
    gf256_madd_inner #0, \acc0, \acc1, \acc2, \acc3, \aa0, \aa1, \aa2, \aa3, \fbx0, \c01010101, \tmp0, \tmp1
    gf256_madd_inner #1, \acc0, \acc1, \acc2, \acc3, \aa0, \aa1, \aa2, \aa3, \fbx1, \c01010101, \tmp0, \tmp1
    gf256_madd_inner #2, \acc0, \acc1, \acc2, \acc3, \aa0, \aa1, \aa2, \aa3, \fbx2, \c01010101, \tmp0, \tmp1
    gf256_madd_inner #3, \acc0, \acc1, \acc2, \acc3, \aa0, \aa1, \aa2, \aa3, \fbx3, \c01010101, \tmp0, \tmp1
    gf256_madd_inner #4, \acc0, \acc1, \acc2, \acc3, \aa0, \aa1, \aa2, \aa3, \fbx4, \c01010101, \tmp0, \tmp1
    gf256_madd_inner #5, \acc0, \acc1, \acc2, \acc3, \aa0, \aa1, \aa2, \aa3, \fbx5, \c01010101, \tmp0, \tmp1
    gf256_madd_inner #6, \acc0, \acc1, \acc2, \acc3, \aa0, \aa1, \aa2, \aa3, \fbx6, \c01010101, \tmp0, \tmp1
    gf256_madd_inner #7, \acc0, \acc1, \acc2, \acc3, \aa0, \aa1, \aa2, \aa3, \fbx7, \c01010101, \tmp0, \tmp1
.endm




.global gf256madd_asm
.type gf256madd_asm, %function
.align 2
gf256madd_asm:
    push.w {r4-r11, lr}

    ldr.w r4, [r1, #0*4]
    ldr.w r5, [r1, #1*4]
    ldr.w r6, [r1, #2*4]
    ldr.w r7, [r1, #3*4]

    ldr.w r8,  [r0, #0*4]
    ldr.w r9,  [r0, #1*4]
    ldr.w r10, [r0, #2*4]
    ldr.w r11, [r0, #3*4]
    mov.w r12, #0x1b
    mov.w r14, #0x01010101
    gf256_madd_precompb s0, s1, s2, s3, s4, s5, s6, s7, r2, r14, r12, r3
    gf256_madd r8, r9, r10, r11, r4, r5, r6, r7, s0, s1, s2, s3, s4, s5, s6, s7, r14, r1, r3


    @ gf256_madd 4, 0, r8, r9, r10, r11, r4, r5, r6, r7, r2, r12, r1, r3, r14

    str.w r8, [r0, #0*4]
    str.w r9, [r0, #1*4]
    str.w r10, [r0, #2*4]
    str.w r11, [r0, #3*4]
    //vstr.w s4,[r0, #0*4]
    //vstr.w s5,[r0, #1*4]
    //vstr.w s6, [r0, #2*4]
    //vstr.w s7, [r0, #3*4]

    pop.w {r4-r11, pc}
