
    MODULE  __tms9918_plotpixel
    SECTION code_clib
    PUBLIC  __tms9918_plotpixel

    EXTERN  __gfx_coords
    EXTERN  __tms9918_attribute
    EXTERN  __tms9918_screen_mode

    EXTERN  __tms9918_pixeladdress
    EXTERN  __tms9918_pix_return

    EXTERN  __tms9918_pixeladdress3
    EXTERN  __tms9918_pix_return3

    INCLUDE "graphics/grafix.inc"
    INCLUDE "video/tms9918/vdp.inc"

IF VDP_EXPORT_GFX_DIRECT = 1
    PUBLIC  plotpixel
    defc    plotpixel = __tms9918_plotpixel
ENDIF


; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; in:  hl = (x,y) coordinate of pixel (h,l)

.__tms9918_plotpixel
    ld      a,(__tms9918_screen_mode)
    cp      3
    jr      z,plotpixel_mode3
    cp      2
    ret     nz

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
    ;ex     de,hl
    or      (hl)
    jp      __tms9918_pix_return

plotpixel_mode3:
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








