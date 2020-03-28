
	SECTION	code_fp_math32
	PUBLIC	asinh_fastcall
	EXTERN	_m32_asinhf

	defc	asinh_fastcall = _m32_asinhf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asinh_fastcall
defc _asinh_fastcall = _m32_asinhf
ENDIF

