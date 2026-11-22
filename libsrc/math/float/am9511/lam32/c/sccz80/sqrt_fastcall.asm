
	SECTION	code_fp_am9511
	PUBLIC	sqrt_fastcall
	EXTERN	asm_am9511_sqrt_fastcall

	defc	sqrt_fastcall = asm_am9511_sqrt_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqrt_fastcall
defc _sqrt_fastcall = asm_am9511_sqrt_fastcall
ENDIF

