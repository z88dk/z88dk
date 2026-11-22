
SECTION code_fp_math32
PUBLIC cm32_sdcc___uint2fs_callee

EXTERN m32_float16u


cm32_sdcc___uint2fs_callee:
	pop	bc	;return
	pop	hl	;value
	push	bc
	jp	m32_float16u
