	INCLUDE	"graphics/grafix.inc"

	XLIB	xorpixel

	LIB pixeladdress
	XREF	COORDS

;
;	$Id: xorpixl.asm,v 1.3 2002-03-28 09:41:14 stefano Exp $
;

; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; The (0,0) origin is placed at the bottom left corner.
;
; in:  hl	= (x,y) coordinate of pixel (h,l)
;
; registers changed	after return:
;  ..bc..../ixiy same
;  af..dehl/.... different
;
; ******************************************************************
;
; XOR added by Stefano Bodrato (Feb 2001)
;
; **************
;

.xorpixel			ld	a,l
				cp	64
				ret	nc				; y0	out of range

				ld	(COORDS),hl
				ld	a,l
IF forZ88
;				xor	@00111111			; (0,0) is hardware	(0,63)
ENDIF
IF forVZ
;				xor	@00111111			; (0,0) is hardware	(0,63)
ENDIF
				push	bc
				ld	l,a

				call	pixeladdress
				ld	b,a
				ld	a,1
				jr	z, xor_pixel		; pixel is at bit 0...
.plot_position			rlca
				djnz	plot_position
.xor_pixel			ex	de,hl
				xor	(hl)
				ld	(hl),a
				pop	bc
				ret
