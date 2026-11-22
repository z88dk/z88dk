; void spc1500_wait_vblank(void)
; Returns at the start of the vertical blank: the 8255's port B bit 7 ($1A01)
; falls (it is high while the picture is drawn).  Waits for the end of a blank
; in progress first.  Each
; wait is bounded (about a second at 4 MHz) in case there is nothing to see.

    SECTION code_clib
    PUBLIC  spc1500_wait_vblank
    PUBLIC  _spc1500_wait_vblank

spc1500_wait_vblank:
_spc1500_wait_vblank:
    ld      bc, $1a01
    ld      de, 0
wv1:
    in      a, (c)
    and     $80
    jr      nz, wv2                     ; high: the picture is being drawn
    dec     de
    ld      a, d
    or      e
    jr      nz, wv1
    ret
wv2:
    ld      de, 0
wv3:
    in      a, (c)
    and     $80
    ret     z                           ; it has fallen
    dec     de
    ld      a, d
    or      e
    jr      nz, wv3
    ret
