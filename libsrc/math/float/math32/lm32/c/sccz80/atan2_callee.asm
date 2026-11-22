
	SECTION	code_fp_math32
	PUBLIC	atan2_callee
	EXTERN	cm32_sccz80_atan2_callee

	defc	atan2_callee = cm32_sccz80_atan2_callee

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _atan2_callee
	defc _atan2_callee = atan2_callee

