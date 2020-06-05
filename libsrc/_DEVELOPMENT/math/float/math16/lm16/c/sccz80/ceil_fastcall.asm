
	SECTION	code_fp_math16
	PUBLIC	ceil_fastcall
	EXTERN	asm_f16_ceil

	defc	ceil_fastcall = asm_f16_ceil


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ceil_fastcall
defc _ceil_fastcall = asm_f16_ceil
ENDIF

