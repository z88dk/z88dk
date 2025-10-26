
    EXTERN  pixeladdress
    EXTERN  __gfx_coords

    INCLUDE "classic/gfx/grafix.inc"

    EXTERN  __mc6847_MODE2_attr

; Generic code to handle the pixel commands
; Define NEEDxxx before including

    ld      a, h
    cp      128
    ret     nc
    ld      a, l
    cp      MC6847_HIRES_YRES
    ret     nc
    ld      (__gfx_coords), hl
    push    bc                          ;Save callers value
    call    pixeladdress                ;hl = address, a = pixel number
    ld      b, a
    ld      a, (__mc6847_MODE2_attr)
    rlca
    rlca
    ld      e, a
    ld      a, @00000011
    jr      z, rotated                  ; pixel is at bit 0...
plot_position:
    rlca
    rlca
    rlc     e
    rlc     e
    djnz    plot_position
rotated:
    ld      b, a                        ;the pixel mask
    cpl
    ld      c, a                        ;the excluded mask
	; e = byte holding pixels to plotwq
	; b = byte holding pixel mask
	; c = byte holding mask exlcuding this pixel
	; hl = address
    ld      a, (hl)
IF  NEEDplot
    and     c
    or      e
    ld      (hl), a
    ;; TODO mc1000
ENDIF
IF  NEEDunplot
    and     c
    ld      (hl), a
ENDIF
IF  NEEDxor
    xor     e
    ld      (hl), a
ENDIF
IF  NEEDpoint
    and     b
ENDIF
    pop     bc                          ;Restore callers
    ret
