
	SECTION	code_fp_math16
	PUBLIC	f16_ldexp_callee
	EXTERN	cm16_sccz80_ldexp_callee

	defc	f16_ldexp_callee = cm16_sccz80_ldexp_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_ldexp_callee
EXTERN	cm16_sdcc_ldexp_callee
defc _f16_ldexp_callee = cm16_sdcc_ldexp_callee
ENDIF

