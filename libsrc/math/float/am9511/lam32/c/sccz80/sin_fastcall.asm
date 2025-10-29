
	SECTION	code_fp_am9511
	PUBLIC	sin_fastcall
	EXTERN	asm_am9511_sin_fastcall

	defc	sin_fastcall = asm_am9511_sin_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sin_fastcall
defc _sin_fastcall = asm_am9511_sin_fastcall
ENDIF

