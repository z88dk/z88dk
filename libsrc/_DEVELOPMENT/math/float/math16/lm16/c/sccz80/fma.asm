
	SECTION	code_fp_math16
	PUBLIC	f16_fma
	EXTERN	cm16_sccz80_fma

	defc	f16_fma = cm16_sccz80_fma


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_fma
EXTERN cm16_sdcc_fma
defc _f16_fma = cm16_sdcc_fma
ENDIF

