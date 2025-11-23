
	SECTION	code_fp_am9511
	PUBLIC	sqr_fastcall
	EXTERN	asm_am9511_sqr_fastcall

	defc	sqr_fastcall = asm_am9511_sqr_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqr_fastcall
defc _sqr_fastcall = asm_am9511_sqr_fastcall
ENDIF

