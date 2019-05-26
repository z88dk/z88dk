
	SECTION	code_fp_math32
	PUBLIC	floor
	EXTERN	_m32_floorf

	defc	floor = _m32_floorf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _floor
defc _floor = floor
ENDIF

