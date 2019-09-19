
	SECTION	code_fp_math32
	PUBLIC	exp
	EXTERN	cm32_sccz80_exp

	defc	exp = cm32_sccz80_exp


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp
defc _exp = exp
ENDIF

