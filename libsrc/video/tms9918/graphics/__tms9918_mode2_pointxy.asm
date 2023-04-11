
    MODULE  __tms9918_mode2_pointxy
    SECTION code_video_vdp
    PUBLIC  __tms9918_mode2_pointxy

    EXTERN  __tms9918_pixeladdress
    EXTERN  __tms9918_screen_mode
    EXTERN  __gfx_coords


;
;        $Id: mode2_point.asm,v 1.6 2016-06-21 20:16:35 dom Exp $
;

; ******************************************************************
;
; Check if pixel at        (x,y) coordinate is        set or not.
;  in:        de =        (x,y) coordinate of pixel to test
; out:        Fz =        0, if pixel is set, otherwise Fz = 1.
.__tms9918_mode2_pointxy
    ex      de,hl
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

