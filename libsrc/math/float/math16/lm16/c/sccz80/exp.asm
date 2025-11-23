
	SECTION	code_fp_math16
	PUBLIC	expf16
	EXTERN	_m16_expf

	defc	expf16 = _m16_expf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _expf16
defc _expf16 = expf16
ENDIF

