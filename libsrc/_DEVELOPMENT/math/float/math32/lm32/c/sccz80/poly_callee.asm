
	SECTION	code_fp_math32
	PUBLIC	poly_callee
	EXTERN	cm32_sccz80_fspoly_callee

	defc	poly_callee = cm32_sccz80_fspoly_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _poly_callee
EXTERN	cm32_sdcc_fspoly_callee
defc _poly_callee = cm32_sdcc_fspoly_callee
ENDIF

