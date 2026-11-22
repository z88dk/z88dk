; void in_MouseSAM(uchar *buttons, uint *xcoord, uint *ycoord)
; CALLER linkage for function pointers
; Read the mouse, returning the buttons 00000MRL (active high) and the position.

    SECTION code_clib
    PUBLIC  in_MouseSAM
    PUBLIC  _in_MouseSAM
    EXTERN  INMouseSAM
    EXTERN  _in_SAMcoordX, _in_SAMcoordY, _in_SAMbuttons

in_MouseSAM:
_in_MouseSAM:
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
    push    hl
    push    hl
    push    hl
    ex      de, hl
    jp      (hl)
