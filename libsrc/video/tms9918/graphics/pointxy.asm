
    MODULE  __tms9918_pointxy
    SECTION code_clib
    PUBLIC  __tms9918_pointxy

    EXTERN  __tms9918_pixeladdress
    EXTERN  __tms9918_screen_mode
    EXTERN  __tms9918_pixeladdress3
    EXTERN  __tms9918_pix_return3
    EXTERN  __gfx_coords

    INCLUDE "video/tms9918/vdp.inc"
    INCLUDE "graphics/grafix.inc"

IF VDP_EXPORT_GFX_DIRECT = 1
    PUBLIC  pointxy
    defc    pointxy = __tms9918_pointxy
ENDIF

;
;        $Id: pointxy.asm,v 1.6 2016-06-21 20:16:35 dom Exp $
;

; ******************************************************************
;
; Check if pixel at        (x,y) coordinate is        set or not.
;  in:        hl =        (x,y) coordinate of pixel to test
; out:        Fz =        0, if pixel is set, otherwise Fz = 1.
.__tms9918_pointxy
    ld      a,(__tms9918_screen_mode)
    cp      3
    jr      z,pointxy_mode3
    cp      2
    ret     nz

    ld      a,l
    cp      192
    ret     nc                        ; y0        out of range

    push    bc
    push    de
    push    hl

    call    __tms9918_pixeladdress
    ld      b,a
    ld      a,1
    jr      z, test_pixel                ; pixel is at bit 0...
.pixel_position
    rlca
    djnz    pixel_position
.test_pixel
    ;ex     de,hl
    and     (hl)
    pop     hl
    pop     de
    pop     bc
    ret

pointxy_mode3:
    ld      a,l
    cp      48
    ret     nc
    ld      a,h
    cp      64
    ret     nc
    ld      (__gfx_coords),hl

    push    bc
    push    de
    push    hl

    call    __tms9918_pixeladdress3
    ;de = VDP address
    ;hl = &pixel byte
    ;b=y, c=x

    ld      b,@11110000
    bit     0,c
    jr      z,done_rotate
    ld      b,@00001111
done_rotate:
    ld      a,(hl)
    and     b
    pop     hl
    pop     de
    pop     bc
    ret









