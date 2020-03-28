
	SECTION	code_fp_math32
	PUBLIC	acos_fastcall
	EXTERN	_m32_acosf

	defc	acos_fastcall = _m32_acosf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acos_fastcall
defc _acos_fastcall = _m32_acosf
ENDIF

