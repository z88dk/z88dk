
SECTION code_fp_math32
PUBLIC cm32_sdcc___uint2fs

EXTERN m32_float16u


cm32_sdcc___uint2fs:
	pop	bc	;return
	pop	hl	;value
	push	hl
	push	bc
	jp	m32_float16u
