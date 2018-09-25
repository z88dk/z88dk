    SECTION         code_clib

    PUBLIC  drawr
    PUBLIC  _drawr

    EXTERN call_plotpixel
    EXTERN draw_main
    EXTERN last_pos

drawr:
_drawr:
    push ix
    ld ix,2
    add ix,sp

    ld de,(last_pos); x0/y0
    ld h,(ix+4); xr
    ld l,(ix+2); yr

    ld a,h
    add d
    ld h,a

    ld a,l
    add e
    ld l,a

    push hl
    push iy
    ld iy,call_plotpixel
    call draw_main
    pop iy

    pop hl
    ld (last_pos),hl

    pop ix

    ret

