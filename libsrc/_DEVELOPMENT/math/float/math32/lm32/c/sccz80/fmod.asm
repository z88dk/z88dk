
	SECTION	code_fp_math32
	PUBLIC	fmod
	EXTERN	cm32_sccz80_fmod

	defc	fmod = cm32_sccz80_fmod


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fmod
EXTERN cm32_sdcc_fmod
defc _fmod = cm32_sdcc_fmod
ENDIF

