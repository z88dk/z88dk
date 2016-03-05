; Dummy function to keep rest of libs happy
;
; $Id: open.asm,v 1.5 2016-03-05 00:13:02 dom Exp $
;


		PUBLIC	open
		PUBLIC	_open

.open
._open
	ld	hl,-1	;error
	ret
