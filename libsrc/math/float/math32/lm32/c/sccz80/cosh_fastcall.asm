
	SECTION	code_fp_math32
	PUBLIC	cosh_fastcall
	EXTERN	_m32_coshf

	defc	cosh_fastcall = _m32_coshf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cosh_fastcall
defc _cosh_fastcall = _m32_coshf
ENDIF

