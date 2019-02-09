
        MODULE __tms9918_respixel
        SECTION code_clib
        PUBLIC  __tms9918_respixel

        EXTERN  __tms9918_pixeladdress
        EXTERN  __gfx_coords
        EXTERN  __tms9918_pix_return

        INCLUDE "video/tms9918/vdp.inc"
        INCLUDE "graphics/grafix.inc"

IF VDP_EXPORT_GFX_DIRECT = 1
        PUBLIC  respixel
        defc    respixel = __tms9918_respixel
ENDIF

; in:  hl = (x,y) coordinate of pixel (h,l)
.__tms9918_respixel
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
