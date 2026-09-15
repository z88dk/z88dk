
	SECTION	code_fp_math32
	PUBLIC	modf
	EXTERN	cm32_sccz80_modf

	defc	modf = cm32_sccz80_modf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _modf
	defc _modf = modf

	; Clang C-linkage ABI aliases for Classic and Newlib.
	PUBLIC ___modf
	defc ___modf = modf

