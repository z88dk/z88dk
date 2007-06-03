;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 30/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; Delete a file
;     
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; int remove(char *name)
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: remove.asm,v 1.1 2007-06-03 15:13:06 stefano Exp $

	XLIB	remove

.remove
	ld	hl,-1
	ret

