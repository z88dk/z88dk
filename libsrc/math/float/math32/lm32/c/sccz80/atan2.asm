
	SECTION	code_fp_math32
	PUBLIC	atan2
	EXTERN	cm32_sccz80_atan2

	defc	atan2 = cm32_sccz80_atan2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atan2
defc _atan2 = atan2
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___atan2
defc ___atan2 = atan2
ENDIF
