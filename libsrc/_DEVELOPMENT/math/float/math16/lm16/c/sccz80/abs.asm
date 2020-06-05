
	SECTION	code_fp_math16
	PUBLIC	abs
	EXTERN	cm16_sccz80_abs

	defc	abs = cm16_sccz80_abs


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _abs
EXTERN cm16_sdcc_abs
defc _abs = cm16_sdcc_abs
ENDIF

