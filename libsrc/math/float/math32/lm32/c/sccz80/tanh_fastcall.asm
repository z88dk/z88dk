
	SECTION	code_fp_math32
	PUBLIC	tanh_fastcall
	EXTERN	_m32_tanhf

	defc	tanh_fastcall = _m32_tanhf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _tanh_fastcall
	defc _tanh_fastcall = _m32_tanhf

