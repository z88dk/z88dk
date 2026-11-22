
	SECTION	code_fp_am9511
	PUBLIC	acosh
	EXTERN	cam32_sccz80_acosh

	defc	acosh = cam32_sccz80_acosh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acosh
defc _acosh = cam32_sccz80_acosh
ENDIF

