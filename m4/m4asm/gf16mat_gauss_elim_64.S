    .cpu cortex-m4

#include "gf16_bitslice.i"
#include "gf16_madd_bitsliced.i"
#include "gf16_mul_bitsliced.i"
#include "gf16_inverse.i"

.macro mul_row_bitsliced pivot, ai, mat0, mat1, mat2, mat3, tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7
    ldr.w \tmp0, [\ai, #4*0]
    ldr.w \tmp1, [\ai, #4*1]
    ldr.w \tmp2, [\ai, #4*2]
    ldr.w \tmp3, [\ai, #4*3]

    gf16_bitslice \mat0, \mat1, \mat2, \mat3, \tmp0, \tmp1, \tmp2, \tmp3
    gf16_mul_bitsliced \tmp0, \tmp1, \tmp2, \tmp3, \mat0, \mat1, \mat2, \mat3, \pivot, \tmp4, \tmp5, \tmp6, \tmp7
    vmov.w s0, \tmp0
    vmov.w s1, \tmp1
    vmov.w s2, \tmp2
    vmov.w s3, \tmp3
    gf16_bitslice \mat0, \mat1, \mat2, \mat3, \tmp0, \tmp1, \tmp2, \tmp3
    str.w \mat0, [\ai, #4*0]
    str.w \mat1, [\ai, #4*1]
    str.w \mat2, [\ai, #4*2]
    str.w \mat3, [\ai, #4*3]

    ldr.w \tmp0, [\ai, #4*4]
    ldr.w \tmp1, [\ai, #4*5]
    ldr.w \tmp2, [\ai, #4*6]
    ldr.w \tmp3, [\ai, #4*7]

    gf16_bitslice \mat0, \mat1, \mat2, \mat3, \tmp0, \tmp1, \tmp2, \tmp3
    gf16_mul_bitsliced \tmp0, \tmp1, \tmp2, \tmp3, \mat0, \mat1, \mat2, \mat3, \pivot, \tmp4, \tmp5, \tmp6, \tmp7
    vmov.w s4, \tmp0
    vmov.w s5, \tmp1
    vmov.w s6, \tmp2
    vmov.w s7, \tmp3
    gf16_bitslice \mat0, \mat1, \mat2, \mat3, \tmp0, \tmp1, \tmp2, \tmp3
    str.w \mat0, [\ai, #4*4]
    str.w \mat1, [\ai, #4*5]
    str.w \mat2, [\ai, #4*6]
    str.w \mat3, [\ai, #4*7]

    ldrb.w \tmp0, [\ai, #4*8]
    gf16_mul_single \tmp1, \tmp0, \pivot, \mat0, \mat1, \mat2, \mat3
    vmov.w s8, \tmp1
    str.w \tmp1, [\ai, #4*8]
.endm


.macro mul_row_bitsliced_second pivot, ai, mat0, mat1, mat2, mat3, tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7
    ldr.w \tmp0, [\ai, #4*4]
    ldr.w \tmp1, [\ai, #4*5]
    ldr.w \tmp2, [\ai, #4*6]
    ldr.w \tmp3, [\ai, #4*7]

    gf16_bitslice \mat0, \mat1, \mat2, \mat3, \tmp0, \tmp1, \tmp2, \tmp3
    gf16_mul_bitsliced \tmp0, \tmp1, \tmp2, \tmp3, \mat0, \mat1, \mat2, \mat3, \pivot, \tmp4, \tmp5, \tmp6, \tmp7
    vmov.w s4, \tmp0
    vmov.w s5, \tmp1
    vmov.w s6, \tmp2
    vmov.w s7, \tmp3
    gf16_bitslice \mat0, \mat1, \mat2, \mat3, \tmp0, \tmp1, \tmp2, \tmp3
    str.w \mat0, [\ai, #4*4]
    str.w \mat1, [\ai, #4*5]
    str.w \mat2, [\ai, #4*6]
    str.w \mat3, [\ai, #4*7]

    ldrb.w \tmp0, [\ai, #4*8]
    gf16_mul_single \tmp1, \tmp0, \pivot, \mat0, \mat1, \mat2, \mat3
    vmov.w s8, \tmp1
    str.w \tmp1, [\ai, #4*8]
.endm


.macro gf16_mul_single out, in1, in2, tmp0, tmp1, tmp2, tmp3
        and     \in2, #15
        and     \tmp2, \in1, #2
        sbfx    \tmp3, \in1, #0, #1
        and     \tmp3, \tmp3, \in2
        smulbb  \tmp2, \tmp2, \in2
        and     \tmp1, \in1, #4
        eor     \tmp2, \tmp2, \tmp3
        smulbb  \tmp1, \tmp1, \in2
        and     \in1, \in1, #8
        smulbb  \tmp0, \in1, \in2
        eor     \in1, \tmp2, \tmp1
        eors    \in1, \in1, \tmp0
        ubfx    \tmp2, \in1, #4, #4
        and     \tmp2, \tmp2, #5
        uxtb    \in1, \in1
        add     \tmp2, \tmp2, \tmp2, lsl #1
        ubfx    \tmp1, \in1, #5, #1
        add     \tmp1, \tmp1, \tmp1, lsl #1
        eors    \in1, \in1, \tmp2
        eor     \in1, \in1, \tmp1, lsl #1
        and     \out, \in1, #15
.endm

.macro madd_row_bitsliced pivot, ai, mat0, mat1, mat2, mat3, acc0, acc1, acc2, acc3, tmp0, tmp1, tmp2, tmp3
    ldr.w \tmp0, [\ai, #4*0]
    ldr.w \tmp1, [\ai, #4*1]
    ldr.w \tmp2, [\ai, #4*2]
    ldr.w \tmp3, [\ai, #4*3]

    gf16_bitslice \acc0, \acc1, \acc2, \acc3, \tmp0, \tmp1, \tmp2, \tmp3
    vmov \mat0, s0
    vmov \mat1, s1
    vmov \mat2, s2
    vmov \mat3, s3
    gf16_madd_bitsliced \acc0, \acc1, \acc2, \acc3, \mat0, \mat1, \mat2, \mat3, \pivot, \tmp0, \tmp1, \tmp2, \tmp3
    gf16_bitslice \mat0, \mat1, \mat2, \mat3, \acc0, \acc1, \acc2, \acc3

    str.w \mat0, [\ai, #4*0]
    str.w \mat1, [\ai, #4*1]
    str.w \mat2, [\ai, #4*2]
    str.w \mat3, [\ai, #4*3]

    ldr.w \tmp0, [\ai, #4*4]
    ldr.w \tmp1, [\ai, #4*5]
    ldr.w \tmp2, [\ai, #4*6]
    ldr.w \tmp3, [\ai, #4*7]
    gf16_bitslice \acc0, \acc1, \acc2, \acc3, \tmp0, \tmp1, \tmp2, \tmp3
    vmov \mat0, s4
    vmov \mat1, s5
    vmov \mat2, s6
    vmov \mat3, s7

    gf16_madd_bitsliced \acc0, \acc1, \acc2, \acc3, \mat0, \mat1, \mat2, \mat3, \pivot, \tmp0, \tmp1, \tmp2, \tmp3
    gf16_bitslice \mat0, \mat1, \mat2, \mat3, \acc0, \acc1, \acc2, \acc3

    str.w \mat0, [\ai, #4*4]
    str.w \mat1, [\ai, #4*5]
    str.w \mat2, [\ai, #4*6]
    str.w \mat3, [\ai, #4*7]

    ldrb.w \tmp0, [\ai, #4*8]
    vmov.w \tmp1, s8
    gf16_mul_single \tmp2,\tmp1, \pivot, \mat0, \mat1, \mat2, \mat3
    eor.w \tmp0, \tmp2
    strb.w \tmp0, [\ai, #4*8]
.endm


.macro madd_row_bitsliced_second pivot, ai, mat0, mat1, mat2, mat3, acc0, acc1, acc2, acc3, tmp0, tmp1, tmp2, tmp3
    ldr.w \tmp0, [\ai, #4*4]
    ldr.w \tmp1, [\ai, #4*5]
    ldr.w \tmp2, [\ai, #4*6]
    ldr.w \tmp3, [\ai, #4*7]
    gf16_bitslice \acc0, \acc1, \acc2, \acc3, \tmp0, \tmp1, \tmp2, \tmp3
    vmov \mat0, s4
    vmov \mat1, s5
    vmov \mat2, s6
    vmov \mat3, s7

    gf16_madd_bitsliced \acc0, \acc1, \acc2, \acc3, \mat0, \mat1, \mat2, \mat3, \pivot, \tmp0, \tmp1, \tmp2, \tmp3
    gf16_bitslice \mat0, \mat1, \mat2, \mat3, \acc0, \acc1, \acc2, \acc3

    str.w \mat0, [\ai, #4*4]
    str.w \mat1, [\ai, #4*5]
    str.w \mat2, [\ai, #4*6]
    str.w \mat3, [\ai, #4*7]

    ldrb.w \tmp0, [\ai, #4*8]
    vmov.w \tmp1, s8
    gf16_mul_single \tmp2,\tmp1, \pivot, \mat0, \mat1, \mat2, \mat3
    eor.w \tmp0, \tmp2
    strb.w \tmp0, [\ai, #4*8]
.endm


.macro gauss_elim_inner ai, pivotindex, tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9, tmp10, tmp11

    add.w \ai, \ai, #36
    add.w \tmp1, \pivotindex, #1

    vmov.w s19, \pivotindex
    1:
        vmov.w \pivotindex, s19
        lsrs.w \pivotindex, \pivotindex, #1
        ldrb.n \tmp0, [\ai, \pivotindex]
        it cs
        lsrcs.w \tmp0, \tmp0, #4
        vmov s20, \tmp1
        //madd_row_bitsliced \tmp0, \ai, aj0, aj1, aj2, aj3, ai0, ai1, ai2, ai3, aj, \pivotindex, \tmp1, r0
        madd_row_bitsliced \tmp0, \ai, \tmp2, \tmp3, \tmp4, \tmp5, \tmp6, \tmp7, \tmp8, \tmp9, \tmp10, \tmp11, \tmp1, \pivotindex
        vmov \tmp1, s20
    add.w \ai, #36
    add.w \tmp1, #1
    cmp.w \tmp1, #64
    bne.w 1b
    4:
.endm


.macro gauss_elim_inner_second ai, pivotindex, tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9, tmp10, tmp11
    cmp.w \pivotindex, #63
    beq 4f

    add.w \ai, \ai, #36
    add.w \tmp1, \pivotindex, #1

    vmov.w s19, \pivotindex
    1:
        vmov \pivotindex, s19
        lsrs.w \pivotindex, \pivotindex, #1
        ldrb.n \tmp0, [\ai, \pivotindex]
        it cs
        lsrcs.w \tmp0, \tmp0, #4
        vmov s20, \tmp1
        //madd_row_bitsliced \tmp0, \ai, aj0, aj1, aj2, aj3, ai0, ai1, ai2, ai3, aj, \pivotindex, \tmp1, r0
        madd_row_bitsliced_second \tmp0, \ai, \tmp2, \tmp3, \tmp4, \tmp5, \tmp6, \tmp7, \tmp8, \tmp9, \tmp10, \tmp11, \tmp1, \pivotindex
        vmov \tmp1, s20
    add.w \ai, #36
    add.w \tmp1, #1
    cmp.w \tmp1, #64
    bne.w 1b
    4:
.endm


    .p2align 2,,3
    .global	gf16mat_gauss_elim_row_echolen_m4f_64
    .arch armv7e-m
    .syntax unified
    .thumb
    .thumb_func
    .fpu fpv4-sp-d16
    .type	gf16mat_gauss_elim_row_echolen_m4f_64, %function
gf16mat_gauss_elim_row_echolen_m4f_64:
    push {r4-r11, r14}
    vpush {s16-s31}
    ai .req r3
    ii .req r1
    pivot .req r2
    jj .req r4

    aj0 .req r9
    aj1 .req r6
    aj2 .req r7
    aj3 .req r8

    ai0 .req r5
    ai1 .req r10
    ai2 .req r11
    ai3 .req r12


    pivot0 .req r9
    pivot1 .req r10
    pivot2 .req r11
    pivot3 .req r12
    aj   .req r14

    matrix_fpu .req s16
    vector_fpu .req s17
    extmat_fpu  .req s18
    stopjj .req s19

    vmov.w extmat_fpu, r0

    // start the Gauss elimination
    vmov.w ai, extmat_fpu
    mov.w ii, #0
    mov.w r0, #1
    outer: // outer loop: for each row

        // First: make sure that pivot in this row is not zero, by adding the other rows in case it is zero
        add.w jj, ii, #1

        # add at most 15 rows
        add.w aj, ii, #16
        cmp.w aj, #64
        it ge
        movge.w aj, #64
        nop.n
        vmov.w stopjj, aj

        add.w aj, ai, #36
        inner:
        // We could make the index computation faster by using another registers;
        // but then we would need another comparison for the ite
        lsrs.w pivot, ii, #1
        ldrb.n pivot, [ai, pivot]
        // this selects the right GF16 depending on if ii is even or odd
        ite cs
        lsrcs.w pivot, pivot, #4
        andcc pivot, pivot, #0xF

        cmp.w pivot, #0
        .set k,0
        .rept 2

        ldr.w aj1, [aj, #4*(1)]
        ldr.w aj2, [aj, #4*(2)]
        ldr.w aj3, [aj, #4*(3)]
        ldr.w aj0, [aj], #16

        ldr.w ai0, [ai, #4*(k+0)]
        ldr.w ai1, [ai, #4*(k+1)]
        ldr.w ai2, [ai, #4*(k+2)]
        ldr.w ai3, [ai, #4*(k+3)]


        itttt eq
        eoreq ai0, ai0, aj0
        eoreq ai1, ai1, aj1
        eoreq ai2, ai2, aj2
        eoreq ai3, ai3, aj3
        nop.n

        str.w ai0, [ai, #4*(k+0)]
        str.w ai1, [ai, #4*(k+1)]
        str.w ai2, [ai, #4*(k+2)]
        str.w ai3, [ai, #4*(k+3)]
        .set k, k+4
        .endr

        ldr.w aj0, [aj], #4
        ldr.w ai0, [ai, #4*8]
        it eq
        eoreq ai0, ai0, aj0
        str.w ai0, [ai, #4*8]

        adds.w jj, #1

        vmov.w ai0, stopjj
        cmp.w jj, ai0
        bne.w inner
        nop.n

    outer2: // for the last row, we don't have rows left to add, so we skip the inner loop
    lsrs.w pivot, ii, #1
    ldrb.n pivot, [ai, pivot]
    ite cs
    lsrcs.w pivot, pivot, #4
    andcc pivot, pivot, #0xF

    cmp.n pivot, #0
    it eq
    moveq.w r0, #0


    // get mat
    push.w {r0}

    // invert pivot
    mov.w r0, pivot
    gf16_inverse pivot, r0, ai0, ai1

    push.w {r1, r3}

    ldr.w ii, [sp, #0]
    cmp.w ii, #32
    bge second_half


    mul_row_bitsliced pivot, ai, ai0, ai1, ai2, ai3, aj0, aj1, aj2, aj3, r0, jj, aj, ii
    gauss_elim_inner ai, ii, r4, r5, r6, r7, r8, r9, r10, r11, r12, r0, r2, r14
    b.w end
    second_half:
    mul_row_bitsliced_second pivot, ai, ai0, ai1, ai2, ai3, aj0, aj1, aj2, aj3, r0, jj, aj, ii
    gauss_elim_inner_second ai, ii, r4, r5, r6, r7, r8, r9, r10, r11, r12, r0, r2, r14
    end:

    pop.w {r1, r3}
    pop.w {r0}

    add ai, ai, #36
    add.w ii, ii, #1
    cmp.w ii, #63
    blt.w outer
    beq.w outer2

    vpop {s16-s31}
    pop {r4-r11, pc}