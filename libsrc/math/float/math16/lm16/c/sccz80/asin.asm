
	SECTION	code_fp_math16
	PUBLIC	asinf16
	EXTERN	_m16_asinf

	defc	asinf16 = _m16_asinf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asinf16
defc _asinf16 = asinf16
ENDIF

