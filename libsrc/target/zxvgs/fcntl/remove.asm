;int remove(far char *name)
;returns 0 when OK
;
;	$Id: remove.asm,v 1.3 2016-06-23 20:31:34 dom Exp $
;

	SECTION code_clib
	PUBLIC	remove
	PUBLIC	_remove

.remove
._remove
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
