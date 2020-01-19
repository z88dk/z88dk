;
;       Generic pseudo graphics routines for text-only platforms
;	Version for the 2x3 graphics symbols
;
;       Written by Stefano Bodrato 19/12/2006
;
;
;       XOR pixel at (x,y) coordinate.
;
;
;	$Id: xorpixl.asm $
;


			INCLUDE	"graphics/grafix.inc"

		        SECTION code_clib
			PUBLIC	xorpixel

			EXTERN	textpixl
			EXTERN	div3_0
			EXTERN	__gfx_coords
			
			EXTERN	char_address

.xorpixel
			ld	a,h
			cp	maxx
			ret	nc
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range
			
			ld	(__gfx_coords),hl
			
			push	bc

			ld	c,a	; y
			ld	b,h	; x
			
			push	bc		; b=x, c=y
			
			ld	hl,div3_0
			ld	d,0
			ld	e,b
			add	hl,de
			ld	a,(hl)
			ld	b,a	; x/3
			
			srl	c	; y/2
			
			push	bc		; b=x/3, c=y/2
			call	char_address
			
			ld	a,(hl)		; get current symbol from screen
			;ld	e,a		; ..and its copy

			sub	192
			
			pop	bc		; restore x/3 in b
			
			ex	(sp),hl		; save char address <=> restore x,y  (x=h, y=l)
			
			ld	e,a		; keep the symbol
			
			ld	a,h

			sub	b
			sub	b
			sub	b		; we get the remainder of x/3
			
			ld	b,a
.first_dot
			ld	a,1		; the pixel we want to draw
.second_dot
			jr	z,iszero
			bit	0,b
			jr	nz,is1
			add	a,a
			add	a,a
.is1
			add	a,a
			add	a,a
.iszero
			
			bit	0,l
			jr	z,evenrow
			add	a,a		; move down the bit
.evenrow
			xor	e

			add	192
			
			pop	hl
			ld	(hl),a
			
			pop	bc
			ret
