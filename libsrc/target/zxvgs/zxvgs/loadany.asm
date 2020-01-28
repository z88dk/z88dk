;ZXVGS specific functions

;020121	(C) created by Yarek

	SECTION code_clib
	PUBLIC	loadany
	PUBLIC	_loadany

;int loadany(char *name, int adr, int len)
;returns 0 if OK

.loadany
._loadany
	POP	AF	;return address
	POP	BC
	POP	HL
	POP	DE
	PUSH	DE
	PUSH	HL
	PUSH	BC
	PUSH	AF
	RST	8
	DEFB	$EC
	AND	$7F
	LD	L,A
	LD	H,0
	RET
