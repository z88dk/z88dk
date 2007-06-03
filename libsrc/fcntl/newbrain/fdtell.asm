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
; $Id: fdtell.asm,v 1.1 2007-06-03 15:13:06 stefano Exp $


	XLIB	fdtell

.fdtell
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret

