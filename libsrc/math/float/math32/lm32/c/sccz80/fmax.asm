
	SECTION	code_fp_math32
	PUBLIC	fmax
	EXTERN	cm32_sccz80_fmax

	defc	fmax = cm32_sccz80_fmax

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _fmax
	defc _fmax = fmax

	; Clang C-linkage ABI aliases for Classic and Newlib.
	PUBLIC ___fmax
	defc ___fmax = fmax

