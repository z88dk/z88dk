; void __CALLEE__ in_MouseSAMSetPos_callee(uint xcoord, uint ycoord)
; Move the mouse position, limiting it to (255,191).

    SECTION code_clib
    PUBLIC  in_MouseSAMSetPos_callee
    PUBLIC  _in_MouseSAMSetPos_callee
    PUBLIC  asm_in_MouseSAMSetPos
    EXTERN  _in_SAMcoordX, _in_SAMcoordY

in_MouseSAMSetPos_callee:
_in_MouseSAMSetPos_callee:
    pop     hl
    pop     bc                          ; ycoord
    ex      (sp), hl                    ; hl = xcoord, the return address back on top

; enter : hl = xcoord, bc = ycoord
asm_in_MouseSAMSetPos:
    ld      a, h
    or      a
    jr      z, x_ok
    ld      l, 255
x_ok:
    ld      h, 0
    ld      (_in_SAMcoordX), hl
    ld      a, b
    or      a
    jr      nz, y_big
    ld      a, c
    cp      192
    jr      c, y_ok
y_big:
    ld      c, 191
y_ok:
    ld      b, 0
    ld      (_in_SAMcoordY), bc
    ret
