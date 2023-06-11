
	SECTION	code_fp_math16
	PUBLIC	frexpf16
	EXTERN	cm16_sccz80_frexp

	defc	frexpf16 = cm16_sccz80_frexp


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _frexpf16
defc _frexpf16 = frexpf16
ENDIF

