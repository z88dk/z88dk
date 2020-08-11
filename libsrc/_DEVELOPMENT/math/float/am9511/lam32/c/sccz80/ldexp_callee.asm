
	SECTION	code_fp_am9511
	PUBLIC	ldexp_callee
	EXTERN	cam32_sccz80_ldexp_callee

	defc	ldexp_callee = cam32_sccz80_ldexp_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ldexp_callee
EXTERN	cam32_sdcc_ldexp_callee
defc _ldexp_callee = cam32_sdcc_ldexp_callee
ENDIF

