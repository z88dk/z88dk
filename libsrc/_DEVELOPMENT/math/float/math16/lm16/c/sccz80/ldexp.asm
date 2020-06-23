
	SECTION	code_fp_math16
	PUBLIC	ldexpf16
	EXTERN	cm16_sccz80_ldexp

	defc	ldexpf16 = cm16_sccz80_ldexp


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ldexpf16
EXTERN cm16_sdcc_ldexp
defc _ldexpf16 = cm16_sdcc_ldexp
ENDIF

