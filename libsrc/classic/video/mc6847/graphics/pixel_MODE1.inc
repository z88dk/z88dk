
    EXTERN  pixeladdress
    EXTERN  __gfx_coords
    EXTERN  pix_return

    INCLUDE "classic/gfx/grafix.inc"

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
    ld      c, (hl)
IF  NEEDplot
    or      c
  IF FORmc1000
    call    pix_return
  ELSE
    ld      (hl), a
  ENDIF
ENDIF
IF  NEEDunplot
    cpl
    and     c
  IF FORmc1000
    call    pix_return
  ELSE
    ld      (hl), a
  ENDIF
ENDIF
IF  NEEDxor
    xor     c
  IF FORmc1000
    call    pix_return
  ELSE
    ld      (hl), a
  ENDIF
ENDIF
IF  NEEDpoint
    and     c
ENDIF
    pop     bc                          ;Restore callers
    ret
