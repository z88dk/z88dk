; void __CALLEE__ in_MouseAQPlusSetPos_callee(uint xcoord, uint ycoord)
; Move the mouse position, limiting it to (319,199).

    SECTION code_clib
    PUBLIC  in_MouseAQPlusSetPos_callee
    PUBLIC  _in_MouseAQPlusSetPos_callee
    PUBLIC  asm_in_MouseAQPlusSetPos
    EXTERN  asm_in_MouseAQPlusClamp
    EXTERN  _in_AQcoordX, _in_AQcoordY

in_MouseAQPlusSetPos_callee:
_in_MouseAQPlusSetPos_callee:
    pop     hl
    pop     bc                          ; ycoord
    ex      (sp), hl                    ; hl = xcoord, the return address back on top

; enter : hl = xcoord, bc = ycoord
asm_in_MouseAQPlusSetPos:
    ld      de, 319
    call    asm_in_MouseAQPlusClamp
    ld      (_in_AQcoordX), hl
    ld      h, b
    ld      l, c
    ld      de, 199
    call    asm_in_MouseAQPlusClamp
    ld      (_in_AQcoordY), hl
    ret
