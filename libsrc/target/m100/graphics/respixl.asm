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
	INCLUDE "target/m100/def/romcalls.def"
.respixel
			ld	d,h
			ld	e,l
			ld	(__gfx_coords),hl
			ROMCALL
			defw	LCDRES
			ret

