
	SECTION	code_fp_math32
	PUBLIC	mul2
	EXTERN	cm32_sccz80_fsmul2

	defc	mul2 = cm32_sccz80_fsmul2

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul2
defc _mul2 = mul2
ENDIF

