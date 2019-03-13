      
        MODULE __tms9918_xorpixel 
        SECTION code_clib
        PUBLIC  __tms9918_xorpixel

        EXTERN  __tms9918_pixeladdress
        EXTERN  __gfx_coords
        EXTERN  __tms9918_pix_return

        INCLUDE "video/tms9918/vdp.inc"
        INCLUDE "graphics/grafix.inc"

IF VDP_EXPORT_GFX_DIRECT = 1
        PUBLIC  xorpixel
        defc    xorpixel = __tms9918_xorpixel
ENDIF

.__tms9918_xorpixel
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
