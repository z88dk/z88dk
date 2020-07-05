
	SECTION	code_fp_math16
	PUBLIC	exp10f16_fastcall
	EXTERN	_m16_exp10f

	defc	exp10f16_fastcall = _m16_exp10f


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp10f16_fastcall
defc _exp10f16_fastcall = _m16_exp10f
ENDIF

