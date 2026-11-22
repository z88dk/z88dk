; void __CALLEE__ in_MouseMSX_callee(uchar *buttons, uint *xcoord, uint *ycoord)

    SECTION code_clib
    PUBLIC  in_MouseMSX_callee
    PUBLIC  _in_MouseMSX_callee
    EXTERN  INMouseMSX
    EXTERN  _in_MSXcoordX, _in_MSXcoordY, _in_MSXbuttons

in_MouseMSX_callee:
_in_MouseMSX_callee:
    call    INMouseMSX
    pop     de                          ; return address
    pop     hl                          ; ycoord
    ld      bc, (_in_MSXcoordY)
    ld      (hl), c
    inc     hl
    ld      (hl), b
    pop     hl                          ; xcoord
    ld      bc, (_in_MSXcoordX)
    ld      (hl), c
    inc     hl
    ld      (hl), b
    pop     hl                          ; buttons
    ld      a, (_in_MSXbuttons)
    ld      (hl), a
    ex      de, hl
    jp      (hl)
