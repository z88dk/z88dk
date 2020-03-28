
	SECTION	code_fp_math32
	PUBLIC	pow_callee
	EXTERN	cm32_sccz80_pow_callee

	defc	pow_callee = cm32_sccz80_pow_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _pow_callee
EXTERN	cm32_sdcc_pow_callee
defc _pow_callee = cm32_sdcc_pow_callee
ENDIF

