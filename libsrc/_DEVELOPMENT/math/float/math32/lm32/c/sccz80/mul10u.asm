
	SECTION	code_fp_math32
	PUBLIC	mul10u
	EXTERN	cm32_sccz80_fsmul10u

	defc	mul10u = cm32_sccz80_fsmul10u

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul10u
defc _mul10u = mul10u
ENDIF

