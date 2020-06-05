
	SECTION	code_fp_math16
	PUBLIC	m16_mul2_fastcall
	EXTERN	asm_f16_mul2

	defc	m16_mul2_fastcall = asm_f16_mul2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_mul2_fastcall
defc _m16_mul2_fastcall = asm_f16_mul2
ENDIF

