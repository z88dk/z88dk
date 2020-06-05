
	SECTION	code_fp_math16
	PUBLIC	abs_fastcall
	EXTERN	asm_f16_abs

	defc	abs_fastcall = asm_f16_abs


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _abs_fastcall
defc _abs_fastcall = asm_f16_abs
ENDIF

