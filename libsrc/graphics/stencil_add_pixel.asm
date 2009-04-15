;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;	Compute the line coordinates and put into a vector
;	Basic concept by Rafael de Oliveira Jannone (calculate_side)
;
;	Internal function to update the area object's vectors
;
;       Stefano Bodrato - 13/3/2009
;
;
;	$Id: stencil_add_pixel.asm,v 1.1 2009-04-15 21:00:58 stefano Exp $
;

; registers changed after return:
;  ..bc..../ixiy same
;  af..dehl/.... different


	INCLUDE	"graphics/grafix.inc"

                XLIB    stencil_add_pixel
                XDEF	stencil_ptr
                XREF	gfx_area
                XREF	COORDS

.stencil_ptr	defw	0


.stencil_add_pixel
		ld	(COORDS),hl	; update plot coordinates
		ld	d,0
		ld	e,l
		ld	a,h		; current X coordinate
		ld	hl,(stencil_ptr) ; right side vector
		add	hl,de
		
		cp	(hl)
		jr	nc,lo_higher
		ld	(hl),a
.lo_higher
		ld	de,maxy
		add	hl,de

		cp	(hl)
		ret	c	; hi_lower
		ld	(hl),a
		ret

