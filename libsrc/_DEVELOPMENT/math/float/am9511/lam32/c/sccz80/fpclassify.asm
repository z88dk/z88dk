
	SECTION	code_fp_am9511
	PUBLIC	fpclassify
	EXTERN	cam32_sccz80_fpclassify

	defc	fpclassify = cam32_sccz80_fpclassify


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fpclassify
EXTERN  cam32_sdcc_fpclassify
defc _fpclassify = cam32_sdcc_fpclassify
ENDIF

