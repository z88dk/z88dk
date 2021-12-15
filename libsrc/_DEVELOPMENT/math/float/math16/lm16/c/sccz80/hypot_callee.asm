
	SECTION	code_fp_math16
	PUBLIC	hypotf16_callee
	EXTERN	cm16_sccz80_hypot_callee

	defc	hypotf16_callee = cm16_sccz80_hypot_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _hypotf16_callee
defc _hypotf16_callee = hypotf16_callee
ENDIF

