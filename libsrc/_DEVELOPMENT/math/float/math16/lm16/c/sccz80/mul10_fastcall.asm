
	SECTION	code_fp_math16
	PUBLIC	mul10_fastcall
	EXTERN	asm_f16_mul10

	defc	mul10_fastcall = asm_f16_mul10


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul10_fastcall
defc _mul10_fastcall = asm_f16_mul10
ENDIF

