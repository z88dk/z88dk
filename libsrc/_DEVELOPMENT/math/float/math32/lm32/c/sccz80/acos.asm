
	SECTION	code_fp_math32
	PUBLIC	acos
	EXTERN	_m32_acosf

	defc	acos = _m32_acosf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acos
defc _acos = _m32_acosf
ENDIF

