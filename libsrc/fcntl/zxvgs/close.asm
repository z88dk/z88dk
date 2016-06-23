;int close(int handle)
;returns 0 if OK
;
;	$Id: close.asm,v 1.3 2016-06-23 20:31:34 dom Exp $
;

	SECTION code_clib
	PUBLIC	close
	PUBLIC	_close

.close
._close
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
