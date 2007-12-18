;
;	MSX basic graphics routines
;	by Stefano Bodrato, December 2007
;

	XLIB	respixel
	XREF	COORDS

	INCLUDE	"graphics/grafix.inc"

	LIB	msxbasic
        INCLUDE "#msxbasic.def"

;
;	$Id: respixl.asm,v 1.1 2007-12-18 09:00:44 stefano Exp $
;
; ******************************************************************
;
; Clear pixel at (x,y) coordinate.
;
;
;
.respixel
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

	ld	hl,0F3E9h   ; fore color
	ld	a,(hl)
	push	af
	ld	a,(0F3EBh)  ; border (for bck color)
	;;ld	a,bcolor
	ld	(hl),a
	ld	(ATRBYT),a
	push	hl

	ld	ix,DOPSET
	call	msxbasic

	pop	hl
	pop	af
	ld	(hl),a
	ld	(ATRBYT),a

	pop	ix
	pop	bc
	ret
