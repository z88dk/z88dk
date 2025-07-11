
    EXTERN  pixeladdress
    EXTERN  __gfx_coords

    INCLUDE "graphics/grafix.inc"

; Generic code to handle the pixel commands
; Define NEEDxxx before including

    ld      a, l
    cp      MC6847_HIRES_YRES
    ret     nc
    ld      (__gfx_coords), hl
    push    bc                          ;Save callers value
    call    pixeladdress                ;hl = address, a = pixel number
    ld      b, a
    ld      a, 1
    jr      z, rotated                  ; pixel is at bit 0...
plot_position:
    rlca
    djnz    plot_position
	; a = byte holding pixel mask
	; hl = address
rotated:
    ld      c, l
    ld      b, h
    in      l, (c)
IF  NEEDplot
    or      l
    out     (c), a
ENDIF
IF  NEEDunplot
    cpl
    and     l
    out     (c), a
ENDIF
IF  NEEDxor
    xor     l
    out     (c), a
ENDIF
IF  NEEDpoint
    and     l
ENDIF
    pop     bc                          ;Restore callers
    ret
