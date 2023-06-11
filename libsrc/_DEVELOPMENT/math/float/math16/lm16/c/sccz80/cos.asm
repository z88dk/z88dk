
	SECTION	code_fp_math16
	PUBLIC	cosf16
	EXTERN	_m16_cosf

	defc	cosf16 = _m16_cosf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cosf16
defc _cosf16 = cosf16
ENDIF

