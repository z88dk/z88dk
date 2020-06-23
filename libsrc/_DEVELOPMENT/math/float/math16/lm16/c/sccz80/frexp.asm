
	SECTION	code_fp_math16
	PUBLIC	frexpf16
	EXTERN	cm16_sccz80_frexp

	defc	frexpf16 = cm16_sccz80_frexp


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _frexpf16
EXTERN cm16_sdcc_frexp
defc _frexpf16 = cm16_sdcc_frexp
ENDIF

