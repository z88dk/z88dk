
	SECTION	code_fp_math16
	PUBLIC	ceilf16
	EXTERN	asm_f16_ceil

	defc	ceilf16 = asm_f16_ceil


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ceilf16
defc _ceilf16 = ceilf16
ENDIF

