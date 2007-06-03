;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 30/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
;
; $Id: lseek.asm,v 1.1 2007-06-03 15:13:06 stefano Exp $

	XLIB	lseek

.lseek
	ld	hl,-1	;non zero is error
	ld	d,h
	ld	e,l
	ret
