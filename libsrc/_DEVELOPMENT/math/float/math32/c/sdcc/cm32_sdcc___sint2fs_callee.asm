
SECTION code_fp_math32
PUBLIC cm32_sdcc___sint2fs_callee

EXTERN m32_float16


cm32_sdcc___sint2fs_callee:
	pop	bc	;return
	pop	hl	;value
	push	bc
	jp	m32_float16
