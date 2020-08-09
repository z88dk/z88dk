
	SECTION	code_fp_am9511
	PUBLIC	div2
	EXTERN	asm_am9511_div2_fastcall

	defc	div2 = asm_am9511_div2_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _div2
EXTERN	cam32_sdcc_dcc_div2
defc _div2 = cam32_sdcc_dcc_div2
ENDIF

