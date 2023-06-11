
	SECTION	code_fp_math16
	PUBLIC	polyf16_callee
	EXTERN	cm16_sccz80_poly_callee

	defc	polyf16_callee = cm16_sccz80_poly_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _polyf16_callee
defc _polyf16_callee = polyf16_callee
ENDIF

