
	SECTION	code_fp_am9511
	PUBLIC	log_fastcall
	EXTERN	asm_am9511_log_fastcall

	defc	log_fastcall = asm_am9511_log_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log_fastcall
defc _log_fastcall = asm_am9511_log_fastcall
ENDIF

