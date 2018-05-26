;
;       Generic pseudo graphics routines for text-only platforms
;
;       Written by Stefano Bodrato 07/09/2007
;
;
;       Get pixel at (x,y) coordinate.
;
;
;	$Id: pointxy.asm $
;


			INCLUDE	"graphics/grafix.inc"

                        SECTION code_clib
			PUBLIC	pointxy

			EXTERN  textpixl
			EXTERN	generic_console_vpeek


.pointxy
			ld	a,h
			cp	maxx
			ret	nc
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range
			
			push	bc
			push	de
			push	hl		; save coordinates
	
			ld	c,l
			ld	h,b
			srl	c
			srl	b
			call	generic_console_vpeek
			ld	e,a
			ld	hl,textpixl
			ld	e,0
			ld	b,16
.ckmap			cp	(hl)
			jr	z,chfound
			inc	hl
			inc	e
			djnz	ckmap
			ld	e,0
.chfound		ld	a,e
			pop	hl		;coordinates back

			ld	b,a
			ld	a,1		; the bit we want to draw
			
			bit	0,h
			jr	z,iseven
			add	a,a		; move right the bit

.iseven
			bit	0,l
			jr	z,evenrow
			add	a,a
			add	a,a		; move down the bit
.evenrow
			
			and	b
			
			pop	de
			pop	bc
			
			ret
