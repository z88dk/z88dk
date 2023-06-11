
    MODULE  __tms9918_mode2_plot
    SECTION code_video_vdp
    PUBLIC  __tms9918_mode2_plot

    EXTERN  __gfx_coords

    EXTERN  __tms9918_pixeladdress
    EXTERN  __tms9918_pix_return



; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; in:  de = (x,y) coordinate of pixel (h,l)

.__tms9918_mode2_plot
    ex      de,hl
    ld      a,l
    cp      192 
    ret     nc                        ; y0        out of range
                            
    ld      (__gfx_coords),hl

    push    bc
    call    __tms9918_pixeladdress
    ld      b,a
    ld      a,1
    jr      z, or_pixel                ; pixel is at bit 0...
.plot_position
    rlca
    djnz    plot_position
.or_pixel
    or      (hl)
    jp      __tms9918_pix_return

