;
;       Generic pseudo graphics routines for text-only platforms
;
;       Written by Stefano Bodrato 30/01/2002
;
;
;       Plot pixel at (x,y) coordinate.
;
;
;	$Id: plotpixl.asm,v 1.3 2014-04-18 09:30:31 stefano Exp $
;


			INCLUDE	"graphics/text/textgfx.inc"

			XLIB	plotpixel

			LIB	textpixl
			XREF	coords
			XREF	base_graphics


.plotpixel			
			ld	a,h
			cp	maxx
			ret	nc
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range
			
			ld	(coords),hl
			
			push	bc

			ld	c,a
			ld	b,h

			push	bc
			
			srl	b
			srl	c
			ld	hl,(base_graphics)
			ld	a,c
			ld	c,b	; !!
			and	a
			jr	z,r_zero
			ld	b,a
			ld	de,maxx/2
.r_loop
			add	hl,de
			djnz	r_loop
.r_zero						; hl = char address
			ld	e,c
			add	hl,de
			
			ld	a,(hl)		; get current symbol

			ld	e,a

			push	hl
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
			pop	hl

			ex	(sp),hl		; save char address <=> restore x,y

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

			pop	hl
			ld	(hl),a
			
			pop	bc
			ret
