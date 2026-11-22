
    EXTERN  __x07_mode1_dirty
    EXTERN  __gfx_coords
    EXTERN  pixladdr_MODE1
    EXTERN  div3
    INCLUDE "classic/gfx/grafix.inc"

; Generic code to handle the pixel commands
; Define NEEDxxx before including

    ld      a, l
    cp      32
    ret     nc
    ld      a,h
    cp      128
    ret     nc
    ld      (__gfx_coords), hl
    push    bc                          ;Save callers value
    call    pixladdr_MODE1              ;hl = address, a = pixel number
    ld      b, a
    ld      a, 1
    jr      z, rotated                  ; pixel is at bit 0...
plot_position:
    rlca
    djnz    plot_position
        ; a = byte holding pixel mask
        ; hl = address
rotated:
IF  NEEDunplot
    cpl
    and     (hl)
    ld      (hl), a
ENDIF
IF  NEEDplot
    or      (hl)
    ld      (hl), a
ENDIF
IF  NEEDxor
    ld      c, a
    ld      a, (hl)
    xor     c
    ld      (hl), a
ENDIF
IF  NEEDpoint
    ld      c, a
    ld      a, (hl)
    and     c
ELSE
    ; Mark dirty if we modified
    ld      hl,(__gfx_coords)
    ld      a,l
    rrca
    rrca
    rrca
    and     3
    add     a   ;*2
    add     a   ;*4
    ld      l,a
    add     a   ;*8
    add     a   ;*16
    add     l   ;*20
    ld      e,a

    ld      a,h
    defb    0xcb, 0x3f      ;srl a  x/2
    add     +(div3 % 256)
    ld      l,a
    ld      a,+(div3 / 256)
    adc     0
    ld      h,a
    ld      a,(hl)          ;x / 6
    add     e
    ld      l,a
    ld      h,0
    ld      de,__x07_mode1_dirty
    add     hl,de
    ld      (hl),1
ENDIF
    pop     bc                          ;Restore callers
    ret