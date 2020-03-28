
	SECTION	code_fp

	PUBLIC	l_f48_ldexp

	EXTERN	fa

;
; double ldexp (double x, int exp);
; Generate value from significand and exponent
; Returns the result of multiplying x (the significand) by 2 
; raised to the power of exp (the exponent).

; Stack:     float value, ret
; Registers: a = amount to adjust exponent
l_f48_ldexp:
	ld	hl,fa+5
	ld	c,a
	ld	a,(hl)
	and	a
	ret	z
	add	c
	ld	(hl),a
	ret
