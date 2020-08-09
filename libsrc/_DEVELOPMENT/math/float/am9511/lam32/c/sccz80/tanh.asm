
	SECTION	code_fp_am9511
	PUBLIC	tanh
	EXTERN	_am9511_tanh

	defc	tanh = _am9511_tanh

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tanh
EXTERN cam32_sdcc_tanh
defc _tanh = cam32_sdcc_tanh
ENDIF

