
	SECTION	code_fp_math16
	PUBLIC	f16_floor
	EXTERN	asm_f16_floor

	defc	f16_floor = asm_f16_floor


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_floor
EXTERN cm16_sdcc_floor
defc _f16_floor = cm16_sdcc_floor
ENDIF

