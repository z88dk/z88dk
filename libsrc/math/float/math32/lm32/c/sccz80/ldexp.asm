
	SECTION	code_fp_math32
	PUBLIC	ldexp
	EXTERN	cm32_sccz80_ldexp

	defc	ldexp = cm32_sccz80_ldexp

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _ldexp
	defc _ldexp = ldexp

	; Clang C-linkage ABI aliases for Classic and Newlib.
	PUBLIC ___ldexp
	defc ___ldexp = ldexp

