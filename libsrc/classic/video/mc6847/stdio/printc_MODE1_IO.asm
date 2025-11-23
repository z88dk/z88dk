;
;

    INCLUDE "classic/video/mc6847/mc6847.inc"

IFDEF MC6847_IOSPACE

    SECTION code_driver

    PUBLIC  printc_MODE1

    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  generic_console_flags

printc_MODE1:
    ld      l, d
    ld      h, 0
    ld      de, (generic_console_font32)
    bit     7, l
    jr      z, not_udg
    res     7, l
    ld      de, (generic_console_udg32)
    inc     d
not_udg:
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, de
    dec     h
    ex      de, hl                      ;de = font
	; bc is already set

	; Set up the inverse state
    ld      a, (generic_console_flags)
    rlca
    sbc     a, a                        ; So 0 / 255
    ld      h, a

    ld      l, 8
hires_printc_1:
    push    hl
    ld      a, (generic_console_flags)
    bit     4, a
    ld      a, (de)
    jr      z, no_32_bold
    rrca
    ld      l,a
    ld      a,(de)
    or      l
 no_32_bold:
    xor     h
    out     (c), a
    ld      a, c
    add     32
    ld      c, a
    jr      nc, no_overflow
    inc     b
no_overflow:
    inc     de
    pop     hl
    dec     l
    jr      nz, hires_printc_1

    ; Check for underline
    ld      a, (generic_console_flags)
    bit     3,a                         ;Check underline
    ret     z
    ld      hl, -32
    add     hl, bc
    ld      bc,hl
    ld      a,255
    out     (c),a
    ret

ENDIF


