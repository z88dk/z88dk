;
;       Generic pseudo graphics routines for text-only platforms
;	Version for the 2x3 graphics symbols
;
;       Written by Stefano Bodrato 19/12/2006
;
;
;       Invert pixel at (x,y) coordinate.
;
;
;	$Id: xorpixl.asm,v 1.7 2016-07-02 09:01:36 dom Exp $
;


			INCLUDE	"graphics/grafix.inc"
			SECTION code_clib
			PUBLIC	xorpixel

			EXTERN	textpixl
			EXTERN	div3
			EXTERN	__gfx_coords
			EXTERN	base_graphics

.xorpixel
			ld	a,h
			cp	maxx
			ret	nc
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range

			dec	a
			dec	a
			
			ld	(__gfx_coords),hl
			
			push	bc

			ld	c,a	; y
			ld	b,h	; x
			
			push	bc
			
			ld	hl,div3
			ld	d,0
			ld	e,c
			inc	e
			adc	hl,de
			ld	a,(hl)
			ld	c,a	; y/3
			
			srl	b	; x/2
			
			ld	a,c
			ld	c,b	; !!

;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

			ld	hl,0BCAh
			ld	b,a		; keep y/3
			and	a
			jr	z,r_zero
		
			ld	hl,$80a
			dec	a
			jr	z,r_zero
			ld	de,64
.r_loop
			add	hl,de
			dec	a
			jr	nz,r_loop
		
.r_zero
			ld	e,c
			add	hl,de

;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

			ld	a,(hl)		; get current symbol from screen
			ld	e,a		; ..and its copy

			push	hl		; char address
			push	bc		; keep y/3
			ld	hl,textpixl
			ld	e,0
			ld	b,64		; whole symbol table size
.ckmap			cp	(hl)		; compare symbol with the one in map
			jr	z,chfound
			inc	hl
			inc	e
			djnz	ckmap
			ld	e,0
.chfound		ld	a,e
			pop	bc		; restore y/3 in b
			pop	hl		; char address
			
			ex	(sp),hl		; save char address <=> restore x,y  (y=h, x=l)
			
			ld	c,a		; keep the symbol
			
			ld	a,l
			inc	a
			inc	a
			sub	b
			sub	b
			sub	b		; we get the remainder of y/3
			
			ld	l,a
			ld	a,1		; the pixel we want to draw
			
			jr	z,iszero
			bit	0,l
			jr	nz,is1
			add	a,a
			add	a,a
.is1
			add	a,a
			add	a,a
.iszero
			
			bit	0,h
			jr	z,evenrow
			add	a,a		; move down the bit
.evenrow
			xor	c

			ld	hl,textpixl
			ld	d,0
			ld	e,a
			add	hl,de
			ld	a,(hl)

			pop	hl
			ld	(hl),a
			
			pop	bc
			ret
