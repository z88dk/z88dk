
	SECTION	code_fp_math16
	PUBLIC	exp10_fastcall
	EXTERN	_m16_exp10f

	defc	exp10_fastcall = _m16_exp10f

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp10_fastcall
defc _exp10_fastcall = _m16_exp10f
ENDIF

