
	SECTION	code_fp_math32
	PUBLIC	ceil
	EXTERN	cm32_sccz80_ceil

	defc	ceil = cm32_sccz80_ceil

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ceil
defc _ceil = ceil
ENDIF

