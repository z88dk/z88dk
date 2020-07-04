
	SECTION	code_fp_math16
	PUBLIC	asin_fastcall
	EXTERN	_m16_asinf

	defc	asin_fastcall = _m16_asinf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asin_fastcall
defc _asin_fastcall = _m16_asinf
ENDIF

