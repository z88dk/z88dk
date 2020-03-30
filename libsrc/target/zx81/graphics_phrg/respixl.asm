;--------------------------------------------------------------
; ZX81 Pseudo - HRG library
; by Stefano Bodrato, Mar. 2020
;--------------------------------------------------------------
;
; Reset pixel at (x,y) coordinate.
;
; in:  hl = (x,y) coordinate of pixel (h,l)
;
;
;	$Id: respixl.asm $
;

        MODULE  respixel

        SECTION code_clib
        PUBLIC  respixel

        EXTERN  pixeladdress
        EXTERN  __gfx_coords
        EXTERN  pix_return

        INCLUDE "graphics/grafix.inc"


.respixel
        ld      a,h
        cp      maxx
        ret     nc                        ; x0        out of range
		
        ld      a,l
        cp      maxy
        ret     nc                        ; y0        out of range
                                
        ld      (__gfx_coords),hl

        push    bc
        call    pixeladdress
        ld      b,a
        ld      a,1
        jr      z, reset_pixel                ; pixel is at bit 0...
.reset_position
        rlca
        djnz    reset_position
		pop     bc

.reset_pixel
        cpl
        and     (hl)
        jp      pix_return
