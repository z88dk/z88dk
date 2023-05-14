
	SECTION	code_fp_math32
	PUBLIC	poly
	EXTERN	cm32_sccz80_fspoly

	defc	poly = cm32_sccz80_fspoly


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _poly
defc _poly = poly
ENDIF

