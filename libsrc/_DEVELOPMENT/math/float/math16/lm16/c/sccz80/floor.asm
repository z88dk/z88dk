
	SECTION	code_fp_math16
	PUBLIC	m16_floor
	EXTERN	cm16_sccz80_floor

	defc	m16_floor = cm16_sccz80_floor


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_floor
EXTERN cm16_sdcc_floor
defc _m16_floor = cm16_sdcc_floor
ENDIF

