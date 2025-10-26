IF FORspc1000

    SECTION code_driver

    PUBLIC  generic_console_pointxy
    PUBLIC  generic_console_plotc
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  printc_MODE0
    PUBLIC  __spc1000_attr

    EXTERN  generic_console_text_xypos
    EXTERN  __tms9918_printc
    EXTERN  __tms9918_set_attribute
    EXTERN  __tms9918_set_ink
    EXTERN  __tms9918_set_paper
    EXTERN  __mc6847_MODE2_attr
    EXTERN  __mc6847_mode
    EXTERN  mc6847_map_colour


generic_console_set_attribute:
    ld      b, a
    ld      a, (hl)
    ld      c, 0
    rlca
    rl      c
    ld      a, (__spc1000_attr)
    and     254
    or      c
    ld      (__spc1000_attr), a
    ld      a, (__mc6847_mode)
    cp      10
    ld      a, b
    jp      z, __tms9918_set_attribute
    ret

generic_console_set_paper:
    push    af
    call    mc6847_map_colour
    ld      a, b
    rrca
    rrca
    and     @11000000
    ld      (__mc6847_MODE2_attr+1), a
    call    set_css
    pop     af
    ld      b, a
    ld      a, (__mc6847_mode)
    cp      10
    ld      a, b
    jp      z, __tms9918_set_paper
    ret

generic_console_set_ink:
    push    af
    call    mc6847_map_colour
    ld      a, b
    and     7
    ld      (__ink_colour), a
    rrca
    rrca
    and     @11000000
    ld      (__mc6847_MODE2_attr), a
    call    set_css
    pop     af
    ld      a, (__mc6847_mode)
    cp      10
    ld      a, b
    jp      z, __tms9918_set_ink
    ret

set_css:
    ld      a, b
    rlca
    rlca
    and     @00000010
    ld      c, a
    ld      a, (__spc1000_attr)
    and     @11111101
    or      c
    ld      (__spc1000_attr), a
    ret


generic_console_pointxy:
    call    generic_console_text_xypos
    ld      c, l
    ld      b, h
    in      l, (c)
    set     3, b
    in      a, (c)
    and     @00011101
    cp      @00011101
    ld      a, 0                        ;No graphics drawn
    ret     nz                          ;Not a graphics character
    ld      a, l
    and     @00111111
    ret


generic_console_plotc:
    call    generic_console_text_xypos
    ld      c, l
    ld      b, h
    ld      l, a
    ld      a, (__mc6847_MODE2_attr)           ;It's shifted for us
    and     @11000000
    or      l
    out     (c), a
    set     3, b
    ld      a, (__ink_colour)
    rrca
    and     2                           ;Set the CSS flag as appropriate
    or      @00011101                   ;3x2, CSS not set
    out     (c), a
    ret

; c = x
; b = y
; d = character to print
; a = screen mode
; e = raw
printc_MODE0:
    cp      10
    ld      a,d
    jp      z,__tms9918_printc

print_text:
    ld      a,d
    call    generic_console_text_xypos
    ld      c, l
    ld      b, h
    cp      $60
    jr      c, hardware_chars
	; We do something with characters > 0xe0 here
    cp      $e0
    jr      nc, high_chars
    and     $7f
    out     (c), a
    ld      a, (__spc1000_attr)
    and     3
    or      8
write_attr:
    set     3, b
    out     (c), a
    ret
high_chars:
    and     $f
    ld      d, a
    ld      a, (__spc1000_attr)
    dec     a
    and     7
    rlca
    rlca
    rlca
    rlca
    or      d
    out     (c), a
    ld      a, (__spc1000_attr)
    or      4
    jr      write_attr

hardware_chars:
    out     (c), a
    ld      a, (__spc1000_attr)
    jr      write_attr


    SECTION data_clib

__spc1000_attr:
    defb    0
__ink_colour:
    defb    7



ENDIF