
	SECTION	code_fp_math32
	PUBLIC	fmin
	EXTERN	cm32_sccz80_fmin

	defc	fmin = cm32_sccz80_fmin

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fmin
EXTERN cm32_sdcc_fmin
defc _fmin = cm32_sdcc_fmin
ENDIF

