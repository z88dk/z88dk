
	SECTION	code_fp_math32
	PUBLIC	atan2
	EXTERN	cm32_sccz80_atan2

	defc	atan2 = cm32_sccz80_atan2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atan2
EXTERN _m32_atan2f
defc _atan2 = _m32_atan2f
ENDIF

