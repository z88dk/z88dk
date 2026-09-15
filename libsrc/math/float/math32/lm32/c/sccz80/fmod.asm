
	SECTION	code_fp_math32
	PUBLIC	fmod
	EXTERN	cm32_sccz80_fmod

	defc	fmod = cm32_sccz80_fmod

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _fmod
	defc _fmod = fmod

	; Clang C-linkage ABI aliases for Classic and Newlib.
	PUBLIC ___fmod
	defc ___fmod = fmod

