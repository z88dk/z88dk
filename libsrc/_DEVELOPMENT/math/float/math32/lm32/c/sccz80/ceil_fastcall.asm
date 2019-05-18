
	SECTION	code_fp_math32
	PUBLIC	ceil_fastcall
	EXTERN	_m32_ceil_fastcall

	defc	ceil_fastcall = _m32_ceil_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ceil_fastcall
defc _ceil_fastcall = ceil_fastcall
ENDIF

