
	SECTION	code_fp_math16
	PUBLIC	exp2f16_fastcall
	EXTERN	_m16_exp2f

	defc	exp2f16_fastcall = _m16_exp2f


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp2f16_fastcall
defc _exp2f16_fastcall = _m16_exp2f
ENDIF

