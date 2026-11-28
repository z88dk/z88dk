
; Clear the graphics planes in the mkII hires modes

    INCLUDE "target/pc8001/hires/gvram.inc"
    INCLUDE "target/pc8001/hires/allram_only.inc"

    SECTION code_driver
    PUBLIC  __pc8001_hires_cls
    EXTERN  l_push_di
    EXTERN  l_pop_ei

__pc8001_hires_cls:
    call    l_push_di
    xor     a
    out     ($5c), a                    ;Plane 0
    call    clear_plane
    out     ($5d), a                    ;Plane 1
    call    clear_plane
    out     ($5e), a                    ;Plane 2
    call    clear_plane
    out     ($5f), a                    ;Back to main memory
    call    l_pop_ei
    ret

clear_plane:
    ld      hl, GVRAM
    ld      de, GVRAM+1
    ld      bc, 15999                   ;80 * 200 - 1
    ld      (hl), a
    ldir
    ret
