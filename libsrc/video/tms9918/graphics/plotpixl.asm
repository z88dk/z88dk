
        MODULE  __tms9918_plotpixel
        SECTION code_clib
        PUBLIC  __tms9918_plotpixel

        EXTERN  __tms9918_pixeladdress
        EXTERN  __gfx_coords
        EXTERN  __tms9918_pix_return

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
