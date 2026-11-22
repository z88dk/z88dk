;
; Console colours (conio colours, or the pens if CLIB_CONIO_NATIVE_COLOUR is set).  Inverse is read from generic_console_flags when a character is drawn.
;
    SECTION code_clib
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    EXTERN  conio_map_colour
    EXTERN  __mz800_con_ink
    EXTERN  __mz800_con_paper

generic_console_set_ink:
    call    conio_map_colour
    and     3
    ld      (__mz800_con_ink), a
    ret

generic_console_set_paper:
    call    conio_map_colour
    and     3
    ld      (__mz800_con_paper), a
    ret

generic_console_set_attribute:
    ret
