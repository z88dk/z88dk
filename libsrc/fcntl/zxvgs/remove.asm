;int remove(far char *name)
;returns 0 when OK
;
;	$Id: remove.asm,v 1.1 2002-06-23 12:11:31 dom Exp $
;

	XLIB	remove

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
