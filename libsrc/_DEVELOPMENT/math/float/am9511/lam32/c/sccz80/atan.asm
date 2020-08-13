
	SECTION	code_fp_am9511
	PUBLIC	atan
	EXTERN	cam32_sccz80_atan

	defc	atan = cam32_sccz80_atan


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atan
EXTERN cam32_sdcc_atan
defc _atan = cam32_sdcc_atan
ENDIF

