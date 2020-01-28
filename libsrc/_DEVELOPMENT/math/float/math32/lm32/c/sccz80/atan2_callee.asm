
	SECTION	code_fp_math32
	PUBLIC	atan2_callee
	EXTERN	cm32_sccz80_atan2_callee

	defc	atan2_callee = cm32_sccz80_atan2_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atan2_callee
EXTERN cm32_sdcc_atan2_callee
defc _atan2_callee = cm32_sdcc_atan2_callee
ENDIF

