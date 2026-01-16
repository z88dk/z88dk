
	SECTION	code_fp_am9511
	PUBLIC	mul10u
	EXTERN	cam32_sccz80_fmul10u

	defc	mul10u = cam32_sccz80_fmul10u

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul10u
defc _mul10u = cam32_sccz80_fmul10u
ENDIF

