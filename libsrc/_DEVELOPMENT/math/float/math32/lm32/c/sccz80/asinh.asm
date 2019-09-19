
	SECTION	code_fp_math32
	PUBLIC	asinh
	EXTERN	cm32_sccz80_asinh

	defc	asinh = cm32_sccz80_asinh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asinh
defc _asinh = asinh
ENDIF

