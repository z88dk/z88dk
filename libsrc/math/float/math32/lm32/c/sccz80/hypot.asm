
	SECTION	code_fp_math32
	PUBLIC	hypot
	EXTERN	cm32_sccz80_fshypot

	defc	hypot = cm32_sccz80_fshypot

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _hypot
	defc _hypot = hypot

	; Clang C-linkage ABI aliases for Classic and Newlib.
	PUBLIC ___hypot
	defc ___hypot = hypot

