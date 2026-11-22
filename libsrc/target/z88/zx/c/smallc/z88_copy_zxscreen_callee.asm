
    MODULE z88_copy_zxscreen_callee
    SECTION code_graphics

    PUBLIC  z88_copy_zxscreen_callee
    PUBLIC  _z88_copy_zxscreen_callee

    EXTERN  asm_z88_copy_zxscreen


; z88_copy_zxscreen(int centre_y, uint8_t flags)
z88_copy_zxscreen_callee:
_z88_copy_zxscreen_callee:
    pop     af
    pop     de
    pop     hl
    push    af
    ld      d,l     ;y position
    jp      asm_z88_copy_zxscreen
 