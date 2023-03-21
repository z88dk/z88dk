      
    MODULE __tms9918_xorpixel 
    SECTION code_video_vdp
    PUBLIC  __tms9918_xorpixel
    EXTERN  __gfx_coords

    EXTERN  __tms9918_screen_mode
    EXTERN  __tms9918_pixeladdress
    EXTERN  __tms9918_pix_return
    EXTERN  __tms9918_pixeladdress3
    EXTERN  __tms9918_pix_return3
    EXTERN  __tms9918_attribute


    INCLUDE "video/tms9918/vdp.inc"
    INCLUDE "graphics/grafix.inc"

IF VDP_EXPORT_GFX_DIRECT = 1
    PUBLIC  xorpixel
    defc    xorpixel = __tms9918_xorpixel
ENDIF

.__tms9918_xorpixel
    ld      a,(__tms9918_screen_mode)
    cp      3
    jr      z,xorpixel_mode3
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
    jr      z, xor_pixel                ; pixel is at bit 0...
.plot_position
    rlca
    djnz    plot_position
.xor_pixel
    ;ex     de,hl
    xor     (hl)
    jp      __tms9918_pix_return


xorpixel_mode3:
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







