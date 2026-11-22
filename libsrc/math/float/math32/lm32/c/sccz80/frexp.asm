
	SECTION	code_fp_math32
	PUBLIC	frexp
	EXTERN	cm32_sccz80_frexp

	defc	frexp = cm32_sccz80_frexp

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _frexp
	defc _frexp = frexp

	; Clang C-linkage ABI aliases for Classic and Newlib.
	PUBLIC ___frexp
	defc ___frexp = frexp

