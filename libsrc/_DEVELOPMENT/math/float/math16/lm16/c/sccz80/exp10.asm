
	SECTION	code_fp_math16
	PUBLIC	exp10
	EXTERN	_m16_exp10f

	defc	exp10 = _m16_exp10f


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp10
EXTERN cm16_sdcc_exp10
defc _exp10 = cm16_sdcc_exp10
ENDIF
