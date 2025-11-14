
	SECTION	code_fp_am9511
	PUBLIC	fabs_fastcall
	EXTERN	asm_am9511_fabs_fastcall

	defc	fabs_fastcall = asm_am9511_fabs_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fabs_fastcall
defc _fabs_fastcall = asm_am9511_fabs_fastcall
ENDIF

