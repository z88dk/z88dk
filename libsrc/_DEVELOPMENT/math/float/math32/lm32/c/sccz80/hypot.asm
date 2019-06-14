
	SECTION	code_fp_math32
	PUBLIC	hypot
	EXTERN	cm32_sccz80_hypot

	defc	hypot = cm32_sccz80_hypot


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _hypot
defc _hypot = hypot
ENDIF

