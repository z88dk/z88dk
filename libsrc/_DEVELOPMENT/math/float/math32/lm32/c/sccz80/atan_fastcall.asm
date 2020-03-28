
	SECTION	code_fp_math32
	PUBLIC	atan_fastcall
	EXTERN	_m32_atanf

	defc	atan_fastcall = _m32_atanf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atan_fastcall
defc _atan_fastcall = _m32_atanf
ENDIF

