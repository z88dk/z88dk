
	SECTION	code_fp_am9511
	PUBLIC	asinh_fastcall
	EXTERN	_am9511_asinh

	defc	asinh_fastcall = _am9511_asinh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asinh_fastcall
defc _asinh_fastcall = _am9511_asinh
ENDIF

