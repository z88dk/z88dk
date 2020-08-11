
	SECTION	code_fp_am9511
	PUBLIC	exp2
	EXTERN	_am9511_exp2

	defc	exp2 = _am9511_exp2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp2
EXTERN cam32_sdcc_exp2
defc _exp2 = cam32_sdcc_exp2
ENDIF
