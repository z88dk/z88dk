
        EXTERN pixeladdress
        EXTERN __gfx_coords

        INCLUDE        "graphics/grafix.inc"

        EXTERN        __lviv_paper
        EXTERN        __lviv_ink

; Generic code to handle the pixel commands
; Define NEEDxxx before including

        ld      (__gfx_coords),hl
        push    bc        ;Save callers value
        call    pixeladdress                ;hl = address, a = pixel number
        ld      b,a
IF NEEDunplot
        ld      a,(__lviv_paper)
ELSE
        ld      a,(__lviv_ink)
ENDIF
        ld      e,a
        ld      d,@10001000
        jp      z, rotated         ; pixel is at bit 0...
.plot_position        
        ld      a,e
        and     a
        rrca
        ld      e,a
        ld      a,d
        rrca
        ld      d,a
        dec     b
        jp      nz,plot_position
rotated:
        ld      a,d
        ld      b,d                ;the pixel mask
        cpl
        ld      c,a                ;the excluded mask
        ; e = byte holding pixels to plot
        ; b = byte holding pixel mask
        ; c = byte holding mask excluding this pixel
        ; hl = address
        ld      a,$fd
        out     ($c2),a
        ld      a,(hl)
IF NEEDplot | NEEDunplot
        and     c
        or      e
        ld      (hl),a
ENDIF
IF NEEDxor
        xor     e
        ld      (hl),a
ENDIF
IF NEEDpoint
        and     b
ENDIF
        ld      a,$ff
        out     ($c2),a
        pop     bc                ;Restore callers
        ret
