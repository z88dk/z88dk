IF FORmc1000

    SECTION code_driver
    PUBLIC  printc_MODE0
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    EXTERN  __mc6847_MODE2_attr
    EXTERN  generic_console_flags
    EXTERN  mc6847_map_colour
    EXTERN  generic_console_text_xypos
    EXTERN  __mc6847_modeval

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


; c = x
; b = y
; a = d = character to print
; e = raw
printc_MODE0:
    ld      a, (__mc6847_modeval)
    out     ($80), a
    ex      af, af
    push    de
    call    generic_console_text_xypos
    pop     de
    rr      e
    call    nc, convert_character
    ld      (hl), d
    ex      af, af
    set     0, a
    out     ($80), a                    ;
    ret

convert_character:
    ld      a, d
    cp      97
    jr      c, isupper
    sub     32
isupper:
    and     @00111111
    ld      d, a
    ld      a, (generic_console_flags)
    rlca
    ret     nc
    set     7, d
    ret



ENDIF