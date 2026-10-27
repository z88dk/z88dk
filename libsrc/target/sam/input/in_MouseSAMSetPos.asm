; void in_MouseSAMSetPos(uint xcoord, uint ycoord)
; CALLER linkage

    SECTION code_clib
    PUBLIC  in_MouseSAMSetPos
    PUBLIC  _in_MouseSAMSetPos
    EXTERN  asm_in_MouseSAMSetPos

in_MouseSAMSetPos:
_in_MouseSAMSetPos:
    pop     de
    pop     bc                          ; ycoord
    pop     hl                          ; xcoord
    push    hl
    push    bc
    push    de
    jp      asm_in_MouseSAMSetPos
