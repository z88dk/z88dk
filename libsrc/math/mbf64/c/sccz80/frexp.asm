
SECTION code_fp

PUBLIC frexp
EXTERN l_f64_load
EXTERN  ___mbf64_FA

; float frexpf (float x, int *pw2);
frexp:
	ld	hl,4
	add	hl,sp
	call	l_f64_load
	pop	bc	;Ret
	pop	de	;pw2
	push	de
	push	bc
	ld	hl,___mbf64_FA + 7
	ld	a,(hl)
	and	a
	ld	(hl),0
	jr	z,zero
	sub	$80
	ld	(hl),128
zero:
	ld	(de),a
	inc	de
	rlca
	sbc	a
	ld	(de),a
	ret
