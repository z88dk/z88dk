
    MODULE __tms9918_mode3_res
    SECTION code_video_vdp
    PUBLIC  __tms9918_mode3_res

    EXTERN  __gfx_coords
    EXTERN  __tms9918_pixeladdress3
    EXTERN  __tms9918_pix_return3


; in:  de = (x,y) coordinate of pixel (h,l)
.__tms9918_mode3_res
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

    ld      b,@11110000
    bit     0,c
    jr      nz,done_rotate
    ld      b,@00001111
done_rotate:
    ld      a,(hl)
    and     b
    ld      (hl),a
    jp      __tms9918_pix_return3

