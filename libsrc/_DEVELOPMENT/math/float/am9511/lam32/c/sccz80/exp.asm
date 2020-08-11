
	SECTION	code_fp_am9511
	PUBLIC	exp
	EXTERN	asm_am9511_exp_fastcall

	defc	exp = asm_am9511_exp_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp
EXTERN cam32_sdcc_exp
defc _exp = cam32_sdcc_exp
ENDIF

