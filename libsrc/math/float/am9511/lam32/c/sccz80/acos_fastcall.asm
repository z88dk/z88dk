
	SECTION	code_fp_am9511
	PUBLIC	acos_fastcall
	EXTERN	asm_am9511_acos_fastcall

	defc	acos_fastcall = asm_am9511_acos_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acos_fastcall
defc _acos_fastcall = asm_am9511_acos_fastcall
ENDIF

