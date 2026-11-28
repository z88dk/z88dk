
; Scroll the bitmapped text up by one row (8 pixel rows)

    INCLUDE "target/pc8001/hires/gvram.inc"

    SECTION code_graphics
    PUBLIC  __pc8001_hires_scrollup
    EXTERN  __pc8001_gfxmode
    EXTERN  __pc8001_paper
    EXTERN  __pc8001_hires_mask55
    EXTERN  l_push_di
    EXTERN  l_pop_ei

__pc8001_hires_scrollup:
    push    de
    push    bc
    ld      a, (__pc8001_gfxmode)
    ld      c, 0                        ;fill byte
    cp      2
    jr      nz, got_fill
    ld      a, (__pc8001_paper)
    call    __pc8001_hires_mask55
    ld      c, a
got_fill:
    ld      a, c
    ex      af, af'
    call    l_push_di
    out     ($5c), a                    ;Plane 0
    ld      hl, GVRAM+640
    ld      de, GVRAM
    ld      bc, 640*24
    ldir
    ex      de, hl                      ;hl = the last row
    ld      d, h
    ld      e, l
    inc     de
    ex      af, af'
    ld      (hl), a
    ld      bc, 639
    ldir
    out     ($5f), a                    ;Back to main memory
    call    l_pop_ei
    pop     bc
    pop     de
    ret
