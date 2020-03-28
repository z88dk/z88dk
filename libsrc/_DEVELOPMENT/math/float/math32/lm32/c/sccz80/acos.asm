
	SECTION	code_fp_math32
	PUBLIC	acos
	EXTERN	_m32_acosf

	defc	acos = _m32_acosf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acos
EXTERN cm32_sdcc_acos
defc _acos = cm32_sdcc_acos
ENDIF

