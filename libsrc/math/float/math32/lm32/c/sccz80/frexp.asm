
	SECTION	code_fp_math32
	PUBLIC	frexp
	EXTERN	cm32_sccz80_frexp

	defc	frexp = cm32_sccz80_frexp


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _frexp
defc _frexp = frexp
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___frexp
defc ___frexp = frexp
ENDIF
