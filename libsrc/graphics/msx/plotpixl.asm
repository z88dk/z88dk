;
;	MSX basic graphics routines
;	by Stefano Bodrato, December 2007
;

	XLIB	plotpixel
	XREF	COORDS

	INCLUDE	"graphics/grafix.inc"

	LIB	msxbasic
        INCLUDE "#msxbasic.def"

;
;	$Id: plotpixl.asm,v 1.1 2007-12-18 09:00:44 stefano Exp $
;
; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
;
; registers changed after return:
;  ..bc..../ixiy same
;  af..dehl/.... different
;


.plotpixel
	ld	a,l
	cp	maxy
	ret	nc		; y0	out of range
	push	bc
	push	ix
	ld	(COORDS),hl
	ld	b,0
	ld	c,h
	ld	(GRPACX),bc
	ld	d,b
	ld	e,l
	ld	(GRPACY),de
	ld	ix,DOPSET
	call	msxbasic
	pop	ix
	pop	bc
	ret
