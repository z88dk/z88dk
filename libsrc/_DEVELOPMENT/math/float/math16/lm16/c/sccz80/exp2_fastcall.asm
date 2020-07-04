
	SECTION	code_fp_math16
	PUBLIC	exp2_fastcall
	EXTERN	_m16_exp2f

	defc	exp2_fastcall = _m16_exp2f

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp2_fastcall
defc _exp2_fastcall = _m16_exp2f
ENDIF

