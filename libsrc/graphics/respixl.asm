	INCLUDE	"graphics/grafix.inc"

	XLIB	respixel

	LIB	pixeladdress
	XREF	COORDS

;
;	$Id: respixl.asm,v 1.3 2001-04-18 13:21:37 stefano Exp $
;

; ******************************************************************
;
; Reset pixel at (x,y) coordinate
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; in:  hl = (x,y) coordinate of pixel (h,l)
;
; registers changed	after return:
;  ..bc..../ixiy same
;  af..dehl/.... different
;
.respixel
			IF maxx <> 256
				ld	a,h
				cp	maxx
				ret	nc
			ENDIF

				ld	a,l
				cp	maxy
				ret	nc			; y0	out of range

				ld	(COORDS),hl

				push	bc
				call	pixeladdress
				ld	b,a
				ld	a,1
				jr	z, reset_pixel
.reset_position	rlca
				djnz	reset_position
.reset_pixel			ex	de,hl
				cpl
				and	(hl)
				ld	(hl),a
				pop	bc
				ret
