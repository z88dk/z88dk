;long fdtell(int fd)
;returns position in file
;
;	$Id: fdtell.asm,v 1.3 2016-06-23 20:31:34 dom Exp $
;

	SECTION code_clib
	PUBLIC	fdtell
	PUBLIC	_fdtell

.fdtell
._fdtell
	POP	BC	;ret
	POP	DE
	PUSH	DE
	PUSH	BC
	RST	8
	DEFB	$D8
	AND	$7F
	LD	D,A
	RET	Z
;Error, return with -1
	LD	HL,-1		;load hlde with -1L
	LD	E,L
	LD	D,H
	RET			;error
