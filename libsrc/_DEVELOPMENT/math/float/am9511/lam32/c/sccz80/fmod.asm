
	SECTION	code_fp_am9511
	PUBLIC	fmod
	EXTERN	cam32_sccz80_fmod

	defc	fmod = cam32_sccz80_fmod


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fmod
defc _fmod = fmod
ENDIF

