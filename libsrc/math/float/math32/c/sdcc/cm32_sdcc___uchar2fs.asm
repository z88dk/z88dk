
SECTION code_fp_math32
PUBLIC cm32_sdcc___uchar2fs

EXTERN m32_float16u


cm32_sdcc___uchar2fs:
	pop	bc	;return
	pop	hl	;value
	push	hl
	push	bc
	ld	h,0
	jp	m32_float16u
