
	SECTION	code_fp_math32
	PUBLIC	cos_fastcall
	EXTERN	_m32_cosf

	defc	cos_fastcall = _m32_cosf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cos_fastcall
defc _cos_fastcall = _m32_cosf
ENDIF

