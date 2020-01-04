
	SECTION	code_clib

	PUBLIC	trsdos_tst
	PUBLIC	_trsdos_tst

	EXTERN	trsdos_tst_callee
	EXTERN	ASMDISP_TRSDOS_TST_CALLEE


; (unsigned int fn, char *hl_reg, char *de_reg);

.trsdos_tst
._trsdos_tst
	POP BC	; ret addr

	POP	DE
	POP HL
	POP	IX
	
	PUSH IX
	PUSH HL
	PUSH DE
	
	PUSH BC

	jp trsdos_tst_callee + ASMDISP_TRSDOS_TST_CALLEE
