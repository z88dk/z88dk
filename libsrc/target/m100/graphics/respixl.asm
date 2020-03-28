;
;       Tandy M100 ROM based graphics routines
;       Written by Stefano Bodrato 2020
;
;
;       Reset pixel at (x,y) coordinate.
;
;
;	$Id: respixl.asm $
;


			INCLUDE	"graphics/grafix.inc"

			SECTION code_clib
			PUBLIC	respixel

			EXTERN	__gfx_coords
			EXTERN	base_graphics

.respixel
			ld	d,h
			ld	e,l
			ld	(__gfx_coords),hl
			jp	$744D

