
	SECTION	code_fp_math16
	PUBLIC	pow_callee
	EXTERN	cm16_sccz80_pow_callee

	defc	pow_callee = cm16_sccz80_pow_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _pow_callee
EXTERN	cm16_sdcc_pow_callee
defc _pow_callee = cm16_sdcc_pow_callee
ENDIF

