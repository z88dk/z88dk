
	SECTION	code_fp_am9511
	PUBLIC	mul2
	EXTERN	cam32_sccz80_fmul2

	defc	mul2 = cam32_sccz80_fmul2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul2
defc _mul2 = cam32_sccz80_fmul2
ENDIF

