
	SECTION	code_fp_math32
	PUBLIC	fpclassify
	EXTERN	cm32_sccz80_fpclassify

	defc	fpclassify = cm32_sccz80_fpclassify

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _fpclassify
	defc _fpclassify = fpclassify

