
	XLIB	pixeladdress

	INCLUDE	"graphics/grafix.inc"

	XREF	base_graphics

;
;	$Id: pixladdr.asm,v 1.2 2001-06-18 10:46:31 stefano Exp $
;

; ******************************************************************
;
; Get absolute	pixel address in map of virtual (x,y) coordinate.
;
; in:  hl	= (x,y) coordinate of pixel (h,l)
;
; out: de	= address	of pixel byte
;	   a	= bit number of byte where pixel is to be placed
;	  fz	= 1 if bit number is 0 of pixel position
;
; registers changed	after return:
;  ......hl/ixiy same
;  afbcde../.... different
;


; We use the Amstrad ROM function
;
;095   &BC1D   SCR DOT POSITION
;      Action: Gets the memory  address  of  a  pixel  at  a specified
;              screen position
;      Entry:  DE contains the base X-coordinate  of the pixel, and HL
;              contains the base Y-coordinate
;      Exit:   HL contains the memory address of the pixel, C contains
;              the bit mask for this  pixel,  B contains the number of
;              pixels stored in a byte minus 1, AF and DE are corrupt,
;              and all others are preserved


.pixeladdress

	ld	a,maxy
	sub	l
	
	ld	d,0
	ld	e,h
	ld	h,d
	ld	l,a

	call	$BC1D
	ld	d,h
	ld	e,l

	ld	a,c
	
	and	b
	xor	b

	ret

