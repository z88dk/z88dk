
	SECTION	code_fp_am9511
	PUBLIC	atanh
	EXTERN	cam32_sccz80_atanh

	defc	atanh = cam32_sccz80_atanh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atanh
defc _atanh = cam32_sccz80_atanh
ENDIF

