
SECTION code_fp_math32

PUBLIC m32_fpclassify

m32_fpclassify:
	; enter : dehl= double x
	;
	; exit  :  a = 0 if number
	;            = 1 if zero
	;            = 2 if nan
	;            = 3 if inf
	;
	; uses  : af

	ld	a,d
	and	$7f
	or	e
	or	h	
	or	l
	jr	z,zero

	; Infinity - sign = whatever
	;	     exponent = all 1s;
	;            mantissa = 0
	; Nan	   - sign = whatever
	;	     exponent = all 1s;
	;            mantissa = not 0
	ld	a,d
	rlc	e	; Get exponent bit into carry
	rl	a	; a = exponent
	rrc	e	; Rotate e back 
	cpl
	and	a
	jr	nz,number
	; So we could be nan, or inf here
	ld	a,e
	and	$7f
	or	h
	or	l
	ld	a,3	;infinity
	ret	z
	dec	a	;It's NaN
	ret

number:
	xor	a
	ret


zero:
	inc	a
	ret

