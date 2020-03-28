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
; $Id: fdtell.asm,v 1.4 2016-06-19 20:26:58 dom Exp $

        SECTION code_clib
	PUBLIC	fdtell
	PUBLIC	_fdtell

.fdtell
._fdtell
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret

