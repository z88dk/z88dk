
	SECTION	code_fp_math16
	PUBLIC	exp2f16
	EXTERN	_m16_exp2f

	defc	exp2f16 = _m16_exp2f


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp2f16
EXTERN cm16_sdcc_exp2
defc _exp2f16 = cm16_sdcc_exp2
ENDIF
