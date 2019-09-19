
	SECTION	code_fp_math32
	PUBLIC	floor
	EXTERN	cm32_sccz80_floor

	defc	floor = cm32_sccz80_floor

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _floor
defc _floor = floor
ENDIF

