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
; $Id: fdtell.asm,v 1.3 2015-01-22 12:09:57 stefano Exp $


	PUBLIC	fdtell

.fdtell
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret

