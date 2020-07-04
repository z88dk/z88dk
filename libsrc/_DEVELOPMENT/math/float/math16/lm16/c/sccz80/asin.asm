
	SECTION	code_fp_math16
	PUBLIC	asin
	EXTERN	_m16_asinf

	defc	asin = _m16_asinf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asin
EXTERN cm16_sdcc_asin
defc _asin = cm16_sdcc_asin
ENDIF

