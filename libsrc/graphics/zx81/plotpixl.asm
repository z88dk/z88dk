	INCLUDE	"grafix.inc"

	XLIB	plotpixel

	LIB pixeladdress
	XREF	COORDS

; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; in:  hl	= (x,y) coordinate of pixel (h,l)
;
; registers changed	after return:
;  ..bc..../ixiy same
;  af..dehl/.... different
;

.gfxchar		defb	0

.plotpixel		
			push	bc
			push	ix
			push	iy
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range
			cp	maxx
			ret	nc
			ld	(COORDS),hl
			ld	b,l
			ld	c,h
			call	3005
			pop	iy
			pop	ix
			pop	bc
			ret
