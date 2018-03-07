;
;       Otrona Attachè graphics routines
;		console driven video HW access
;
;       Stefano Bodrato 2018
;
;
;       Plot pixel at (x,y) coordinate.
;
;
;	$Id: w_plotpixel.asm $
;


			INCLUDE	"graphics/grafix.inc"

			SECTION code_clib
			PUBLIC	w_plotpixel

			EXTERN     l_cmp
			EXTERN	GFX_COUT
			EXTERN	div64
			
			EXTERN	__gfx_coords

.w_plotpixel
                        push    hl
                        ld      hl,maxy
                        call    l_cmp
                        pop     hl
                        ret     nc               ; Return if Y overflows
						
                        push    de
                        ld      de,maxx
                        call    l_cmp
                        pop     de
                        ret     c               ; Return if X overflows
                        
                        ld      (__gfx_coords),hl     ; store X
                        ld      (__gfx_coords+2),de   ; store Y: COORDS must be 2 bytes wider
		
						push de
						push hl

						LD 	C,27
						CALL	GFX_COUT
						LD 	C,'0'
						CALL	GFX_COUT

						pop de		; X coordinate
						call div64
						ld	c,e
						CALL	GFX_COUT
						ld	c,d
						CALL	GFX_COUT
						
						pop de		; y coordinate
						
						ld	hl,maxy		; flip vertically
						sbc hl,de
						ex de,hl

						call div64
						ld	c,e
						CALL	GFX_COUT
						ld	c,d
						JP	GFX_COUT
