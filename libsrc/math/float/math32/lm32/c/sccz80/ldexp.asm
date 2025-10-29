
	SECTION	code_fp_math32
	PUBLIC	ldexp
	EXTERN	cm32_sccz80_ldexp

	defc	ldexp = cm32_sccz80_ldexp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ldexp
defc _ldexp = ldexp
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___ldexp
defc ___ldexp = ldexp
ENDIF

