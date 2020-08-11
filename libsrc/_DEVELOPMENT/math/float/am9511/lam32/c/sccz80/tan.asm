
	SECTION	code_fp_am9511
	PUBLIC	tan
	EXTERN	asm_am9511_tan_fastcall

	defc	tan = asm_am9511_tan_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tan
EXTERN cam32_sdcc_tan
defc _tan = cam32_sdcc_tan
ENDIF

