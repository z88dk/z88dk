
	SECTION	code_fp_am9511
	PUBLIC	cos_fastcall
	EXTERN	asm_am9511_cos_fastcall

	defc	cos_fastcall = asm_am9511_cos_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cos_fastcall
defc _cos_fastcall = asm_am9511_cos_fastcall
ENDIF

