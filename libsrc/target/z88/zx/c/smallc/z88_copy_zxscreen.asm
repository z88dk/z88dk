
    MODULE z88_copy_zxscreen
    SECTION code_graphics

    PUBLIC  z88_copy_zxscreen
    PUBLIC  _z88_copy_zxscreen

    EXTERN  asm_z88_copy_zxscreen


; z88_copy_zxscreen(int centre_y, uint8_t flags)
z88_copy_zxscreen:
_z88_copy_zxscreen:
    pop     af
    pop     de
    pop     hl
    push    hl
    push    de
    push    af
    ld      d,l     ;y position
    jp      asm_z88_copy_zxscreen
 