
	SECTION	code_fp_am9511
	PUBLIC	log2_fastcall
	EXTERN	_am9511_log2

	defc	log2_fastcall = _am9511_log2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log2_fastcall
defc _log2_fastcall = _am9511_log2
ENDIF

