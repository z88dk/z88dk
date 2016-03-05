; Dummy function to keep rest of libs happy
;
; $Id: creat.asm,v 1.5 2016-03-05 00:13:02 dom Exp $
;

		PUBLIC	creat
		PUBLIC	_creat

.creat
._creat
	ld	hl,-1	;error
	ret
