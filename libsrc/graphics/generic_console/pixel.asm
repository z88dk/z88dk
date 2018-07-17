
	INCLUDE	"graphics/grafix.inc"

	EXTERN	generic_console_printc
	EXTERN	generic_console_vpeek
	EXTERN	textpixl


IF maxx <> 256
		ld	a,h
		cp	maxx
		ret	nc
ENDIF
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
IF NEEDplot
		or	b
ENDIF
IF NEEDunplot
		cpl
		and	b
ENDIF
IF NEEDxor
		xor	b
ENDIF
IF NEEDpoint
		and	b
		pop	bc
ELSE
		ld	hl,textpixl
		ld	d,0
		ld	e,a
		add	hl,de
		ld	a,(hl)
		pop	bc		;reduced coordinates
		ld	e,1		;raw mode
		call	generic_console_printc
ENDIF
		pop	bc
		ret
