
	SECTION	code_fp_math16
	PUBLIC	m16_div2_fastcall
	EXTERN	asm_f16_div2

	defc	m16_div2_fastcall = asm_f16_div2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_div2_fastcall
defc _m16_div2_fastcall = asm_f16_div2
ENDIF

