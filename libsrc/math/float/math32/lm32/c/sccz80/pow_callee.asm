
	SECTION	code_fp_math32
	PUBLIC	pow_callee
	EXTERN	cm32_sccz80_pow_callee

	defc	pow_callee = cm32_sccz80_pow_callee

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _pow_callee
	defc _pow_callee = pow_callee

