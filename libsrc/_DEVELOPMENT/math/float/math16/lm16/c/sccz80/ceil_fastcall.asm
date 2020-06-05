
	SECTION	code_fp_math16
	PUBLIC	m16_ceil_fastcall
	EXTERN	asm_f16_ceil

	defc	m16_ceil_fastcall = asm_f16_ceil


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_ceil_fastcall
defc _m16_ceil_fastcall = asm_f16_ceil
ENDIF

