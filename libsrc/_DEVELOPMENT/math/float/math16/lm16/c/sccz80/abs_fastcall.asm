
	SECTION	code_fp_math16
	PUBLIC	m16_abs_fastcall
	EXTERN	asm_f16_abs

	defc	m16_abs_fastcall = asm_f16_abs


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_abs_fastcall
defc _m16_abs_fastcall = asm_f16_abs
ENDIF

