
	SECTION	code_fp_math16
	PUBLIC	polyf16
	EXTERN	cm16_sccz80_poly

	defc	polyf16 = cm16_sccz80_poly


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _polyf16
EXTERN cm16_sdcc_poly
defc _polyf16 = cm16_sdcc_poly
ENDIF

