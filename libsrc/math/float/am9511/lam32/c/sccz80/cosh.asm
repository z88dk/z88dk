
	SECTION	code_fp_am9511
	PUBLIC	cosh
	EXTERN	cam32_sccz80_cosh

	defc	cosh = cam32_sccz80_cosh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cosh
defc _cosh = cam32_sccz80_cosh
ENDIF

