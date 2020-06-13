
	SECTION	code_fp_math16
	PUBLIC	f16_frexp
	EXTERN	cm16_sccz80_frexp

	defc	f16_frexp = cm16_sccz80_frexp


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_frexp
EXTERN cm16_sdcc_frexp
defc _f16_frexp = cm16_sdcc_frexp
ENDIF

