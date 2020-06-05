
	SECTION	code_fp_math16
	PUBLIC	mul10
	EXTERN	cm16_sccz80_mul10

	defc	mul10 = cm16_sccz80_mul10


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul10
EXTERN cm16_sdcc_mul10
defc _mul10 = cm16_sdcc_mul10
ENDIF

