    SECTION         code_clib

    PUBLIC    undraw
    PUBLIC    _undraw

    EXTERN respixel
    EXTERN draw_main
    EXTERN last_pos

undraw:
_undraw:

    push ix
    ld ix,2
    add ix,sp

    ld d,(ix+8); x0
    ld e,(ix+6); y0
    ld h,(ix+4); x1
    ld l,(ix+2); y1

    push hl

    push iy
    ld iy,respixel
    call draw_main
    pop iy

    pop hl
    ld (last_pos),hl

    pop ix

    ret
