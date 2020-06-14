
	SECTION	code_fp_math16
	PUBLIC	f16_hypot
	EXTERN	cm16_sccz80_hypot

	defc	f16_hypot = cm16_sccz80_hypot


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_hypot
EXTERN cm16_sdcc_hypot
defc _f16_hypot = cm16_sdcc_hypot
ENDIF

