
	SECTION	code_fp_math32
	PUBLIC	tanh
	EXTERN	_m32_tanhf

	defc	tanh = _m32_tanhf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tanh
defc _tanh = _m32_tanhf
ENDIF

