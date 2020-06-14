
	SECTION	code_fp_math16
	PUBLIC	f16_hypot_callee
	EXTERN	cm16_sccz80_hypot_callee

	defc	f16_hypot_callee = cm16_sccz80_hypot_callee


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_hypot_callee
EXTERN cm16_sdcc_hypot_callee
defc _f16_hypot_callee = cm16_sdcc_hypot_callee
ENDIF

