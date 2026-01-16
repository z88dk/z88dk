
SECTION code_fp_math32
PUBLIC cm32_sdcc___slong2fs

EXTERN m32_float32


cm32_sdcc___slong2fs:
	pop	bc	;return
	pop	hl	;value
	pop	de
	push	de
	push	hl
	push	bc
	jp	m32_float32
