
    SECTION code_driver
    PUBLIC  asm_x1_keyboard_handler

asm_x1_keyboard_handler:
    ld      bc, $1A01
.iiki1
    in      a, (c)
    and     $20
    jr      nz, iiki1
    ld      bc, $1900
    in      a, (c)
    ld      hl, _x1_keyboard_io+1
    ld      (hl), a
    dec     hl
    ld      bc, $1A01
.iiki2	
    in      a, (c)
    and     $20
    jr      nz, iiki2
    ld      bc, $1900
    in      a, (c)
    ld      (hl), a
    ret


    SECTION bss_crt
    PUBLIC  _x1_keyboard_io
   
_x1_keyboard_io:    defw 0
