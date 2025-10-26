IF FORvz

    SECTION code_driver

    PUBLIC  generic_console_plotc
    PUBLIC  printc_MODE0
    PUBLIC  generic_console_pointxy
    EXTERN  __mc6847_mode
    EXTERN  __mc6847_MODE2_attr
    EXTERN  generic_console_text_xypos
    EXTERN  colour_mask
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    EXTERN  mc6847_map_colour
    EXTERN  generic_console_vpeek


generic_console_set_paper:
    call    mc6847_map_colour
    ld      a, b
    rrca
    rrca
    and     @11000000
    ld      (__mc6847_MODE2_attr+1), a
generic_console_set_attribute:
    ret

generic_console_set_ink:
    call    mc6847_map_colour
    ld      a, b
    rlca
    rlca
    rlca
    rlca
    or      128
    and     @11110000
    ld      (colour_mask), a
    ld      a, b
    rrca
    rrca
    and     @11000000
    ld      (__mc6847_MODE2_attr), a
    ret



; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_plotc:
    ld      e, 1
printc_MODE0:
    ld      a,d
    call    generic_console_text_xypos
    rr      e
    call    nc, convert_character
    cp      128
    jr      c, place_character
    and     @10001111
    ld      c, a
    ld      a, (colour_mask)
    or      c
place_character:
    ld      (hl), a
    ret


generic_console_pointxy:
    call    generic_console_vpeek
    and     @10001111
    ret

convert_character:
    cp      97
    jr      c, isupper
    sub     32
isupper:
    and     @00111111
    ret


    SECTION bss_clib

colour_mask:
    defb    0

ENDIF