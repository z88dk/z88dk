
	SECTION	code_fp_am9511
	PUBLIC	mul2
	EXTERN	asm_am9511_mul2_fastcall

	defc	mul2 = asm_am9511_mul2_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul2
EXTERN cam32_sdcc_mul2
defc _mul2 = cam32_sdcc_mul2
ENDIF

