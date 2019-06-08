

	SECTION	code_fp_mbf32
	PUBLIC	ldexp

; float ldexpf (float x, int16_t pw2)
ldexp:
	ld	hl,2
	add	hl,sp
	ld	a,(hl)	;pw2
	ld	bc,5
	add	hl,bc	;points to exponent
	add	(hl)
	ld	(hl),a
	ret
