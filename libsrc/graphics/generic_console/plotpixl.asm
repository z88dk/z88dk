;
;       Generic pseudo graphics routines for text-only platforms
;
;       Written by Stefano Bodrato 30/01/2002
;
;
;       Plot pixel at (x,y) coordinate.
;
;


			INCLUDE	"graphics/grafix.inc"

                        SECTION code_clib
			PUBLIC	plotpixel

			EXTERN	textpixl
			EXTERN	generic_console_printc
			EXTERN	generic_console_vpeek

.plotpixel			
		ld	a,h
		cp	maxx
		ret	nc
		ld	a,l
		cp	maxy
		ret	nc		; y0	out of range
		
		push	bc		;save entry bc	
		ld	c,h
		ld	b,l
		srl	b
		srl	c
		push	bc		;save reduced cooardinates
		push	hl		;save original coordinates
		call	generic_console_vpeek
		ld	e,a

		ld	hl,textpixl
		ld	e,0
		ld	b,16
.ckmap		cp	(hl)
		jr	z,chfound
		inc	hl
		inc	e
		djnz	ckmap
		ld	e,0
.chfound	ld	a,e

		pop	hl		;original coordinates

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
		or	b

		ld	hl,textpixl
		ld	d,0
		ld	e,a
		add	hl,de
		ld	a,(hl)
		pop	bc		;reduced coordinates
		ld	e,0		;raw mode
		call	generic_console_printc
		pop	bc
		ret
