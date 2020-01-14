
	SECTION	code_fp_math32
	PUBLIC	poly
	EXTERN	cm32_sccz80_fspoly

	defc	poly = cm32_sccz80_fspoly


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _poly
EXTERN	cm32_sdcc_fspoly
defc _poly = cm32_sdcc_fspoly
ENDIF

