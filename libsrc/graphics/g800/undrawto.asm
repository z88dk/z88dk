    SECTION         code_clib

    PUBLIC    undrawto
    PUBLIC    _undrawto

    EXTERN call_unplotpixel
    EXTERN draw_main
    EXTERN last_pos

undrawto:
_undrawto:

    push ix
    ld ix,2
    add ix,sp

    ld de,(last_pos); x0/y0
    ld h,(ix+4); x1
    ld l,(ix+2); y1

    push hl
    push iy
    ld iy,call_unplotpixel
    call draw_main
    pop iy

    pop hl
    ld (last_pos),hl

    pop ix

    ret
