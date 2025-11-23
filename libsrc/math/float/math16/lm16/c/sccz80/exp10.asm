
	SECTION	code_fp_math16
	PUBLIC	exp10f16
	EXTERN	_m16_exp10f

	defc	exp10f16 = _m16_exp10f


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp10f16
defc _exp10f16 = exp10f16
ENDIF
