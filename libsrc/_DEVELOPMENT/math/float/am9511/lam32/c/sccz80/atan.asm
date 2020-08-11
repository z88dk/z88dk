
	SECTION	code_fp_am9511
	PUBLIC	atan
	EXTERN	asm_am9511_atan_fastcall

	defc	atan = asm_am9511_atan_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atan
EXTERN cam32_sdcc_atan
defc _atan = cam32_sdcc_atan
ENDIF

