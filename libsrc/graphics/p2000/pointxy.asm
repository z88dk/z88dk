;
;       Philips P2000 pseudo graphics routines
;	Version for the 2x3 graphics symbols
;
;
;       Written by Stefano Bodrato 2014
;
;
;       Get pixel at (x,y) coordinate.
;
;
;	$Id: pointxy.asm,v 1.10 2016-07-02 09:01:36 dom Exp $
;


			INCLUDE	"graphics/grafix.inc"

		        SECTION code_clib
			PUBLIC	pointxy

			EXTERN	div3
			EXTERN	__gfx_coords
			EXTERN	base_graphics

.pointxy
			ld	a,h
			cp	maxx
			ret	nc
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range

			dec	a
			dec	a
			
			push	bc
			push	de
			push	hl			
			
			ld	(__gfx_coords),hl
			
			;push	bc

			ld	c,a	; y
			ld	b,h	; x
			
			push	bc
			
			ld	hl,div3
			ld	d,0
			ld	e,c
			inc	e
			add	hl,de
			ld	a,(hl)
			ld	c,a	; y/3
			
			srl	b	; x/2
			
			ld	a,c
			ld	c,b	; !!

;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

			ld    hl,(base_graphics)
			inc hl
			ld	b,a		; keep y/3
			and	a
			jr	z,r_zero

			ld	de,80
.r_loop
			add	hl,de
			dec	a
			jr	nz,r_loop
		
.r_zero     ld	d,0
			ld	e,c
			add	hl,de

;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

			ld	a,(hl)		; get current symbol from screen
			sub 32
			ld	e,a		; ..and its copy
			
			pop	hl		;  restore x,y  (y=h, x=l)
			


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
			and  @11011111	; Character generator gap
			jr  nz,nobug
			or   @01000000  ;
.nobug
;			cpl
;			and  @11011111	; Character generator bug
			and	e
			

			pop	hl
			pop	de
			pop	bc
			
			ret
