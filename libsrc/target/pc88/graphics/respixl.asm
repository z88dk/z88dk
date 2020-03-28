; NEC PC8001 graphics library, by @Stosstruppe
; Adapted to z88dk by Stefano Bodrato, 2018
;
;
;       Erase pixel at (x,y) coordinate.
;
;
;	$Id:$
;


		INCLUDE	"graphics/grafix.inc"

		SECTION code_clib

		PUBLIC	respixel

		EXTERN	__gfx_coords
		EXTERN	pcalc


.respixel			
		ld	a,h
		cp	maxx
		ret	nc
		ld	a,l
		cp	maxy
		ret	nc		; y0	out of range
		ld	(__gfx_coords),hl

        call    pcalc
		cpl
		and     (hl)
        ld      (hl), a
        ret
