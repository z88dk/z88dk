
	SECTION	code_fp_math32
	PUBLIC	asin
	EXTERN	_m32_asinf

	defc	asin = _m32_asinf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asin
defc _asin = _m32_asinf
ENDIF

