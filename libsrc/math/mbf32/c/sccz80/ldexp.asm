

	SECTION	code_fp_mbf32
	PUBLIC	ldexp

; float ldexpf (float x, int16_t pw2)
ldexp:
	ld	hl,2
	add	hl,sp
	ld	a,(hl)	;pw2
	ld	hl,7	
	add	hl,sp	;exponent
	add	(hl)
	ld	d,a
	dec	hl
	ld	e,(hl)
	dec	hl
	ld	a,(hl)
	dec	hl
	ld	l,(hl)
	ld	h,a
	ret
