
	SECTION	code_fp_math16
	PUBLIC	div2_fastcall
	EXTERN	asm_f16_div2

	defc	div2_fastcall = asm_f16_div2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _div2_fastcall
defc _div2_fastcall = asm_f16_div2
ENDIF

