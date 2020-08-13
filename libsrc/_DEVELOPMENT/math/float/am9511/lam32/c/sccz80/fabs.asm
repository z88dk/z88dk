
	SECTION	code_fp_am9511
	PUBLIC	fabs
	EXTERN	cam32_sccz80_fabs

	defc	fabs = cam32_sccz80_fabs

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fabs
EXTERN cam32_sdcc_fabs
defc _fabs = cam32_sdcc_fabs
ENDIF

