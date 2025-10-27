
	SECTION	code_fp_am9511
	PUBLIC	exp10
	EXTERN	cam32_sccz80_exp10

	defc	exp10 = cam32_sccz80_exp10


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp10
defc _exp10 = cam32_sccz80_exp10
ENDIF
