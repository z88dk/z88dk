
	SECTION	code_fp_am9511
	PUBLIC	pow_callee
	EXTERN	cam32_sccz80_pow_callee

	defc	pow_callee = cam32_sccz80_pow_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _pow_callee
EXTERN	cam32_sdcc_pow_callee
defc _pow_callee = cam32_sdcc_pow_callee
ENDIF

