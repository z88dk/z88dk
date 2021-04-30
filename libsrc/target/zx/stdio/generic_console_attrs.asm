    MODULE generic_console_attrs

    SECTION code_driver
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    EXTERN  conio_map_colour

    EXTERN   __zx_console_attr
IF FORzxn
    EXTERN  __zx_ink_colour
ENDIF
IF FORsam
    EXTERN  __sam_MODE4_attr
    EXTERN  __sam_MODE3_attr
ENDIF


generic_console_set_paper:
IF FORsam
    ; For SAM modes, we don't do any mapping
    ld      c,a     ;Save it for a moment
    rrca
    rrca
    rrca
    rrca
    and     0xf0
    ld      (__sam_MODE4_attr+1),a
    rlca
    rlca
    and     @11000000
    ld      (__sam_MODE3_attr+1),a
    ld      a,c
ENDIF
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
IF FORsam
    ; For SAM modes, we don't do any mapping
    ld      c,a     ;Save it for a moment
    rrca
    rrca
    rrca
    rrca
    and     0xf0
    ld      (__sam_MODE4_attr+0),a
    rlca
    rlca
    and     @11000000
    ld      (__sam_MODE3_attr+0),a
    ld      a,c
ENDIF
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
