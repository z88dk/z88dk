;
;       Kaypro '84 pseudo graphics routines
;	Version for the 2x4 graphics symbols, BIOS driven
;
;       Stefano Bodrato 2018
;
;
;       Plot pixel at (x,y) coordinate.
;
;
;	$Id: plotpixl.asm $
;


			INCLUDE	"graphics/grafix.inc"

			SECTION code_clib
			PUBLIC	plotpixel

			EXTERN	div3
			EXTERN	__gfx_coords
			EXTERN	base_graphics

.plotpixel
			ld	a,h
			cp	maxx
			ret	nc
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range
			
			push bc

			ld	(__gfx_coords),hl
			push hl
			push hl

			ld	e,27
			ld	c,2
			call	5
			
			ld	e,'*'
			ld	c,2
			call	5
			
			pop hl
			ld	a,l	; vertical
			add 32
			ld	e,a
			ld	c,2
			call	5

			pop hl
			ld	a,h	; horizontal
			add 32
			ld	e,a
			ld	c,2
			call	5
			
			pop bc

			ret
