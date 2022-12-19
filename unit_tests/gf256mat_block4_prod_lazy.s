.macro gf256_mul_lazy out0, out1, in0, in1, tmp0, tmp1
	pmull.8h	\tmp0, \in0, \in1
	pmull2.8h	\tmp1, \in0, \in1
	eor.16b	\out0, \out0, \tmp0 
	eor.16b	\out1, \out1, \tmp1
.endm


	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 12, 0	sdk_version 12, 3
	.globl	_gf256mat_block4_prod_lazy      ; -- Begin function gf256mat_block4_prod_lazy
	.p2align	2
_gf256mat_block4_prod_lazy:             ; @gf256mat_block4_prod_lazy
	.cfi_startproc
; %bb.0:
	cbz	w4, LBB0_4
; %bb.1:
	movi.2d	v5, #0000000000000000
	movi.2d	v4, #0000000000000000
	mov	w8, w2
	add	x9, x1, #32
	movi.2d	v2, #0000000000000000
	movi.2d	v0, #0000000000000000
	movi.2d	v7, #0000000000000000
	movi.2d	v6, #0000000000000000
	mov	w10, w4
	movi.2d	v3, #0000000000000000
	movi.2d	v1, #0000000000000000
LBB0_2:                                 ; =>This Inner Loop Header: Depth=1
	ldp	q16, q17, [x9, #-32]
	ldp	q18, q19, [x9]
	ld1r.16b	{ v20 }, [x3], #1

	gf256_mul_lazy v5, v7, v16 , v20, v21 , v16
	gf256_mul_lazy v4, v6, v17 , v20, v21 , v16
	gf256_mul_lazy v2, v3, v18 , v20, v21 , v16
	gf256_mul_lazy v0, v1, v19 , v20, v21 , v16

	add	x9, x9, x8
	subs	x10, x10, #1
	b.ne	LBB0_2
; %bb.3:
Lloh0:
	adrp	x8, ___gf256_bit8_11_reduce@GOTPAGE
Lloh1:
	ldr	x8, [x8, ___gf256_bit8_11_reduce@GOTPAGEOFF]
Lloh2:
	ldr	q16, [x8]
	uzp1.16b	v17, v5, v7
	uzp2.16b	v5, v5, v7
Lloh3:
	adrp	x8, ___gf256_bit12_15_reduce@GOTPAGE
Lloh4:
	ldr	x8, [x8, ___gf256_bit12_15_reduce@GOTPAGEOFF]
Lloh5:
	ldr	q7, [x8]
	movi.16b	v18, #15
	and.16b	v19, v5, v18
	tbl.16b	v19, { v16 }, v19
	ushr.16b	v5, v5, #4
	tbl.16b	v5, { v7 }, v5
	eor3.16b	v5, v19, v17, v5
	uzp1.16b	v17, v4, v6
	uzp2.16b	v4, v4, v6
	and.16b	v6, v4, v18
	tbl.16b	v6, { v16 }, v6
	ushr.16b	v4, v4, #4
	tbl.16b	v4, { v7 }, v4
	eor3.16b	v4, v6, v17, v4
	uzp1.16b	v6, v2, v3
	uzp2.16b	v2, v2, v3
	and.16b	v3, v2, v18
	tbl.16b	v3, { v16 }, v3
	ushr.16b	v2, v2, #4
	tbl.16b	v2, { v7 }, v2
	eor3.16b	v2, v3, v6, v2
	uzp1.16b	v3, v0, v1
	uzp2.16b	v0, v0, v1
	and.16b	v1, v0, v18
	tbl.16b	v1, { v16 }, v1
	ushr.16b	v0, v0, #4
	tbl.16b	v0, { v7 }, v0
	stp	q5, q4, [x0]
	eor3.16b	v0, v1, v3, v0
	stp	q2, q0, [x0, #32]
	ret
LBB0_4:
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x0, #32]
	stp	q0, q0, [x0]
	ret
	.loh AdrpLdrGotLdr	Lloh3, Lloh4, Lloh5
	.loh AdrpLdrGotLdr	Lloh0, Lloh1, Lloh2
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
