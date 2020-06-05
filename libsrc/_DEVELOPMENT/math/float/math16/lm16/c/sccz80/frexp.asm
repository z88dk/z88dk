
	SECTION	code_fp_math16
	PUBLIC	m16_frexp
	EXTERN	cm16_sccz80_frexp

	defc	m16_frexp = cm16_sccz80_frexp


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_frexp
EXTERN cm16_sdcc_frexp
defc _m16_frexp = cm16_sdcc_frexp
ENDIF

