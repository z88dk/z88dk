
	SECTION	code_fp_am9511
	PUBLIC	cosh_fastcall
	EXTERN	_am9511_cosh

	defc	cosh_fastcall = _am9511_cosh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cosh_fastcall
defc _cosh_fastcall = _am9511_cosh
ENDIF

