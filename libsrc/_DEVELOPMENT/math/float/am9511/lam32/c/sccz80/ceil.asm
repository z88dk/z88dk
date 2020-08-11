
	SECTION	code_fp_am9511
	PUBLIC	ceil
	EXTERN	asm_am9511_ceil_fastcall

	defc	ceil = asm_am9511_ceil_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ceil
EXTERN cam32_sdcc_ceil
defc _ceil = cam32_sdcc_ceil
ENDIF

