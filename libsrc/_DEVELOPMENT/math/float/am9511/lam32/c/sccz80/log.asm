
	SECTION	code_fp_am9511
	PUBLIC	log
	EXTERN	asm_am9511_log_fastcall

	defc	log = asm_am9511_log_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log
EXTERN cam32_sdcc_log
defc _log = cam32_sdcc_log
ENDIF

