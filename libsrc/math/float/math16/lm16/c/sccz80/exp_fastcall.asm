
	SECTION	code_fp_math16
	PUBLIC	expf16_fastcall
	EXTERN	_m16_expf

	defc	expf16_fastcall = _m16_expf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _expf16_fastcall
defc _expf16_fastcall = _m16_expf
ENDIF

