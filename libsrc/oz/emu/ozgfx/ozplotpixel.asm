;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
; ------
; $Id: ozplotpixel.asm,v 1.1 2003-10-27 16:56:57 stefano Exp $
;

	XLIB	ozplotpixel
	XDEF	put_instr

	LIB	pixeladdress

	XREF	COORDS


	INCLUDE	"../graphics/grafix.inc"


ozplotpixel:

			IF maxx <> 256
				ld	a,h
				cp	maxx
				jr	nc,xyoverflow
			ENDIF

				ld	a,l
				cp	maxy
				jr	nc,xyoverflow
				
				ld	(COORDS),hl

				push	bc
				call	pixeladdress
				ld	b,a
				ld	a,1
				jr	z, put_pixel
plot_position:			rlca
				djnz	plot_position
put_pixel:
				ex	de,hl

put_instr:			nop		; cpl       	nop
				or	(hl)	; and (hl)	xor (hl)

				ld	(hl),a
				pop	bc
				ret


xyoverflow:			ld	hl,-1
				ret
