
	SECTION	code_fp_am9511
	PUBLIC	asin
	EXTERN	asm_am9511_asinf_fastcall

	defc	asin = asm_am9511_asinf_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asin
EXTERN cam32_sdcc_asin
defc _asin = cam32_sdcc_asin
ENDIF

