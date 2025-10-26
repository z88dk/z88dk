
IF FORpc6001

    SECTION code_driver
    PUBLIC  printc_MODE0
    PUBLIC  generic_console_plotc
    PUBLIC  generic_console_pointxy
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  __pc6001_attr


    EXTERN  generic_console_text_xypos
    EXTERN  __mc6847_MODE2_attr
    EXTERN  mc6847_map_colour

generic_console_set_attribute:
    ld      a, (hl)
    ld      c, 0
    rlca
    rl      c
    ld      a, (__pc6001_attr)
    and     254
    or      c
    ld      (__pc6001_attr), a
    ret

generic_console_set_ink:
    call    mc6847_map_colour
    ld      a, b
    and     7
    ld      (__ink_colour), a
    rrca
    rrca
    and     @11000000
    ld      (__mc6847_MODE2_attr), a
set_css:
    ld      a, b
    rlca
    rlca
    and     @00000010
    ld      c, a
    ld      a, (__pc6001_attr)
    and     @11111101
    or      c
    ld      (__pc6001_attr), a
    ret


generic_console_set_paper:
    call    mc6847_map_colour
    ld      a, b
    rrca
    rrca
    and     @11000000
    ld      (__mc6847_MODE2_attr+1), a
    jr      set_css


printc_MODE0:
    ld      a,d
    call    generic_console_text_xypos
    ld      (hl), a
    dec     h
    dec     h
    ld      a, (__pc6001_attr)
    ld      (hl), a
    ret


; Entry point for plotting text graphics
; c = x
; b = y
; a = graphic glyph to print
; e = 0, 2x2 mode, e = 1, 3x2 mode
generic_console_plotc:
    call    generic_console_text_xypos
    ld      c, a
    ld      a, (__mc6847_MODE2_attr)           ;It's shifted for us
    and     @11000000
    or      c
    ld      (hl), a
    dec     h
    dec     h
    ld      a, (__ink_colour)
    rrca
    and     2                           ;Set the CSS flag as appropriate
    or      @01111101                   ;3x2, CSS not set
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
    dec     h
    dec     h
    ld      a, (hl)
    and     @01111101
    cp      @01111101
    ld      a, 0                        ;No graphics drawn
    ret     nz                          ;Not a graphics character
    ld      a, c
    and     @00111111
    ret


    SECTION data_clib
__pc6001_attr:
    defb    32                          ;We use the external character generator

__ink_colour:
    defb    7


ENDIF