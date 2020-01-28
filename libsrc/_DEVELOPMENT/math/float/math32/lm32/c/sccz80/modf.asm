
	SECTION	code_fp_math32
	PUBLIC	modf
	EXTERN	cm32_sccz80_modf

	defc	modf = cm32_sccz80_modf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _modf
EXTERN	_m32_modff
defc _modf = _m32_modff
ENDIF

