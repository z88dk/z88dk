
	SECTION	code_fp_math16
	PUBLIC	f16_ldexp
	EXTERN	cm16_sccz80_ldexp

	defc	f16_ldexp = cm16_sccz80_ldexp


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_ldexp
EXTERN cm16_sdcc_ldexp
defc _f16_ldexp = cm16_sdcc_ldexp
ENDIF

