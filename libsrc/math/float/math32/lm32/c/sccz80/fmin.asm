
	SECTION	code_fp_math32
	PUBLIC	fmin
	EXTERN	cm32_sccz80_fmin

	defc	fmin = cm32_sccz80_fmin

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _fmin
	defc _fmin = fmin

	; Clang C-linkage ABI aliases for Classic and Newlib.
	PUBLIC ___fmin
	defc ___fmin = fmin

