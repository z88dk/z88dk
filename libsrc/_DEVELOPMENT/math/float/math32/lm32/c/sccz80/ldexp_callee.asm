
	SECTION	code_fp_math32
	PUBLIC	ldexp_callee
	EXTERN	cm32_sccz80_ldexp_callee

	defc	ldexp_callee = cm32_sccz80_ldexp_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ldexp_callee
EXTERN	cm32_sdcc_ldexp_callee
defc _ldexp_callee = cm32_sdcc_ldexp_callee
ENDIF

