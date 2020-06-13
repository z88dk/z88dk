
	SECTION	code_fp_math16
	PUBLIC	f16_mul2
	EXTERN	asm_f16_mul2

	defc	f16_mul2 = asm_f16_mul2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_mul2
EXTERN cm16_sdcc_mul2
defc _f16_mul2 = cm16_sdcc_mul2
ENDIF

