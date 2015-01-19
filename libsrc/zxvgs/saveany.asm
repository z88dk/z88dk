;ZXVGS specific functions

;020122	now returns the number of saved bytes - 0 means error!
;020121	(C) created by Yarek

	PUBLIC	saveany

;int saveany(char *name, int adr, int len)
;returns number of saved bytes

.saveany
	POP	AF	;return address
	POP	BC
	POP	HL
	POP	DE
	PUSH	DE
	PUSH	HL
	PUSH	BC
	PUSH	AF
	RST	8
	DEFB	$ED
	AND	$7F
	LD	L,C
	LD	H,B
	RET
