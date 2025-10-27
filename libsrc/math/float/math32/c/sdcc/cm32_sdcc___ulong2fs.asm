
SECTION code_fp_math32
PUBLIC cm32_sdcc___ulong2fs

EXTERN m32_float32u


cm32_sdcc___ulong2fs:
	pop	bc	;return
	pop	hl	;value
	pop	de
	push	de
	push	hl
	push	bc
	jp	m32_float32u
