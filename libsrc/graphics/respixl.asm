	INCLUDE	"grafix.inc"

	XLIB	respixel

	LIB	pixeladdress
	XREF	COORDS

; ******************************************************************
;
; Reset pixel at (x,y) coordinate
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; in:  hl	= (x,y) coordinate of pixel (h,l)
;
; registers changed	after return:
;  ..bc..../ixiy same
;  af..dehl/.... different
;
.respixel			ld	a,l
				cp	maxy
				ret	nc				; ups - y0 is out of range

				ld	(COORDS),hl
				ld	a,l
IF FORz88
				xor	@00111111			; (0,0) is hardware	(0,63)
ENDIF
IF FORvz
				xor	@00111111			; (0,0) is hardware	(0,63)
ENDIF
				push	bc
				ld	l,a

				call	pixeladdress
				ld	b,a
				ld	a,1
				jr	z, reset_pixel
.reset_position	rlca
				djnz	reset_position
.reset_pixel		ex	de,hl
				cpl
				and	(hl)
				ld	(hl),a
				pop	bc
				ret
