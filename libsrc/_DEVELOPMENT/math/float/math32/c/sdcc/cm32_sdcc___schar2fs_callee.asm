
SECTION code_fp_math32
PUBLIC cm32_sdcc___schar2fs_callee

EXTERN m32_float16


cm32_sdcc___schar2fs_callee:
	pop	bc	;return
	dec	sp
	pop	af	;value
	push	bc
	ld	l,a
	rlca
	sbc	a
	ld	h,a
	jp	m32_float16
