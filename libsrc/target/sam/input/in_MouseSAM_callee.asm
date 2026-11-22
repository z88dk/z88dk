; void __CALLEE__ in_MouseSAM_callee(uchar *buttons, uint *xcoord, uint *ycoord)

    SECTION code_clib
    PUBLIC  in_MouseSAM_callee
    PUBLIC  _in_MouseSAM_callee
    EXTERN  INMouseSAM
    EXTERN  _in_SAMcoordX, _in_SAMcoordY, _in_SAMbuttons

in_MouseSAM_callee:
_in_MouseSAM_callee:
    call    INMouseSAM
    pop     de                          ; return address
    pop     hl                          ; ycoord
    ld      bc, (_in_SAMcoordY)
    ld      (hl), c
    inc     hl
    ld      (hl), b
    pop     hl                          ; xcoord
    ld      bc, (_in_SAMcoordX)
    ld      (hl), c
    inc     hl
    ld      (hl), b
    pop     hl                          ; buttons
    ld      a, (_in_SAMbuttons)
    ld      (hl), a
    ex      de, hl
    jp      (hl)
