        INCLUDE "graphics/grafix.inc"

        SECTION code_clib
        PUBLIC    w_respixel

        EXTERN     l_graphics_cmp

        EXTERN    __gfx_coords
		EXTERN     w_pixeladdress
        EXTERN     pix_return


; ******************************************************************
;
; Reset pixel at (x,y) coordinate.
;
; Wide resolution (WORD based parameters) version by Stefano Bodrato
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; The (0,0) origin is placed at the top left corner.
;
; in:  hl,de    = (x,y) coordinate of pixel
;

.w_respixel
                        push    hl
                        ld      hl,maxy
                        call    l_graphics_cmp
                        pop     hl
                        ret     nc               ; Return if Y overflows

                        push    de
                        ld      de,maxx
                        call    l_graphics_cmp
                        pop     de
                        ret     c               ; Return if X overflows
                        
                        ld      (__gfx_coords),hl     ; store X
                        ld      (__gfx_coords+2),de   ; store Y: COORDS must be 2 bytes wider
                        
                        call    w_pixeladdress
                        ld      b,a
                        ld      a,1
                        jr      z, or_pixel     ; pixel is at bit 0...
.plot_position          rlca
                        djnz    plot_position
.or_pixel               ex      de,hl
						cpl
                        and      (hl)
                        ld      (hl),a
                        jp		pix_return
