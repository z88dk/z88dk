;--------------------------------------------------------------
; ZX81 Pseudo - HRG library
; by Stefano Bodrato, Mar. 2020
;--------------------------------------------------------------
;
;	Test pixel at (h,l)
;
;
;	$Id: pointxy.asm $
;

        MODULE  __pseudohrg_pointxy
        SECTION code_clib
        PUBLIC  pointxy

        EXTERN  pixeladdress

        INCLUDE "graphics/grafix.inc"


; ******************************************************************
;
; Check if pixel at        (x,y) coordinate is        set or not.
;  in:        hl =        (x,y) coordinate of pixel to test
; out:        Fz =        0, if pixel is set, otherwise Fz = 1.

.pointxy
        ld      a,h
        cp      maxx
        ret     nc                        ; x0        out of range
		
        ld      a,l
        cp      maxy
        ret     nc                        ; y0        out of range

        push    bc
        push    de
        push    hl

        call    pixeladdress
        ld      b,a
        ld      a,1
        jr      z, test_pixel                ; pixel is at bit 0...
.pixel_position
        rlca
        djnz    pixel_position

.test_pixel
        and     (hl)
        pop     hl
        pop     de
        pop     bc
        ret
