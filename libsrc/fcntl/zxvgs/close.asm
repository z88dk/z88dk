;int close(int handle)
;returns 0 if OK
;
;	$Id: close.asm,v 1.2 2015-01-19 01:32:44 pauloscustodio Exp $
;

	PUBLIC	close

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
