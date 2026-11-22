
	SECTION	code_fp_am9511
	PUBLIC	tan_fastcall
	EXTERN	asm_am9511_tan_fastcall

	defc	tan_fastcall = asm_am9511_tan_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tan_fastcall
defc _tan_fastcall = asm_am9511_tan_fastcall
ENDIF

