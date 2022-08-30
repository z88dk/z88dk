
	SECTION	code_fp_math32
	PUBLIC	exp
	EXTERN	_m32_expf

	defc	exp = _m32_expf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp
defc _exp = _m32_expf
ENDIF

