
	SECTION	code_fp_am9511
	PUBLIC	sinh_fastcall
	EXTERN	_am9511_sinh

	defc	sinh_fastcall = _am9511_sinh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sinh_fastcall
defc _sinh_fastcall = _am9511_sinh
ENDIF

