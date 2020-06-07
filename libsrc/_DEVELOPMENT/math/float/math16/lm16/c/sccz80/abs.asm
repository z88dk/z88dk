
	SECTION	code_fp_math16
	PUBLIC	m16_abs
	EXTERN	asm_f16_abs

	defc	m16_abs = asm_f16_abs


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_abs
EXTERN cm16_sdcc_abs
defc _m16_abs = cm16_sdcc_abs
ENDIF

