;
;       Aussie Byte graphics library
;
;	by Stefano Bodrato  - 2016

        INCLUDE "graphics/grafix.inc"

        SECTION code_clib
        PUBLIC    w_plotpixel

        EXTERN     l_cmp
        EXTERN     w_pixeladdress
		EXTERN     pchar

        EXTERN    __gfx_coords

;
;       $Id: w_plotpixl.asm,v 1.1 2016-11-17 09:39:03 stefano Exp $
;

; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; Wide resolution (WORD based parameters) version by Stefano Bodrato
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; The (0,0) origin is placed at the top left corner.
;
; in:  hl,de    = (x,y) coordinate of pixel
;
; registers changed after return:
;  ......../ixiy same
;  afbcdehl/.... different
;
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
                        
                        call    w_pixeladdress
						ld		c,a	;;;
                        ;ld      b,a
                        ld      a,1
                        jr      z, or_pixel     ; pixel is at bit 0...
.plot_position          rlca
                        djnz    plot_position
.or_pixel               or		c
						jp		pchar

