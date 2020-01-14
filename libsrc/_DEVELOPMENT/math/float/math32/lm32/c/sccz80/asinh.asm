
	SECTION	code_fp_math32
	PUBLIC	asinh
	EXTERN	_m32_asinhf

	defc	asinh = _m32_asinhf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asinh
EXTERN cm32_sdcc_asinh
defc _asinh = cm32_sdcc_asinh
ENDIF

