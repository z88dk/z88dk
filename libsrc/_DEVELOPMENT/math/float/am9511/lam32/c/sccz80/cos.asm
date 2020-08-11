
	SECTION	code_fp_am9511
	PUBLIC	cos
	EXTERN	_asm_am9511_cos_fastcall

	defc	cos = _asm_am9511_cos_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cos
EXTERN cam32_sdcc_dcc_cos
defc _cos = cam32_sdcc_dcc_cos
ENDIF

