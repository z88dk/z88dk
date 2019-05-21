
SECTION code_fp_math32
PUBLIC cm32_sdcc___uchar2fs_callee

EXTERN m32_float16u


cm32_sdcc___uchar2fs_callee:
	pop	bc	;return
	pop	hl	;value
	dec	sp
	push	bc
	ld	h,0
	jp	m32_float16u
