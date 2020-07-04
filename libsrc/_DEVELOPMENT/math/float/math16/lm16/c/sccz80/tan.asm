
	SECTION	code_fp_math16
	PUBLIC	tan
	EXTERN	_m16_tanf

	defc	tan = _m16_tanf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tan
EXTERN cm16_sdcc_tan
defc _tan = cm16_sdcc_tan
ENDIF

