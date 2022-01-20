
	SECTION	code_fp_am9511
	PUBLIC	cos
	EXTERN	cam32_sccz80_cos

	defc	cos = cam32_sccz80_cos


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cos
EXTERN cam32_sdcc_cos
defc _cos = cam32_sdcc_cos
ENDIF

