; void in_MouseMSXSetPos(uint xcoord, uint ycoord)
; CALLER linkage

    SECTION code_clib
    PUBLIC  in_MouseMSXSetPos
    PUBLIC  _in_MouseMSXSetPos
    EXTERN  asm_in_MouseMSXSetPos

in_MouseMSXSetPos:
_in_MouseMSXSetPos:
    pop     de
    pop     bc                          ; ycoord
    pop     hl                          ; xcoord
    push    hl
    push    bc
    push    de
    jp      asm_in_MouseMSXSetPos
