
	SECTION	code_fp_math32
	PUBLIC	pow
	EXTERN	cm32_sccz80_pow

	defc	pow = cm32_sccz80_pow


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _pow
EXTERN	_m32_powf
defc _pow = _m32_powf
ENDIF

