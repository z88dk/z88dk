
	SECTION	code_fp_am9511
	PUBLIC	mul2_fastcall
	EXTERN	asm_am9511_fmul2_fastcall

	defc	mul2_fastcall = asm_am9511_fmul2_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul2_fastcall
defc _mul2_fastcall = asm_am9511_fmul2_fastcall
ENDIF

