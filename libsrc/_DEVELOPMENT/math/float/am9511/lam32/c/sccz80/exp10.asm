
	SECTION	code_fp_am9511
	PUBLIC	exp10
	EXTERN	_am9511_exp10_fastcall

	defc	exp10 = _am9511_exp10_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp10
EXTERN cam32_sdcc_exp10
defc _exp10 = cam32_sdcc_exp10
ENDIF
