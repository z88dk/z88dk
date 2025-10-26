    INCLUDE "classic/video/mc6847/mc6847.inc"

IFNDEF MC6847_IOSPACE

    SECTION     code_driver

    PUBLIC      generic_console_scrollup

    EXTERN      __mc6847_mode
    EXTERN      __pc6001_attr
    EXTERN      __phc25_attr
    EXTERN      __mc6847_modeval
    EXTERN      __tms9918_cls


generic_console_scrollup:
    push    de
    push    bc
    ld      a, (__mc6847_mode)
    and     a
    jr      z, scrollup_text
IF MC6847_HAS_HIRES
    cp      1
    jr      z, scrollup_hires
ENDIF
IF MC6847_HAS_CG
    cp      2
    jr      z, scrollup_hires           ;possibly wrong
ENDIF
IF FORspc1000
    cp      10
    jp      z,__tms9918_cls
ENDIF
    pop     bc
    pop     de
    ret


scrollup_text:
    GETSCREENADDRESS
IF FORmc1000
    ld      a,(__mc6847_modeval)
    out     ($80),a
    ex      af,af
ENDIF
    ld      l, MC6847_CONSOLE_COLUMNS
    ld      d, h
    ld      e, 0
    push    hl                          ; Save start of screen
    ld      bc, +((MC6847_CONSOLE_COLUMNS)*(MC6847_CONSOLE_ROWS-1))
    ldir
    ex      de, hl
    ld      b, MC6847_CONSOLE_COLUMNS
generic_console_scrollup_3:
    ld      (hl), 32
    inc     hl
    djnz    generic_console_scrollup_3
    pop     hl                          ;Get screen back

IF FORpc6001
    dec     h
    dec     h
    ld      d, h
    ld      e, 0
    ld      bc, +((MC6847_CONSOLE_COLUMNS)*(MC6847_CONSOLE_ROWS-1))
    ldir
    ex      de, hl
    ld      b, MC6847_CONSOLE_COLUMNS
    ld      a, (__pc6001_attr)
generic_console_scrollup_4:
    ld      (hl), a
    inc     hl
    djnz    generic_console_scrollup_4
ELIF FORphc25
    ld      a,h
    add     8
    ld      h,a
    ld      d, h
    ld      e, 0
    ld      bc, +((MC6847_CONSOLE_COLUMNS)*(MC6847_CONSOLE_ROWS-1))
    ldir
    ex      de, hl
    ld      b, MC6847_CONSOLE_COLUMNS
    ld      a, (__phc25_attr)
generic_console_scrollup_4:
    ld      (hl), a
    inc     hl
    djnz    generic_console_scrollup_4
ENDIF

IF FORmc1000
    ex      af,af
    set     0,a
    out     ($80),a
ENDIF
    pop     bc
    pop     de
    ret

IF MC6847_HAS_CG | MC6847_HAS_HIRES
scrollup_hires:
    GETSCREENADDRESS
IF FORmc1000
    ld      a,(__mc6847_modeval)
    out     ($80),a
    ex      af,af
ENDIF
    ld      de,hl
    inc     h
IF FORsv8000
    ld      bc, 32 * 88
ELIF FORvz
    ld      bc, 32 * 56
ELSE
    ld      bc, 32 * 184
ENDIF
    ldir
    ex      de, hl
    ld      b, 0
    xor     a
scrollup_hires_1:
    ld      (hl), a
    inc     hl
    djnz    scrollup_hires_1
IF FORmc1000
    ex      af,af
    set     0,a
    out     ($80),a
ENDIF
    pop     bc
    pop     de
    ret
ENDIF 

ENDIF