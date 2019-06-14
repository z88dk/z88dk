
SECTION code_fp_math32
PUBLIC cm32_sdcc___schar2fs

EXTERN m32_float16


cm32_sdcc___schar2fs:
	pop	bc	;return
	pop	hl	;value
	push	hl
	push	bc
	ld	a,l
	rlca	
	sbc	a
	ld	h,a
	jp	m32_float16
