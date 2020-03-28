
SECTION code_fp

PUBLIC ldexp
EXTERN l_f64_load
EXTERN  ___mbf64_FA

; float ldexpf (float x, int *pw2);
ldexp:
	ld	hl,4
	add	hl,sp
	call	l_f64_load
	ld	hl,2
	add	hl,sp	
	ld	c,(hl)
	ld	hl,___mbf64_FA + 7
	ld	a,(hl)
	and	a
	ret	z
	add	c
	ld	(hl),a
	ret
