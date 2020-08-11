
	SECTION	code_fp_am9511
	PUBLIC	acos
	EXTERN	asm_am9511_acos_fastcall

	defc	acos = asm_am9511_acos_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acos
EXTERN cam32_sdcc_acos
defc _acos = cam32_sdcc_acos
ENDIF

