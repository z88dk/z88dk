        INCLUDE "graphics/grafix.inc"

	SECTION	  code_clib
        PUBLIC    w_respixel

        EXTERN     l_cmp
        EXTERN     w_pixeladdress

        EXTERN    __gfx_coords

;
;       $Id: w_respixl.asm,v 1.5 2016-07-02 09:01:35 dom Exp $
;

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
; registers changed after return:
;  ......../ixiy same
;  afbcdehl/.... different
;
.w_respixel
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
                        
                        ld      (__gfx_coords),hl     ; store Y
                        ld      (__gfx_coords+2),de   ;  store X: COORDS must be 2 bytes wider
                        
                        call    w_pixeladdress
                        ld      b,a
                        ld      a,1
                        jr      z, reset_pixel
.reset_position         rlca
                        djnz    reset_position
.reset_pixel            ex      de,hl
                        cpl
                        and     (hl)
                        ld      (hl),a
                        ret
