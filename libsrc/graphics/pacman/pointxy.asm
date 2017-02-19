;
;       Generic pseudo graphics routines for text-only platforms
;
;       PacMan Hardware port by Stefano Bodrato, 2017
;
;
;       Get pixel at (x,y) coordinate.
;
;
;	$Id:$
;


			INCLUDE	"graphics/grafix.inc"

                        SECTION code_clib
			PUBLIC	pointxy

			EXTERN  textpixl
			EXTERN  __gfx_coords
			EXTERN	char_address


.pointxy
			ld	a,h
			cp	maxx
			ret	nc
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range
			
			push	bc
			push	de
			push	hl			
			
			ld	(__gfx_coords),hl

			;push	bc

			ld	c,a	
			ld	b,h

			push	bc

			srl	b	; x/2
			srl	c	; y/2
			
			
			call	char_address

			
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
			
			and	b
			
			pop	bc
			
			pop	hl
			pop	de
			pop	bc
			
			ret
