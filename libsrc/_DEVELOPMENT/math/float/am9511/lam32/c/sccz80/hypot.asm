
	SECTION	code_fp_am9511
	PUBLIC	hypot
	EXTERN	cam32_sccz80_hypot

	defc	hypot = cam32_sccz80_hypot


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _hypot
EXTERN	cam32_sdcc_hypot
defc _hypot = cam32_sdcc_hypot
ENDIF

