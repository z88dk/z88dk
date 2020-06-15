
	SECTION	code_fp_math16
	PUBLIC	frexpf16_callee
	EXTERN	cm16_sccz80_frexp_callee

	defc	frexpf16_callee = cm16_sccz80_frexp_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _frexpf16_callee
EXTERN cm16_sdcc_frexp_callee
defc _frexpf16_callee = cm16_sdcc_frexp_callee
ENDIF

