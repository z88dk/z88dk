    MODULE generic_console_attrs

    SECTION code_clib
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    EXTERN  conio_map_colour

    EXTERN   __zx_console_attr
IF FORzxn
    EXTERN  __zx_ink_colour
ENDIF


generic_console_set_paper:
    ; TODO: SAM mapping
    call    conio_map_colour
    rlca
    rlca
    rlca
    and     @00111000
    ld      c,a
    ld      hl,__zx_console_attr
    ld      a,(hl)
    and     @11000111
    or      c
    ld      (hl),a
generic_console_set_attribute:
    ret

generic_console_set_ink:
    ; TODO: SAM mapping
IF FORzxn
    ld      (__zx_ink_colour),a
ENDIF
    call    conio_map_colour
    and     7
    ld      c,a
    ld      hl,__zx_console_attr
    ld      a,(hl)
    and     @11111000
    or      c
    ld      (hl),a
    ret
