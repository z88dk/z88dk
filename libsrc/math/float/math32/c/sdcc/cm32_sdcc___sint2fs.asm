
SECTION code_fp_math32
PUBLIC cm32_sdcc___sint2fs

EXTERN m32_float16


cm32_sdcc___sint2fs:
	pop	bc	;return
	pop	hl	;value
	push	hl
	push	bc
	jp	m32_float16
