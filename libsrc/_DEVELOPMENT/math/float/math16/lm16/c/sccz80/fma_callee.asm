
	SECTION	code_fp_math16
	PUBLIC	m16_fma_callee
	EXTERN	cm16_sccz80_fma_callee

	defc	m16_fma_callee = cm16_sccz80_fma_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_fma_callee
EXTERN cm16_sdcc_fma_callee
defc _m16_fma_callee = cm16_sdcc_fma_callee
ENDIF

