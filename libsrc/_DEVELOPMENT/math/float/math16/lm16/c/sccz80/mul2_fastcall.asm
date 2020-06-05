
	SECTION	code_fp_math16
	PUBLIC	mul2_fastcall
	EXTERN	asm_f16_mul2

	defc	mul2_fastcall = asm_f16_mul2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul2_fastcall
defc _mul2_fastcall = asm_f16_mul2
ENDIF

