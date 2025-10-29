
	SECTION	code_fp_am9511
	PUBLIC	asin
	EXTERN	cam32_sccz80_asin

	defc	asin = cam32_sccz80_asin


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asin
defc _asin = cam32_sccz80_asin
ENDIF

