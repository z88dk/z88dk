IF FORphc25

    SECTION code_driver
    PUBLIC  printc_MODE0
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_plotc
    PUBLIC  generic_console_pointxy
    PUBLIC  __phc25_attr

    EXTERN  __mc6847_MODE2_attr
    EXTERN  mc6847_map_colour
    EXTERN  generic_console_text_xypos

generic_console_set_attribute:
    ld      a, (hl)
    ld      c, 0
    rlca
    rl      c
    ld      a, (__phc25_attr)
    and     254
    or      c
    ld      (__phc25_attr), a
    ret

generic_console_set_ink:
    call    mc6847_map_colour
    ld      a, b
    and     7
    ld      (__ink_colour), a
    ld      b,a
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
    ret


printc_MODE0:
    call    generic_console_text_xypos
    ld      (hl), d
    set     3,h
    ld      a,(__phc25_attr)
    ld      (hl),a
    ret

; Entry point for plotting text graphics
; c = x
; b = y
; a = graphic glyph to print
; e = 0, 2x2 mode, e = 1, 3x2 mode
generic_console_plotc:
    call    generic_console_text_xypos
    ld      c, a
    ld      a, (__ink_colour)
    rrca
    rrca
    and     @11000000
    or      c
    ld      (hl), a
    set     3,h
    ld      a, (__ink_colour)
    and     4                           ;Set the CSS flag as appropriate
    or      @10000010                   ;Indicate graphics mode
    ld      (hl), a
    ret

; Entry point for pointing text graphics
; c = x
; b = y
; Exit: a = graphic glyph
;       nc = found
;        c = not found
generic_console_pointxy:
    call    generic_console_text_xypos
    ld      c, (hl)                     ;glyph
    set     3,h
    bit     1,(hl)
    ld      a, 0                        ;No graphics drawn
    ret     z                           ;Not a graphics character
    ld      a, c
    and     @00111111
    ret


SECTION data_driver

__phc25_attr:
    defb    0x80            ;used to detect a character???

__ink_colour:
    defb    0x00

ENDIF