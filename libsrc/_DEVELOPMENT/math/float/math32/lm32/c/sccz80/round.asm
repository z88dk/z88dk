
	SECTION	code_fp_math32
	PUBLIC	round
	EXTERN	cm32_sccz80_round

	defc	round = cm32_sccz80_round

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _round
EXTERN	cm32_sdcc_round
defc _round = cm32_sdcc_round
ENDIF

