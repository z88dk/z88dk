
	SECTION	code_fp_math32
	PUBLIC	tanh_fastcall
	EXTERN	_m32_tanhf

	defc	tanh_fastcall = _m32_tanhf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tanh_fastcall
defc _tanh_fastcall = _m32_tanhf
ENDIF

