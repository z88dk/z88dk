
	SECTION	code_fp_math16
	PUBLIC	m16_mul10_fastcall
	EXTERN	asm_f16_mul10

	defc	m16_mul10_fastcall = asm_f16_mul10


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_mul10_fastcall
defc _m16_mul10_fastcall = asm_f16_mul10
ENDIF

