
	SECTION	code_fp_math16
	PUBLIC	hypotf16
	EXTERN	cm16_sccz80_hypot

	defc	hypotf16 = cm16_sccz80_hypot


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _hypotf16
EXTERN cm16_sdcc_hypot
defc _hypotf16 = cm16_sdcc_hypot
ENDIF

