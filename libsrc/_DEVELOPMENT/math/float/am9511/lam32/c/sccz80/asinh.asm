
	SECTION	code_fp_am9511
	PUBLIC	asinh
	EXTERN	cam32_sccz80_asinh

	defc	asinh = cam32_sccz80_asinh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asinh
EXTERN cam32_sdcc_asinh
defc _asinh = cam32_sdcc_asinh
ENDIF

