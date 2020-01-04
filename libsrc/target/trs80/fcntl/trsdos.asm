
	SECTION	code_clib

	PUBLIC	trsdos
	PUBLIC	_trsdos

	EXTERN	trsdos_callee
	EXTERN	ASMDISP_TRSDOS_CALLEE


; (unsigned int fn, char *hl_reg, char *de_reg);

.trsdos
._trsdos
	POP BC	; ret addr

	POP	DE
	POP HL
	POP	IX
	
	PUSH IX
	PUSH HL
	PUSH DE
	
	PUSH BC

	jp trsdos_callee + ASMDISP_TRSDOS_CALLEE
