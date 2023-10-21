        INCLUDE "graphics/grafix.inc"

        SECTION code_graphics
        PUBLIC  pointxy

        EXTERN  pixeladdress

;
;    $Id: pointxy.asm $
;

; ******************************************************************
;
; Check if pixel at    (x,y) coordinate is    set or not.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; (0,0) origin is defined as the top left corner.
;
;  in:    hl =    (x,y) coordinate of pixel to test
; out:    Fz =    0, if pixel is set, otherwise Fz = 1.
;
; registers changed    after return:
;  ..bcdehl/ixiy same
;  af....../.... different
;
pointxy:
        push    bc
        push    de
        push    hl

        call    pixeladdress
        ld      b, a
        ld      a, 1
        jr      z, test_pixel           ; pixel is at bit 0...
pixel_position:
        rlca
        djnz    pixel_position
test_pixel:
        ex      de, hl
        and     (hl)
        pop     hl
        pop     de
        pop     bc
        ret
