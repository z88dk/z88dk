
	SECTION	code_fp_am9511
	PUBLIC	mul10u
	EXTERN	asm_am9511_mul10u_fastcall

	defc	mul10u = asm_am9511_mul10u_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul10u
EXTERN cam32_sdcc_mul10u
defc _mul10u = cam32_sdcc_mul10u
ENDIF

