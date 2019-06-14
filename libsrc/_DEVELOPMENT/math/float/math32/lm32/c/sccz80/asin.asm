
	SECTION	code_fp_math32
	PUBLIC	asin
	EXTERN	cm32_sccz80_asin

	defc	asin = cm32_sccz80_asin


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asin
defc _asin = asin
ENDIF

