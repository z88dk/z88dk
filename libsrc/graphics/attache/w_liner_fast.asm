        INCLUDE "graphics/grafix.inc"

        SECTION code_clib
        PUBLIC    w_line_r_fast
        
			EXTERN	GFX_COUT
			EXTERN	div64
			
			EXTERN	__gfx_coords

;
;       $Id: w_liner_fast.asm $
;

; ******************************************************************************
;
;       Draw a pixel line from (x0,y0) defined in (COORDS) - the current plot
;       coordinate, to the relative distance points (x0+x,y0+y).
;

;       ------------------------------------------

.w_line_r_fast

                push    de
                ex		de,hl
				ld 		hl,(__gfx_coords)
				add		hl,de
				ld		(__gfx_coords),hl
				
				pop		hl
				ld		de,(__gfx_coords+2)
				add		hl,de
				ld		(__gfx_coords+2),hl
				

						LD 	C,27
						CALL	GFX_COUT
						LD 	C,'1'
						CALL	GFX_COUT

						ld de,(__gfx_coords)		; X coordinate
						call div64
						ld	c,e
						CALL	GFX_COUT
						ld	c,d
						CALL	GFX_COUT
						
                        ld      hl,maxy-1
						ld de,(__gfx_coords+2)		; Y coordinate
						sbc hl,de
						ex	de,hl

						call div64
						ld	c,e
						CALL	GFX_COUT
						ld	c,d
						JP	GFX_COUT

