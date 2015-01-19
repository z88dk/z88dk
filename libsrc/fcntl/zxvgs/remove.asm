;int remove(far char *name)
;returns 0 when OK
;
;	$Id: remove.asm,v 1.2 2015-01-19 01:32:44 pauloscustodio Exp $
;

	PUBLIC	remove

.remove
	POP	BC
	POP	DE	;filename
	PUSH	DE
	PUSH	BC
	RST	8
	DEFB	$CB
	AND	$7F
	LD	L,A
	LD	H,0
	RET
