
	SECTION	code_fp_math32
	PUBLIC	hypot
	EXTERN	cm32_sccz80_fshypot

	defc	hypot = cm32_sccz80_fshypot


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _hypot
EXTERN	cm32_sdcc_fshypot
defc _hypot = cm32_sdcc_fshypot
ENDIF

