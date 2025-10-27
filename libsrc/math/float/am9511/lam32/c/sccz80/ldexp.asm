
	SECTION	code_fp_am9511
	PUBLIC	ldexp
	EXTERN	cam32_sccz80_ldexp

	defc	ldexp = cam32_sccz80_ldexp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ldexp
defc _ldexp = ldexp
ENDIF

