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
;	$Id: pointxy.asm $
;


			INCLUDE	"graphics/grafix.inc"

		        SECTION code_clib
			PUBLIC	pointxy

			EXTERN	div3_0
			EXTERN	__gfx_coords
			EXTERN	base_graphics

.pointxy
			ld	a,h
			cp	maxx
			ret	nc
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range			
			inc a
			;inc a
			
			push	bc
			push	de
			push	hl
			
			ld	(__gfx_coords),hl
			
			;push	bc

			ld	c,a	; y
			ld	b,h	; x
			
			push	bc
			
			ld	hl,div3_0
			ld	d,0
			ld	e,c
			inc e
			add	hl,de
			ld	a,(hl)
			ld	c,a	; y/3
			
			srl	b	; x/2
			
			ld    hl,(base_graphics)
			inc hl
			ld	a,c
			ld	c,b	; !!

;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

			and	a

			ld	de,80
			sbc	hl,de
			
			jr	z,r_zero
			ld	b,a

.r_loop			
			add	hl,de
			djnz	r_loop

.r_zero						; hl = char address
			ld	b,a		; keep y/3
			;ld	d,0
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
