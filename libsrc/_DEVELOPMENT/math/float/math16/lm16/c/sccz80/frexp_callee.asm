
	SECTION	code_fp_math16
	PUBLIC	m16_frexp_callee
	EXTERN	cm16_sccz80_frexp_callee

	defc	m16_frexp_callee = cm16_sccz80_frexp_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_frexp_callee
EXTERN cm16_sdcc_frexp_callee
defc _m16_frexp_callee = cm16_sdcc_frexp_callee
ENDIF

