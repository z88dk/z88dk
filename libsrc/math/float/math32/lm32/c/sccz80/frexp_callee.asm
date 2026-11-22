
	SECTION	code_fp_math32
	PUBLIC	frexp_callee
	EXTERN	cm32_sccz80_frexp_callee

	defc	frexp_callee = cm32_sccz80_frexp_callee

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _frexp_callee
	defc _frexp_callee = frexp_callee

