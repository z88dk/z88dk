
	SECTION	code_fp_am9511
	PUBLIC	atan_fastcall
	EXTERN	asm_am9511_atan_fastcall

	defc	atan_fastcall = asm_am9511_atan_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atan_fastcall
defc _atan_fastcall = asm_am9511_atan_fastcall
ENDIF

