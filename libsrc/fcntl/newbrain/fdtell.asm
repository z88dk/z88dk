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
; $Id: fdtell.asm,v 1.2 2015-01-21 08:09:27 stefano Exp $


	PUBLIC	fdtell

.fdtell
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret

