
	SECTION	code_fp_math16
	PUBLIC	asinf16_fastcall
	EXTERN	_m16_asinf

	defc	asinf16_fastcall = _m16_asinf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asinf16_fastcall
defc _asinf16_fastcall = _m16_asinf
ENDIF

