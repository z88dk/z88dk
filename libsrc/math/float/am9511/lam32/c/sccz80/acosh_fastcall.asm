
	SECTION	code_fp_am9511
	PUBLIC	acosh_fastcall
	EXTERN	_am9511_acosh

	defc	acosh_fastcall = _am9511_acosh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acosh_fastcall
defc _acosh_fastcall = _am9511_acosh
ENDIF

