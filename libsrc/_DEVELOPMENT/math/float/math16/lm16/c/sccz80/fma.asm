
	SECTION	code_fp_math16
	PUBLIC	m16_fma
	EXTERN	cm16_sccz80_fma

	defc	m16_fma = cm16_sccz80_fma


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_fma
EXTERN cm16_sdcc_fma
defc _m16_fma = cm16_sdcc_fma
ENDIF

