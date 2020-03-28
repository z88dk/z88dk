
	SECTION	code_fp_math32
	PUBLIC	exp10
	EXTERN	_m32_exp10f

	defc	exp10 = _m32_exp10f


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp10
EXTERN cm32_sdcc_exp10
defc _exp10 = cm32_sdcc_exp10
ENDIF
