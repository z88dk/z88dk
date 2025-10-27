
	SECTION	code_fp_am9511
	PUBLIC	exp10_fastcall
	EXTERN	_am9511_exp10

	defc	exp10_fastcall = _am9511_exp10


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp10_fastcall
defc _exp10_fastcall = _am9511_exp10
ENDIF

