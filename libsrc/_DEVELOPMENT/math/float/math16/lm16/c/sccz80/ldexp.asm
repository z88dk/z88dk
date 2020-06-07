
	SECTION	code_fp_math16
	PUBLIC	m16_ldexp
	EXTERN	cm16_sccz80_ldexp

	defc	m16_ldexp = cm16_sccz80_ldexp


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_ldexp
EXTERN cm16_sdcc_ldexp
defc _m16_ldexp = cm16_sdcc_ldexp
ENDIF

