
	SECTION	code_fp_math32
	PUBLIC	frexp_callee
	EXTERN	cm32_sccz80_frexp_callee

	defc	frexp_callee = cm32_sccz80_frexp_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _frexp_callee
defc _frexp_callee = frexp_callee
ENDIF

