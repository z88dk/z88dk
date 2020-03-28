;
;       Jupiter ACE pseudo graphics routines
;	Version for the 2x3 graphics symbols (UDG redefined)
;
;       Stefano Bodrato 2014
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

			EXTERN	__gfx_coords
			EXTERN	base_graphics

.plotpixel
			ld	d,h
			ld	e,l
			ld	(__gfx_coords),hl
			jp	$744C
