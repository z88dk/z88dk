
	SECTION	code_fp_am9511
	PUBLIC	frexp_callee
	EXTERN	cam32_sccz80_frexp_callee

	defc	frexp_callee = cam32_sccz80_frexp_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _frexp_callee
EXTERN cam32_sdcc_frexp_callee
defc _frexp_callee = cam32_sdcc_frexp_callee
ENDIF

