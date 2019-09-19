
	SECTION	code_fp_math32
	PUBLIC	atanh
	EXTERN	cm32_sccz80_atanh

	defc	atanh = cm32_sccz80_atanh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atanh
defc _atanh = atanh
ENDIF

