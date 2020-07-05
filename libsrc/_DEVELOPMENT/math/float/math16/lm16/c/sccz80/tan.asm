
	SECTION	code_fp_math16
	PUBLIC	tanf16
	EXTERN	_m16_tanf

	defc	tanf16 = _m16_tanf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tanf16
EXTERN cm16_sdcc_tan
defc _tanf16 = cm16_sdcc_tan
ENDIF

