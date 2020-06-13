
	SECTION	code_fp_math16
	PUBLIC	f16_div2
	EXTERN	asm_f16_div2

	defc	f16_div2 = asm_f16_div2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_div2
EXTERN	cm16_sdcc_div2
defc _f16_div2 = cm16_sdcc_div2
ENDIF

