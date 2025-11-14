
	SECTION	code_fp_math32
	PUBLIC	hypot_callee
	EXTERN	cm32_sccz80_fshypot_callee

	defc	hypot_callee = cm32_sccz80_fshypot_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _hypot_callee
defc _hypot_callee = hypot_callee
ENDIF

