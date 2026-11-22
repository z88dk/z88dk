
	SECTION	code_fp_math48

	PUBLIC	l_f48_ldexp

	EXTERN	dload

;
; double ldexp (double x, int exp);
; Generate value from significand and exponent
; Returns the result of multiplying x (the significand) by 2 
; raised to the power of exp (the exponent).

; Stack:     float value, ret
; Registers: a = amount to adjust exponent
l_f48_ldexp:
	exx             ;switch to AC
	ex	af,af
	ld	a,l
	and	a
	ret	z
	ex	af,af
	add	l
	ld	l,a
	exx
	ret
