
	SECTION	code_fp_am9511
	PUBLIC	atan2
	EXTERN	cam32_sccz80_atan2

	defc	atan2 = cam32_sccz80_atan2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atan2
EXTERN _am9511_atan2
defc _atan2 = _am9511_atan2
ENDIF

