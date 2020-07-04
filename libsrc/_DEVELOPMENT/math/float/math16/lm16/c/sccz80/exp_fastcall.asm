
	SECTION	code_fp_math16
	PUBLIC	exp_fastcall
	EXTERN	_m16_expf

	defc	exp_fastcall = _m16_expf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp_fastcall
defc _exp_fastcall = _m16_expf
ENDIF

