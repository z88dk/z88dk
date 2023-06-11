
    MODULE  __tms9918_mode3_plot
    SECTION code_video_vdp
    PUBLIC  __tms9918_mode3_plot

    EXTERN  __gfx_coords
    EXTERN  __tms9918_attribute
    EXTERN  __tms9918_screen_mode


    EXTERN  __tms9918_pixeladdress3
    EXTERN  __tms9918_pix_return3


; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; in:  de = (x,y) coordinate of pixel (h,l)

.__tms9918_mode3_plot
    ex      de,hl
    ld      a,l
    cp      48
    ret     nc
    ld      a,h
    cp      64
    ret     nc
    ld      (__gfx_coords),hl
    push    bc
    call    __tms9918_pixeladdress3
    ;de = VDP address
    ;hl = &pixel byte
    ;b=y, c=x

    ld      a,(__tms9918_attribute)
    and     @11110000
    ld      b,@00001111
    bit     0,c
    jr      z,done_rotate
    rrca
    rrca
    rrca
    rrca
    and     b
    ld      b,@11110000
done_rotate:
    ld      c,a
    ld      a,(hl)
    and     b
    or      c
    ld      (hl),a
    jp      __tms9918_pix_return3








