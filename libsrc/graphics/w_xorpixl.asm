        INCLUDE "graphics/grafix.inc"

        XLIB    w_xorpixel

        LIB     l_cmp
        LIB     w_pixeladdress

        XREF    coords

;
;       $Id: w_xorpixl.asm,v 1.2 2014-04-18 09:30:31 stefano Exp $
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
.w_xorpixel
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
                        
                        ld      (coords),hl     ; store X
                        ld      (coords+2),de   ; store Y: COORDS must be 2 bytes wider
                        
                        call    w_pixeladdress
                        ld      b,a
                        ld      a,1
                        jr      z,xor_pixel     ; pixel is at bit 0...
.plot_position          rlca
                        djnz    plot_position
.xor_pixel              ex      de,hl
                        xor     (hl)
                        ld      (hl),a
                        ret

