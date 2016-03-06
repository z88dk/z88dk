; Dummy function to keep rest of libs happy
;
; $Id: open.asm,v 1.6 2016-03-06 21:39:54 dom Exp $
;

                SECTION code_clib

		PUBLIC	open
		PUBLIC	_open

.open
._open
	ld	hl,-1	;error
	ret
