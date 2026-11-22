
	SECTION	code_fp_am9511
	PUBLIC	atanh_fastcall
	EXTERN	_am9511_atanh

	defc	atanh_fastcall = _am9511_atanh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atanh_fastcall
defc _atanh_fastcall = _am9511_atanh
ENDIF

