
	SECTION	code_fp__am9511_
	PUBLIC	div2_fastcall
	EXTERN	asm_am9511_fdiv2_fastcall

	defc	div2_fastcall = asm_am9511_fdiv2_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _div2_fastcall
defc _div2_fastcall = asm_am9511_fdiv2_fastcall
ENDIF

