
    MODULE __tms9918_mode2_res
    SECTION code_video_vdp
    PUBLIC  __tms9918_mode2_res

    EXTERN  __tms9918_pixeladdress
    EXTERN  __gfx_coords
    EXTERN  __tms9918_pix_return


; in:  de = (x,y) coordinate of pixel (h,l)
.__tms9918_mode2_res
    ex      de,hl
    ld      a,l
    cp      192
    ret     nc                        ; y0        out of range
                            
    ld      (__gfx_coords),hl

    push    bc
    call    __tms9918_pixeladdress
    ld      b,a
    ld      a,1
    jr      z, reset_pixel
.reset_position
    rlca
    djnz    reset_position
.reset_pixel
    ;ex     de,hl
    cpl
    and     (hl)
    jp      __tms9918_pix_return

