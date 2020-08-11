
	SECTION	code_fp_am9511
	PUBLIC	atanh
	EXTERN	_am9511_atanh

	defc	atanh = _am9511_atanh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atanh
EXTERN cam32_sdcc_atanh
defc _atanh = cam32_sdcc_atanh
ENDIF

