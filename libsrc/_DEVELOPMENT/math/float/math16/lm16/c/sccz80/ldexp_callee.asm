
	SECTION	code_fp_math16
	PUBLIC	ldexp_callee
	EXTERN	cm16_sccz80_ldexp_callee

	defc	ldexp_callee = cm16_sccz80_ldexp_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ldexp_callee
EXTERN	cm16_sdcc_ldexp_callee
defc _ldexp_callee = cm16_sdcc_ldexp_callee
ENDIF

