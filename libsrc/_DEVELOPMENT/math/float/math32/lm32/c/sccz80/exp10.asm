
	SECTION	code_fp_math32
	PUBLIC	exp10
	EXTERN	cm32_sccz80_exp10

	defc	exp10 = cm32_sccz80_exp10


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp10
defc _exp10 = exp10
ENDIF
