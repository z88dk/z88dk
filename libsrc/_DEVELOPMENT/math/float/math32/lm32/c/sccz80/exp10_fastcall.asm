
	SECTION	code_fp_math32
	PUBLIC	exp10_fastcall
	EXTERN	_m32_exp10f

	defc	exp10_fastcall = _m32_exp10f

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp10_fastcall
defc _exp10_fastcall = _m32_exp10f
ENDIF

