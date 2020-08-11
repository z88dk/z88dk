
	SECTION	code_fp_am9511
	PUBLIC	acosh
	EXTERN	_am9511_acosh

	defc	acosh = _am9511_acosh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acosh
EXTERN cam32_sdcc_acosh
defc _acosh = cam32_sdcc_acosh
ENDIF

