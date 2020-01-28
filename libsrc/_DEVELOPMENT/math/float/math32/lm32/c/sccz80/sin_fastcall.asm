
	SECTION	code_fp_math32
	PUBLIC	sin_fastcall
	EXTERN	_m32_sinf

	defc	sin_fastcall = _m32_sinf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sin_fastcall
defc _sin_fastcall = _m32_sinf
ENDIF

