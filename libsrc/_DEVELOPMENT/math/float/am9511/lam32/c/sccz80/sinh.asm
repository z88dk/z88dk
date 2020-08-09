
	SECTION	code_fp_am9511
	PUBLIC	sinh
	EXTERN	_am9511_sinh

	defc	sinh = _am9511_sinh

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sinh
EXTERN cam32_sdcc_sinh
defc _sinh = cam32_sdcc_sinh
ENDIF

