
	SECTION	code_fp_math16
	PUBLIC	frexp_callee
	EXTERN	cm16_sccz80_frexp_callee

	defc	frexp_callee = cm16_sccz80_frexp_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _frexp_callee
EXTERN cm16_sdcc_frexp_callee
defc _frexp_callee = cm16_sdcc_frexp_callee
ENDIF

