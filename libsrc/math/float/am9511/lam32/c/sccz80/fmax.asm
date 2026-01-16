
	SECTION	code_fp_am9511
	PUBLIC	fmax
	EXTERN	cam32_sccz80_fmax

	defc	fmax = cam32_sccz80_fmax

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fmax
defc _fmax = fmax
ENDIF

