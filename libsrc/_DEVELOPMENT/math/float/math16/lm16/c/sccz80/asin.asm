
	SECTION	code_fp_math16
	PUBLIC	asinf16
	EXTERN	_m16_asinf

	defc	asinf16 = _m16_asinf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asinf16
EXTERN cm16_sdcc_asin
defc _asinf16 = cm16_sdcc_asin
ENDIF

