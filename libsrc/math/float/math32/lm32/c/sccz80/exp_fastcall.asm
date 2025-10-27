
	SECTION	code_fp_math32
	PUBLIC	exp_fastcall
	EXTERN	_m32_expf

	defc	exp_fastcall = _m32_expf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp_fastcall
defc _exp_fastcall = _m32_expf
ENDIF

