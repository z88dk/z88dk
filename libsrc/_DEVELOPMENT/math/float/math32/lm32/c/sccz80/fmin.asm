
	SECTION	code_fp_math32
	PUBLIC	fmin
	EXTERN	cm32_sccz80_fmin

	defc	fmin = cm32_sccz80_fmin

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fmin
defc _fmin = fmin
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___fmin
defc ___fmin = fmin
ENDIF

