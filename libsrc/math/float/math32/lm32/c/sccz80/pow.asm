
	SECTION	code_fp_math32
	PUBLIC	pow
	EXTERN	cm32_sccz80_pow

	defc	pow = cm32_sccz80_pow

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _pow
	defc _pow = pow

	; Clang C-linkage ABI aliases for Classic and Newlib.
	PUBLIC ___pow
	defc ___pow = pow

