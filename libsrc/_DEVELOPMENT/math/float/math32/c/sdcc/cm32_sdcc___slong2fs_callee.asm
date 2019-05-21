
SECTION code_fp_math32
PUBLIC cm32_sdcc___slong2fs_callee

EXTERN m32_float32


cm32_sdcc___slong2fs_callee:
	pop	bc	;return
	pop	hl	;value
	pop	de
	push	bc
	jp	m32_float32
