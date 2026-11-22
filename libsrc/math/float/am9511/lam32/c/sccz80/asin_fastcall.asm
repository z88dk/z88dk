
	SECTION	code_fp_am9511
	PUBLIC	asin_fastcall
	EXTERN	asm_am9511_asinf_fastcall

	defc	asin_fastcall = asm_am9511_asinf_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asin_fastcall
defc _asin_fastcall = asm_am9511_asinf_fastcall
ENDIF

