
    SECTION code_clib
    PUBLIC  joystick
    PUBLIC  _joystick
    EXTERN  joystick_sc
    EXTERN  keys_qaop
    EXTERN  keys_vi
    EXTERN  keys_8246
    EXTERN  keys_cursor

joystick:
_joystick:
    ld      a, l
    ld      hl, keys_qaop
    cp      1
    jp      z, joystick_sc
    ld      hl, keys_8246
    cp      2
    jp      z, joystick_sc
    ld      hl, keys_vi
    cp      3
    jp      z, joystick_sc
    ld      hl, keys_cursor
    cp      4
    jp      z, joystick_sc
    ld      hl, 0
    ret
