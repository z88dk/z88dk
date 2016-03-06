; Dummy function to keep rest of libs happy
;
; $Id: creat.asm,v 1.6 2016-03-06 21:39:54 dom Exp $
;

                SECTION code_clib

		PUBLIC	creat
		PUBLIC	_creat

.creat
._creat
	ld	hl,-1	;error
	ret
