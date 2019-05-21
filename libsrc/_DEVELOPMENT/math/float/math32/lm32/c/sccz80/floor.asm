
	SECTION	code_fp_math32
	PUBLIC	floor
	EXTERN	_m32_floor

	defc	floor = _m32_floor

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _floor
defc _floor = floor
ENDIF

