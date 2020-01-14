
	SECTION	code_fp_math32
	PUBLIC	fmax
	EXTERN	cm32_sccz80_fmax

	defc	fmax = cm32_sccz80_fmax

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fmax
EXTERN	cm32_sdcc_fmax
defc _fmax = cm32_sdcc_fmax
ENDIF

