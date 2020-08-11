
	SECTION	code_fp_am9511
	PUBLIC	sin
	EXTERN	asm_am9511_sin_fastcall

	defc	sin = asm_am9511_sin_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sin
EXTERN cam32_sdcc_sin
defc _sin = cam32_sdcc_sin
ENDIF

