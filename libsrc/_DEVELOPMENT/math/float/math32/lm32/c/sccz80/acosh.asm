
	SECTION	code_fp_math32
	PUBLIC	acosh
	EXTERN	cm32_sccz80_acosh

	defc	acosh = cm32_sccz80_acosh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acosh
defc _acosh = acosh
ENDIF

