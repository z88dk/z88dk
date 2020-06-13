
	SECTION	code_fp_math16
	PUBLIC	f16_fma_callee
	EXTERN	cm16_sccz80_fma_callee

	defc	f16_fma_callee = cm16_sccz80_fma_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_fma_callee
EXTERN cm16_sdcc_fma_callee
defc _f16_fma_callee = cm16_sdcc_fma_callee
ENDIF

