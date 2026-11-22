; void __CALLEE__ in_MouseAQPlus_callee(uchar *buttons, uint *xcoord, uint *ycoord)

    SECTION code_clib
    PUBLIC  in_MouseAQPlus_callee
    PUBLIC  _in_MouseAQPlus_callee
    EXTERN  INMouseAQPlus
    EXTERN  _in_AQcoordX, _in_AQcoordY, _in_AQbuttons

in_MouseAQPlus_callee:
_in_MouseAQPlus_callee:
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
    ex      de, hl
    jp      (hl)
