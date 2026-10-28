; void in_MouseAQPlusSetPos(uint xcoord, uint ycoord)
; CALLER linkage

    SECTION code_clib
    PUBLIC  in_MouseAQPlusSetPos
    PUBLIC  _in_MouseAQPlusSetPos
    EXTERN  asm_in_MouseAQPlusSetPos

in_MouseAQPlusSetPos:
_in_MouseAQPlusSetPos:
    pop     de
    pop     bc                          ; ycoord
    pop     hl                          ; xcoord
    push    hl
    push    bc
    push    de
    jp      asm_in_MouseAQPlusSetPos
