
	SECTION	code_fp_math16
	PUBLIC	cosf16_fastcall
	EXTERN	_m16_cosf

	defc	cosf16_fastcall = _m16_cosf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cosf16_fastcall
defc _cosf16_fastcall = _m16_cosf
ENDIF

