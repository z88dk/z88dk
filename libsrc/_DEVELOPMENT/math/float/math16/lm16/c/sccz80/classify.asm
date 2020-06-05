
	SECTION	code_fp_math16
	PUBLIC	classify
	EXTERN	cm16_sccz80_classify

	defc	classify = cm16_sccz80_classify


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _classify
EXTERN  cm16_sdcc_classify
defc _classify = cm16_sdcc_classify
ENDIF

