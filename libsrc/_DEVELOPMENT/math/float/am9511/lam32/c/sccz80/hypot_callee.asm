
	SECTION	code_fp_am9511
	PUBLIC	hypot_callee
	EXTERN	cam32_sccz80_hypot_callee

	defc	hypot_callee = cam32_sccz80_hypot_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _hypot_callee
EXTERN	cam32_sdcc_hypot_callee
defc _hypot_callee = cam32_sdcc_hypot_callee
ENDIF

