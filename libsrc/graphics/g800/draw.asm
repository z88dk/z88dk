    SECTION         code_clib

    PUBLIC    draw
    PUBLIC    _draw

    EXTERN plotpixel
    EXTERN draw_main
    EXTERN last_pos

draw:
_draw:

    push ix
    ld ix,2
    add ix,sp

    ld d,(ix+8); x0
    ld e,(ix+6); y0
    ld h,(ix+4); x1
    ld l,(ix+2); y1

    push hl

    push iy
    ld iy,plotpixel
    call draw_main
    pop iy

    pop hl
    ld (last_pos),hl

    pop ix

    ret


