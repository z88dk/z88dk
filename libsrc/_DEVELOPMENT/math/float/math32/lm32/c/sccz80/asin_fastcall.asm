
	SECTION	code_fp_math32
	PUBLIC	asin_fastcall
	EXTERN	_m32_asinf

	defc	asin_fastcall = _m32_asinf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asin_fastcall
defc _asin_fastcall = _m32_asinf
ENDIF

