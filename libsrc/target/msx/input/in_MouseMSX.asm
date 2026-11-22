; void in_MouseMSX(uchar *buttons, uint *xcoord, uint *ycoord)
; CALLER linkage for function pointers
; Read the mouse, returning the buttons 00000MRL (active high) and the position.

    SECTION code_clib
    PUBLIC  in_MouseMSX
    PUBLIC  _in_MouseMSX
    EXTERN  INMouseMSX
    EXTERN  _in_MSXcoordX, _in_MSXcoordY, _in_MSXbuttons

in_MouseMSX:
_in_MouseMSX:
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
    push    hl
    push    hl
    push    hl
    ex      de, hl
    jp      (hl)
