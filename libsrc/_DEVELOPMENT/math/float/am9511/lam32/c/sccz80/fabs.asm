
	SECTION	code_fp_am9511
	PUBLIC	fabs
	EXTERN	asm_am9511_fabs_fastcall

	defc	fabs = asm_am9511_fabs_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fabs
EXTERN cam32_sdcc_fabs
defc _fabs = cam32_sdcc_fabs
ENDIF

