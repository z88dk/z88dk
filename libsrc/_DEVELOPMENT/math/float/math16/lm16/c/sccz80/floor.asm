
	SECTION	code_fp_math16
	PUBLIC	floor
	EXTERN	cm16_sccz80_floor

	defc	floor = cm16_sccz80_floor


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _floor
EXTERN cm16_sdcc_floor
defc _floor = cm16_sdcc_floor
ENDIF

