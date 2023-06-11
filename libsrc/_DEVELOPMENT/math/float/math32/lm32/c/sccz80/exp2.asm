
	SECTION	code_fp_math32
	PUBLIC	exp2
	EXTERN	_m32_exp2f

	defc	exp2 = _m32_exp2f


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp2
defc _exp2 = _m32_exp2f
ENDIF
