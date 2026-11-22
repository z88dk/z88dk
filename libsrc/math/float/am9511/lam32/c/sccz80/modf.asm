
	SECTION	code_fp_am9511
	PUBLIC	modf
	EXTERN	cam32_sccz80_modf

	defc	modf = cam32_sccz80_modf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _modf
EXTERN	_am9511_modf
defc _modf = _am9511_modf
ENDIF

