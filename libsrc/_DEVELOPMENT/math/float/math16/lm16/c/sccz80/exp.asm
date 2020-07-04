
	SECTION	code_fp_math16
	PUBLIC	exp
	EXTERN	_m16_expf

	defc	exp = _m16_expf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp
EXTERN cm16_sdcc_exp
defc _exp = cm16_sdcc_exp
ENDIF

