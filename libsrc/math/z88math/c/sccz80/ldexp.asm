
	SECTION	code_fp

	PUBLIC	ldexp
	PUBLIC	__ldexp_on_fa

	EXTERN	dload
	EXTERN	fa

IF FORz88
                INCLUDE  "target/z88/def/fpp.def"
ELSE
                INCLUDE "fpp.def"
ENDIF

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
	ld	c,(hl)
__ldexp_on_fa:
	ld	hl,fa+5
	ld	a,(hl)
	and	a
	jr	z,integer_format
	add	c
	ld	(hl),a
	ret

integer_format:
	push	bc		;Save shift factor
	ld	c,0
	ld	hl,(fa+1)
	exx
	ld	hl,(fa+3)
IF FORz88
	fpp(FP_FLT)
ELSE
	ld	a,FP_FLT
	call	FPP
ENDIF
	ld	a,c		;Exponent
	ld	(fa+3),hl
	exx
	ld	(fa+1),hl
	pop	bc		;Restore shift factor
	add	c
	ld	(fa+5),a
	ret
