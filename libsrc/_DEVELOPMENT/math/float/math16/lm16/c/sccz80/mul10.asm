
	SECTION	code_fp_math16
	PUBLIC	m16_mul10
	EXTERN	cm16_sccz80_mul10

	defc	m16_mul10 = cm16_sccz80_mul10


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_mul10
EXTERN cm16_sdcc_mul10
defc _m16_mul10 = cm16_sdcc_mul10
ENDIF

