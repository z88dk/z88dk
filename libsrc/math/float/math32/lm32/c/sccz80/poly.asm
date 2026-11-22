
	SECTION	code_fp_math32
	PUBLIC	poly
	EXTERN	cm32_sccz80_fspoly

	defc	poly = cm32_sccz80_fspoly

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _poly
	defc _poly = poly

	; Clang C-linkage ABI aliases for Classic and Newlib.
	PUBLIC ___poly
	defc ___poly = poly

