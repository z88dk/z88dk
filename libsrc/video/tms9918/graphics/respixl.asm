
    MODULE __tms9918_respixel
    SECTION code_clib
    PUBLIC  __tms9918_respixel

    EXTERN  __tms9918_pixeladdress
    EXTERN  __gfx_coords
    EXTERN  __tms9918_pix_return
    EXTERN  __tms9918_screen_mode
    EXTERN  __tms9918_pixeladdress3
    EXTERN  __tms9918_pix_return3

    INCLUDE "video/tms9918/vdp.inc"
    INCLUDE "graphics/grafix.inc"

IF VDP_EXPORT_GFX_DIRECT = 1
    PUBLIC  respixel
    defc    respixel = __tms9918_respixel
ENDIF

; in:  hl = (x,y) coordinate of pixel (h,l)
.__tms9918_respixel
    ld      a,(__tms9918_screen_mode)
    cp      3
    jr      z,respixel_mode3
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
    jr      z, reset_pixel
.reset_position
    rlca
    djnz    reset_position
.reset_pixel
    ;ex     de,hl
    cpl
    and     (hl)
    jp      __tms9918_pix_return

respixel_mode3:
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

