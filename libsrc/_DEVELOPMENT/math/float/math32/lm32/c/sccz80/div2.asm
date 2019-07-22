	SECTION	code_fp_math32
	PUBLIC	acos
	EXTERN	cm32_sccz80_fsdiv2

	defc	div2 = cm32_sccz80_fsdiv2

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _div2
defc _div2 = div2
ENDIF

