
	SECTION	code_fp_math32
	PUBLIC	cos
	EXTERN	cm32_sccz80_cos

	defc	cos = cm32_sccz80_cos


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cos
defc _cos = cos
ENDIF

