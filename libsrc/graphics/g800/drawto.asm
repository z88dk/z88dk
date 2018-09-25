    SECTION         code_clib

    PUBLIC    drawto
    PUBLIC    _drawto

    EXTERN call_plotpixel
    EXTERN draw_main
    EXTERN last_pos

drawto:
_drawto:

    push ix
    ld ix,2
    add ix,sp

    ld de,(last_pos); x0/y0
    ld h,(ix+4); x1
    ld l,(ix+2); y1

    push hl
    push iy
    ld iy,call_plotpixel
    call draw_main
    pop iy

    pop hl
    ld (last_pos),hl

    pop ix

    ret
