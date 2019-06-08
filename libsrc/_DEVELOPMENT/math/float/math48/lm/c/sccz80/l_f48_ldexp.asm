
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
	ld	hl,2
	add	hl,sp
	ex	af,af
	call	dload
	ex	af,af
	exx             ;switch to AC
	add	l
	ld	l,a
	exx
	pop	hl	;return address
	pop	bc	;Junk passed in flaot
	pop	bc
	pop	bc
	jp	(hl)
