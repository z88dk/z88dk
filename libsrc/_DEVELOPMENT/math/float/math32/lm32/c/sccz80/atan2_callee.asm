
	SECTION	code_fp_math32
	PUBLIC	pow_callee
	EXTERN	cm32_sccz80_atan2_callee

	defc	pow_callee = cm32_sccz80_atan2_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atan2_callee
defc _atan2_callee = pow_callee
ENDIF

