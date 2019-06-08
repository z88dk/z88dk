
	SECTION	code_fp

	PUBLIC	l_f48_ldexp

	EXTERN	dload
	EXTERN	fa

;
; double ldexp (double x, int exp);
; Generate value from significand and exponent
; Returns the result of multiplying x (the significand) by 2 
; raised to the power of exp (the exponent).

; Stack:     float value, ret
; Registers: a = amount to adjust exponent
l_f48_ldexp:
	ld	hl,2
	add	hl,sp
	call	dload
	ld	hl,fa+5
	add	(hl)
	ld	(hl),a
	pop	hl	;return address
	pop	bc	;Junk passed in flaot
	pop	bc
	pop	bc
	jp	(hl)
