;
;       C128 pseudo graphics routines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2020
;
;
;       $Id: clsgraph.asm $
;

			SECTION   code_clib
			PUBLIC    cleargraphics
         PUBLIC    _cleargraphics
			EXTERN     loadudg6
			EXTERN	base_graphics

			INCLUDE	"graphics/grafix.inc"


.cleargraphics
._cleargraphics
	
	ld	bc,$d018
	ld	a,$8c
	out (c),a
	
	ld   c,0	; first UDG chr$ to load
	ld	 b,64	; number of characters to load
	ld   hl,12288	; UDG area
	call loadudg6

	ld	hl,(base_graphics)
	ld	bc,40*25
.clean
	ld	(hl),blankch
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,clean

	ret
