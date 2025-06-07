IF FORsv8000

    PUBLIC  printc_MODE0
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    EXTERN  __mc6847_MODE2_attr
    EXTERN  mc6847_map_colour
    EXTERN  generic_console_text_xypos


generic_console_set_ink:
    call    mc6847_map_colour
    ld      a, b
    rrca
    rrca
    and     @11000000
    ld      (__mc6847_MODE2_attr), a
    ret
generic_console_set_paper:
    call    mc6847_map_colour
    ld      a, b
    rrca
    rrca
    and     @11000000
    ld      (__mc6847_MODE2_attr+1), a
generic_console_set_attribute:
    ret

printc_MODE0:
    call    generic_console_text_xypos
    ld      (hl), a
    ret

ENDIF