      
    MODULE __tms9918_mode2_xor 
    SECTION code_video_vdp
    PUBLIC  __tms9918_mode2_xor
    EXTERN  __gfx_coords

    EXTERN  __tms9918_pixeladdress
    EXTERN  __tms9918_pix_return


.__tms9918_mode2_xor
    ex      de,hl
    ld      a,l
    cp      192 
    ret     nc                        ; y0        out of range
                            
    ld      (__gfx_coords),hl

    push    bc
    call    __tms9918_pixeladdress
    ld      b,a
    ld      a,1
    jr      z, xor_pixel                ; pixel is at bit 0...
.plot_position
    rlca
    djnz    plot_position
.xor_pixel
    ;ex     de,hl
    xor     (hl)
    jp      __tms9918_pix_return


