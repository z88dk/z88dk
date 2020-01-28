
	SECTION	code_fp_math32
	PUBLIC	asin
	EXTERN	_m32_asinf

	defc	asin = _m32_asinf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asin
EXTERN cm32_sdcc_asin
defc _asin = cm32_sdcc_asin
ENDIF

