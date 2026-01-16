
	SECTION	code_fp_am9511
	PUBLIC	exp2_fastcall
	EXTERN	_am9511_exp2

	defc	exp2_fastcall = _am9511_exp2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp2_fastcall
defc _exp2_fastcall = _am9511_exp2
ENDIF

