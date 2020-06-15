
	SECTION	code_fp_math16
	PUBLIC	fmaf16_callee
	EXTERN	cm16_sccz80_fma_callee

	defc	fmaf16_callee = cm16_sccz80_fma_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fmaf16_callee
EXTERN cm16_sdcc_fma_callee
defc _fmaf16_callee = cm16_sdcc_fma_callee
ENDIF

