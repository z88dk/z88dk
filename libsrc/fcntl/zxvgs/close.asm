;int close(int handle)
;returns 0 if OK
;
;	$Id: close.asm,v 1.1 2002-06-23 12:11:31 dom Exp $
;

	XLIB	close

.close
	POP	BC	;ret
	POP	DE
	PUSH	DE
	PUSH	BC
	RST	8
	DEFB	$D0
	AND	$7F
	LD	L,A
	LD	H,0
	RET
