
	SECTION	code_fp_am9511
	PUBLIC	mul10u_fastcall
	EXTERN	asm_am9511_fmul10u_fastcall

	defc	mul10u_fastcall = asm_am9511_fmul10u_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul10u_fastcall
defc _mul10u_fastcall = asm_am9511_fmul10u_fastcall
ENDIF

