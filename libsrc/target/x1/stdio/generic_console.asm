        SECTION     code_clib


        PUBLIC      generic_console_set_ink
        PUBLIC      generic_console_set_paper
        PUBLIC      generic_console_set_attribute
        EXTERN      conio_map_colour

        EXTERN      __x1_attr




generic_console_set_attribute:
    ld      a,(__x1_attr)
    and     @01110111
    res     3,a
    bit     7,(hl)
    jr      z,not_inverse
    set     3,a
not_inverse:
    ld      (__x1_attr),a
    ret

generic_console_set_ink:
    call    conio_map_colour
    and     7
    ld      e,a
    ld      a,(__x1_attr)
    and     @11111000
    or      e
    ld      (__x1_attr),a
    ret

; Paper is used for plotting hires
generic_console_set_paper:
    call    conio_map_colour
    and     7
    ld      e,a
    ld      a,(__x1_attr+1)
    and     @11111000
    or      e
    ld      (__x1_attr+1),a
    ret




