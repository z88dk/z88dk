;int rename(char *source, char *dest)
;returns 0 when OK
;
;	$Id: rename.asm,v 1.3 2016-06-23 20:31:34 dom Exp $
;

	SECTION code_clib
	PUBLIC	rename
	PUBLIC	_rename

.rename
._rename
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
