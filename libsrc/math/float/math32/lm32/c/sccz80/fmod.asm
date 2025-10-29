
	SECTION	code_fp_math32
	PUBLIC	fmod
	EXTERN	cm32_sccz80_fmod

	defc	fmod = cm32_sccz80_fmod


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fmod
defc _fmod = fmod
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___fmod
defc ___fmod = fmod
ENDIF

