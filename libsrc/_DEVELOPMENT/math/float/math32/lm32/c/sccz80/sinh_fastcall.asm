
	SECTION	code_fp_math32
	PUBLIC	sinh_fastcall
	EXTERN	_m32_sinhf

	defc	sinh_fastcall = _m32_sinhf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sinh_fastcall
defc _sinh_fastcall = _m32_sinhf
ENDIF

