
	SECTION	code_fp_am9511
	PUBLIC	atan2_callee
	EXTERN	cam32_sccz80_atan2_callee

	defc	atan2_callee = cam32_sccz80_atan2_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atan2_callee
EXTERN cam32_sdcc_atan2_callee
defc _atan2_callee = cam32_sdcc_atan2_callee
ENDIF

