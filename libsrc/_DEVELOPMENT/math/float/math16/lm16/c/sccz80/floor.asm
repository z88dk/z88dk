
	SECTION	code_fp_math16
	PUBLIC	floorf16
	EXTERN	asm_f16_floor

	defc	floorf16 = asm_f16_floor


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _floorf16
defc _floorf16 = floorf16
ENDIF

