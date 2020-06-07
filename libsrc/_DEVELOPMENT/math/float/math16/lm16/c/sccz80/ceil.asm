
	SECTION	code_fp_math16
	PUBLIC	m16_ceil
	EXTERN	asm_f16_ceil

	defc	m16_ceil = asm_f16_ceil


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_ceil
EXTERN cm16_sdcc_ceil
defc _m16_ceil = cm16_sdcc_ceil
ENDIF

