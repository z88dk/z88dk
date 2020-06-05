
	SECTION	code_fp_math16
	PUBLIC	ldexp
	EXTERN	cm16_sccz80_ldexp

	defc	ldexp = cm16_sccz80_ldexp


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ldexp
EXTERN cm16_sdcc_ldexp
defc _ldexp = cm16_sdcc_ldexp
ENDIF

