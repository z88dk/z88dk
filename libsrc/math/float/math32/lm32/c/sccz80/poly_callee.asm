
	SECTION	code_fp_math32
	PUBLIC	poly_callee
	EXTERN	cm32_sccz80_fspoly_callee

	defc	poly_callee = cm32_sccz80_fspoly_callee

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _poly_callee
	defc _poly_callee = poly_callee

