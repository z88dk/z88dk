
	SECTION	code_fp_am9511
	PUBLIC	cosh
	EXTERN	_am9511_cosh

	defc	cosh = _am9511_cosh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cosh
EXTERN cam32_sdcc_dcc_cosh
defc _cosh = cam32_sdcc_dcc_cosh
ENDIF

