
	SECTION	code_clib

	PUBLIC	trsdos_tst
	PUBLIC	_trsdos_tst

	EXTERN	asm_trsdos_tst


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

	jp asm_trsdos_tst