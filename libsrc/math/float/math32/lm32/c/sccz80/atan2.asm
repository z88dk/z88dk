
	SECTION	code_fp_math32
	PUBLIC	atan2
	EXTERN	cm32_sccz80_atan2

	defc	atan2 = cm32_sccz80_atan2

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _atan2
	defc _atan2 = atan2

	; Clang C-linkage ABI aliases for Classic and Newlib.
	PUBLIC ___atan2
	defc ___atan2 = atan2

