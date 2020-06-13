
	SECTION	code_fp_math16
	PUBLIC	f16_ceil
	EXTERN	asm_f16_ceil

	defc	f16_ceil = asm_f16_ceil


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_ceil
EXTERN cm16_sdcc_ceil
defc _f16_ceil = cm16_sdcc_ceil
ENDIF

