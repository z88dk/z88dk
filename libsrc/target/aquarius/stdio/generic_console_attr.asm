
SECTION code_clib
PUBLIC generic_console_set_ink
PUBLIC generic_console_set_paper
PUBLIC generic_console_set_attribute

EXTERN conio_map_colour
EXTERN __aquarius_attr




generic_console_set_ink:
    call    conio_map_colour
    and     15
    rla
    rla
    rla
    rla
    ld      e,a
    ld      a,(__aquarius_attr)
    and     @00001111
    or      e
    ld      (__aquarius_attr),a
generic_console_set_attribute:
    ret


generic_console_set_paper:
    call    conio_map_colour
    and     15
    ld      e,a
    ld      a,(__aquarius_attr)
    and     @11110000
    or      e
    ld      (__aquarius_attr),a
    ret
