
	SECTION	code_fp_am9511
	PUBLIC	log10_fastcall
	EXTERN	asm_am9511_log10_fastcall

	defc	log10_fastcall = asm_am9511_log10_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log10_fastcall
defc _log10_fastcall = asm_am9511_log10_fastcall
ENDIF

