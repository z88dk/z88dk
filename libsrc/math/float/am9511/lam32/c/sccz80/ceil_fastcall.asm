
	SECTION	code_fp_am9511
	PUBLIC	ceil_fastcall
	EXTERN	asm_am9511_ceil_fastcall

	defc	ceil_fastcall = asm_am9511_ceil_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ceil_fastcall
defc _ceil_fastcall = asm_am9511_ceil_fastcall
ENDIF

