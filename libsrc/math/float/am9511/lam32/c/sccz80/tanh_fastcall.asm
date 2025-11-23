
	SECTION	code_fp_am9511
	PUBLIC	tanh_fastcall
	EXTERN	_am9511_tanh

	defc	tanh_fastcall = _am9511_tanh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tanh_fastcall
defc _tanh_fastcall = _am9511_tanh
ENDIF

