
	SECTION	code_fp_math16
	PUBLIC	m16_neg
	EXTERN	asm_f16_neg

	defc	m16_neg = asm_f16_neg


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_neg
EXTERN cm16_sdcc_neg
defc _m16_neg = cm16_sdcc_neg
ENDIF

