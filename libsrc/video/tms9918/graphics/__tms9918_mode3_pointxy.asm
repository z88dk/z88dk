
    MODULE  __tms9918_mode3_pointxy
    SECTION code_video_vdp
    PUBLIC  __tms9918_mode3_pointxy

    EXTERN  __tms9918_pixeladdress3
    EXTERN  __tms9918_pix_return3
    EXTERN  __gfx_coords


; ******************************************************************
;
; Check if pixel at        (x,y) coordinate is        set or not.
;  in:        de =        (x,y) coordinate of pixel to test
; out:        Fz =        0, if pixel is set, otherwise Fz = 1.
.__tms9918_mode3_pointxy
    ex      de,hl
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









