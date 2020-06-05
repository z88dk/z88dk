
	SECTION	code_fp_math16
	PUBLIC	mul2
	EXTERN	cm16_sccz80_mul2

	defc	mul2 = cm16_sccz80_mul2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul2
EXTERN cm16_sdcc_mul2
defc _mul2 = cm16_sdcc_mul2
ENDIF

