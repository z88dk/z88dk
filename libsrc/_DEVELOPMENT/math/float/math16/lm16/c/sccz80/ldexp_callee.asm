
	SECTION	code_fp_math16
	PUBLIC	m16_ldexp_callee
	EXTERN	cm16_sccz80_ldexp_callee

	defc	m16_ldexp_callee = cm16_sccz80_ldexp_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_ldexp_callee
EXTERN	cm16_sdcc_ldexp_callee
defc _m16_ldexp_callee = cm16_sdcc_ldexp_callee
ENDIF

