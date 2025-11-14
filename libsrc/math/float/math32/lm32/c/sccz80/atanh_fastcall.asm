
	SECTION	code_fp_math32
	PUBLIC	atanh_fastcall
	EXTERN	_m32_atanhf

	defc	atanh_fastcall = _m32_atanhf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atanh_fastcall
defc _atanh_fastcall = _m32_atanhf
ENDIF

