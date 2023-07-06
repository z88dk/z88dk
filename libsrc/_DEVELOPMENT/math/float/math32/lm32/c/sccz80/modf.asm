
	SECTION	code_fp_math32
	PUBLIC	modf
	EXTERN	cm32_sccz80_modf

	defc	modf = cm32_sccz80_modf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _modf
defc _modf = modf
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___modf
defc ___modf = modf
ENDIF

