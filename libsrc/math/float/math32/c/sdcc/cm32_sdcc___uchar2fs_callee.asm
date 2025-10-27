
SECTION code_fp_math32
PUBLIC cm32_sdcc___uchar2fs_callee

EXTERN m32_float16u


cm32_sdcc___uchar2fs_callee:
	pop	bc	;return
	dec	sp
	pop	hl	;value
	push	bc
	ld	l,h
	ld	h,0
	jp	m32_float16u
