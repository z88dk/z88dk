
	SECTION	code_fp_math32
	PUBLIC	hypot
	EXTERN	cm32_sccz80_fshypot

	defc	hypot = cm32_sccz80_fshypot

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _hypot
defc _hypot = hypot
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___hypot
defc ___hypot = hypot
ENDIF
