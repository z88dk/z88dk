
IF !MC6847_IOSPACE


    SECTION code_driver
    PUBLIC  printc_MODE1

    EXTERN  generic_console_udg32
    EXTERN  generic_console_font32
    EXTERN  generic_console_flags


    INCLUDE "video/mc6847/mc6847.inc"

; c = x
; b = y
; a' = d = character to print
; e = raw
printc_MODE1:
IF FORmc1000
    ld      a, (__mc1000_modeval)
    ex      af, af                      ;save port
ENDIF
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
    GETSCREENADDRESS
    add     hl, bc                      ;b = y, c = x
                                        ;hl=screen adddress
                                        

    ld      a, (generic_console_flags)
    rlca
    sbc     a, a
    ld      c, a                        ;x = 0 / 255
    ld      b, 8
hires_printc_1:
    push    bc
    ld      a, (generic_console_flags)
    bit     4, a
    ld      a, (de)
    jr      z, no_32_bold
    rrca
    ld      b,a
    ld      a,(de)
    or      b
 no_32_bold:
    xor     c                           ;Handling inverse
IF FORmc10000
    ld      c, a
    ex      af, af
    res     0, a
    out     ($80), a                    ;VRAM -> Z80
    ld      (hl), c
    set     0, a
    out     ($80), a                    ;VRAM -> Chip
    ex      af, af
ELSE
    ld      (hl),a
ENDIF
    inc     de
    ld      a, l
    add     32
    ld      l, a
    jr      nc, no_overflow
    inc     h
no_overflow:
    pop     bc
    djnz    hires_printc_1
    ld      a, (generic_console_flags)
    bit     3,a                         ;Check underline
    ret     z
    ld      bc, -32
    add     hl, bc
IF FORmc1000
    ex      af, af
    res     0, a
    out     ($80), a                    ;VRAM -> Z80
    ld      (hl), 255
    set     0, a
    out     ($80), a                    ;VRAM -> Chip
ELSE
    ld      (hl), 255
ENDIF
    ret

ENDIF


