
	SECTION	code_fp_math32
	PUBLIC	exp2
	EXTERN	cm32_sccz80_exp2

	defc	exp2 = cm32_sccz80_exp2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp2
defc _exp2 = exp2
ENDIF
