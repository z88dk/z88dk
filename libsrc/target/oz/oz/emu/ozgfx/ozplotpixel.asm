;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
; ------
; $Id: ozplotpixel.asm,v 1.4 2016-06-28 14:48:17 dom Exp $
;

	SECTION smc_clib
	PUBLIC	ozplotpixel
	PUBLIC	put_instr

	EXTERN	pixeladdress

	EXTERN	COORDS


	INCLUDE	"graphics/grafix.inc"


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
