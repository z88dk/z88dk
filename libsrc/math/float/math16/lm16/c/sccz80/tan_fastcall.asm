
	SECTION	code_fp_math16
	PUBLIC	tanf16_fastcall
	EXTERN	_m16_tanf

	defc	tanf16_fastcall = _m16_tanf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tanf16_fastcall
defc _tanf16_fastcall = _m16_tanf
ENDIF

