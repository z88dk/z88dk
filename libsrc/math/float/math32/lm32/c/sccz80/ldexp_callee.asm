
	SECTION	code_fp_math32
	PUBLIC	ldexp_callee
	EXTERN	cm32_sccz80_ldexp_callee

	defc	ldexp_callee = cm32_sccz80_ldexp_callee

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _ldexp_callee
	defc _ldexp_callee = ldexp_callee

