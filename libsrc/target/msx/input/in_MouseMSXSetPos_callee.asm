; void __CALLEE__ in_MouseMSXSetPos_callee(uint xcoord, uint ycoord)
; Move the mouse position, limiting it to (255,191).

    SECTION code_clib
    PUBLIC  in_MouseMSXSetPos_callee
    PUBLIC  _in_MouseMSXSetPos_callee
    PUBLIC  asm_in_MouseMSXSetPos
    EXTERN  asm_in_MouseMSXClamp
    EXTERN  _in_MSXcoordX, _in_MSXcoordY

in_MouseMSXSetPos_callee:
_in_MouseMSXSetPos_callee:
    pop     hl
    pop     bc                          ; ycoord
    ex      (sp), hl                    ; hl = xcoord, the return address back on top

; enter : hl = xcoord, bc = ycoord
asm_in_MouseMSXSetPos:
    ld      de, 255
    call    asm_in_MouseMSXClamp
    ld      (_in_MSXcoordX), hl
    ld      h, b
    ld      l, c
    ld      de, 191
    call    asm_in_MouseMSXClamp
    ld      (_in_MSXcoordY), hl
    ret
