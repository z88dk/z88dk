;
;	MSX basic graphics routines
;	by Stefano Bodrato, December 2007
;

	XLIB	pointxy

	INCLUDE	"graphics/grafix.inc"

	LIB	msxbios
        INCLUDE "#msxbios.def"

;
;	$Id: pointxy.asm,v 1.1 2007-12-18 09:00:44 stefano Exp $
;
; ******************************************************************
;
; Check if pixel at (x,y) coordinate is set or not.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; (0,0) origin is defined as the top left corner.
;
;  in:	hl =	(x,y) coordinate of pixel to test
; out:	Fz =	0, if pixel is set, otherwise Fz = 1.
;
; registers changed	after return:
;  ..bcdehl/ixiy same
;  af....../.... different
;

.pointxy
	ld	a,l
	cp	maxy
	ret	nc			; y out of range

	push	bc
	push	de
	push	hl
	push	ix


	ld	b,0
	ld	c,h			; BC = x
	ld	d,b
	ld	e,l			; DE = y
	ld	ix,SCALXY
	call	msxbios
	ld	ix,MAPXY
	call	msxbios
	ld	ix,READC
	call	msxbios

	cp	fcolor

	pop	ix
	pop	hl
	pop	de
	pop	bc
	ret
