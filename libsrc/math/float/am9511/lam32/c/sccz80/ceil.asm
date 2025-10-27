
	SECTION	code_fp_am9511
	PUBLIC	ceil
	EXTERN	cam32_sccz80_ceil

	defc	ceil = cam32_sccz80_ceil

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ceil
defc _ceil = cam32_sccz80_ceil
ENDIF

