
	SECTION	code_fp

	PUBLIC	ldexp

	EXTERN	dload
	EXTERN	fa

;
; double ldexp (double x, int exp);
; Generate value from significand and exponent
; Returns the result of multiplying x (the significand) by 2 
; raised to the power of exp (the exponent).

ldexp:
	ld	hl,4
	add	hl,sp
	call	dload
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	ld	hl,fa+5
	add	(hl)
	ld	(hl),a
	ret
