
	SECTION	code_fp_am9511
	PUBLIC	asinh
	EXTERN	_am9511_asinh

	defc	asinh = _am9511_asinh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asinh
EXTERN cam32_sdcc_asinh
defc _asinh = cam32_sdcc_asinh
ENDIF

