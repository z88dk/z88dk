
	SECTION	code_fp_math16
	PUBLIC	frexp
	EXTERN	cm16_sccz80_frexp

	defc	frexp = cm16_sccz80_frexp


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _frexp
EXTERN cm16_sdcc_frexp
defc _frexp = cm16_sdcc_frexp
ENDIF

