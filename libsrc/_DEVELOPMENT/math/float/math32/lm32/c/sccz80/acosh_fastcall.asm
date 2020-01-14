
	SECTION	code_fp_math32
	PUBLIC	acosh_fastcall
	EXTERN	_m32_acoshf

	defc	acosh_fastcall = _m32_acoshf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acosh_fastcall
defc _acosh_fastcall = _m32_acoshf
ENDIF

