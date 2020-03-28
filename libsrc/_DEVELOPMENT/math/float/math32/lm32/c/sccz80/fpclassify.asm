
	SECTION	code_fp_math32
	PUBLIC	fpclassify
	EXTERN	cm32_sccz80_fpclassify

	defc	fpclassify = cm32_sccz80_fpclassify


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fpclassify
EXTERN  cm32_sdcc_fpclassify
defc _fpclassify = cm32_sdcc_fpclassify
ENDIF

