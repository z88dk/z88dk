
	SECTION	code_fp_am9511
	PUBLIC	exp_fastcall
	EXTERN	asm_am9511_exp_fastcall

	defc	exp_fastcall = asm_am9511_exp_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp_fastcall
defc _exp_fastcall = asm_am9511_exp_fastcall
ENDIF

