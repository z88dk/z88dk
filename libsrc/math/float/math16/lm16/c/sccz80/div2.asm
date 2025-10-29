
	SECTION	code_fp_math16
	PUBLIC	div2f16
	EXTERN	asm_f16_div2

	defc	div2f16 = asm_f16_div2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _div2f16
defc _div2f16 = div2f16
ENDIF

