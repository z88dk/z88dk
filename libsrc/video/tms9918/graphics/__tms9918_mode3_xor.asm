      
    MODULE __tms9918_mode3_xor 
    SECTION code_video_vdp
    PUBLIC  __tms9918_mode3_xor
    EXTERN  __gfx_coords

    EXTERN  __tms9918_screen_mode
    EXTERN  __tms9918_pixeladdress3
    EXTERN  __tms9918_pix_return3
    EXTERN  __tms9918_attribute



.__tms9918_mode3_xor
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
    xor     c
    ld      (hl),a
    jp      __tms9918_pix_return3







