
	SECTION	code_fp_math16
	PUBLIC	ldexpf16_callee
	EXTERN	cm16_sccz80_ldexp_callee

	defc	ldexpf16_callee = cm16_sccz80_ldexp_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ldexpf16_callee
defc _ldexpf16_callee = ldexpf16_callee
ENDIF

