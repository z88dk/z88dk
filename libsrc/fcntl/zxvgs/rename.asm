;int rename(char *source, char *dest)
;returns 0 when OK
;
;	$Id: rename.asm,v 1.1 2002-06-23 12:11:31 dom Exp $
;

	XLIB	rename

.rename
	POP	BC
	POP	HL	;new filename
	POP	DE	;old
	PUSH	DE
	PUSH	HL
	PUSH	BC
	RST	8
	DEFB	$CE	;also can move file to another path/disk...
	AND	$7F
	LD	L,A
	LD	H,0
	RET
