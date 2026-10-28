; void in_MouseAQPlus(uchar *buttons, uint *xcoord, uint *ycoord)
; CALLER linkage for function pointers
; Read the mouse, returning the buttons 00000MRL (active high) and the position.

    SECTION code_clib
    PUBLIC  in_MouseAQPlus
    PUBLIC  _in_MouseAQPlus
    EXTERN  INMouseAQPlus
    EXTERN  _in_AQcoordX, _in_AQcoordY, _in_AQbuttons

in_MouseAQPlus:
_in_MouseAQPlus:
    call    INMouseAQPlus
    pop     de                          ; return address
    pop     hl                          ; ycoord
    ld      bc, (_in_AQcoordY)
    ld      (hl), c
    inc     hl
    ld      (hl), b
    pop     hl                          ; xcoord
    ld      bc, (_in_AQcoordX)
    ld      (hl), c
    inc     hl
    ld      (hl), b
    pop     hl                          ; buttons
    ld      a, (_in_AQbuttons)
    ld      (hl), a
    push    hl
    push    hl
    push    hl
    ex      de, hl
    jp      (hl)
