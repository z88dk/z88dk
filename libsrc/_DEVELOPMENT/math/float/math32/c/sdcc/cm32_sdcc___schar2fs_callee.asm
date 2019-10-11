
SECTION code_fp_math32
PUBLIC cm32_sdcc___schar2fs_callee

EXTERN m32_float16


cm32_sdcc___schar2fs_callee:
	pop	bc	;return
	pop	hl	;value
	dec	sp
	push	bc
	ld	a,l
	rlca	
	sbc	a
	ld	h,a
	jp	m32_float16
