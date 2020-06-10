
	SECTION	code_fp_math16
	PUBLIC	f16_frexp_callee
	EXTERN	cm16_sccz80_frexp_callee

	defc	f16_frexp_callee = cm16_sccz80_frexp_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_frexp_callee
EXTERN cm16_sdcc_frexp_callee
defc _f16_frexp_callee = cm16_sdcc_frexp_callee
ENDIF

