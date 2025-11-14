
	SECTION	code_fp_math16
	PUBLIC	powf16_callee
	EXTERN	cm16_sccz80_pow_callee

	defc	powf16_callee = cm16_sccz80_pow_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _powf16_callee
defc _powf16_callee = powf16_callee
ENDIF

