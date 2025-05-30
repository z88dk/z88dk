
    SECTION code_graphics

    PUBLIC  respixel

    EXTERN  sety
    EXTERN  setx
    EXTERN  getpat

    INCLUDE "graphics/grafix.inc"

    EXTERN  __gfx_coords

; in: hl=(x,y)
respixel:

    ld      a, h
    cp      maxx
    ret     nc

    ld      a, l
    cp      maxy
    ret     nc                       ; y0 out of range

    ld      (__gfx_coords), hl

    push    af
    push    bc
    exx
    push    bc
    exx
    push    hl

    call    sety
    call    getpat
    ld      a, d
    cpl
    ld      d, a
    call    setx
	
    in      a, (c)                   ;dummy read
    in      a, (c)                   ;read data
    and     d
    call    setx                     ; to prevent automatic increment of lcd driver
    exx
    out     (c), a                   ;write data
    exx

    pop     hl
    exx
    pop     bc
    exx
    pop     bc
    pop     af
    ret
