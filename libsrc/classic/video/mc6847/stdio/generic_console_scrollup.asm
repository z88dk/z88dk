    INCLUDE "classic/video/mc6847/mc6847.inc"

IFNDEF MC6847_IOSPACE

    SECTION     code_driver

    PUBLIC      generic_console_scrollup

    EXTERN      generic_console_gfx_xypos_MODE1

    EXTERN      __mc6847_mode
    EXTERN      __pc6001_attr
    EXTERN      __phc25_attr
    EXTERN      __mc6847_modeval
    EXTERN      __tms9918_cls
    EXTERN      __console_font_h


generic_console_scrollup:
    push    de
    push    bc
    ld      a, (__mc6847_mode)
    and     a
    jr      z, scrollup_text
IF FORspc1000
    cp      10
    jp      z,__tms9918_cls
ENDIF
IF MC6847_HAS_HIRES | MC6847_HAS_CG
    jr      scrollup_hires
ELSE
    pop     bc
    pop     de
    ret
ENDIF


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
scrollup_return:
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
    ld      hl,(__console_font_h)
    ld      h,0
    ld      a,MC6847_HIRES_YRES
    sub     l
    ld      l,a
    ; Now multiple by 32
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    ld      bc,hl
    GETSCREENADDRESS_de
IF FORmc1000
    ld      a,(__mc6847_modeval)
    out     ($80),a
    ex      af,af
ENDIF
    push    bc
    ld      bc, $0100       ;row 1, column 0
    call    generic_console_gfx_xypos_MODE1     ;It's column 0, so mode is irrelevant
    pop     bc
    ld      a,l             ;save number of bytes to clear
    ldir
    ; And we have to fill in 
    ld      b, a            ;a = __console_font_h * 32 (if rows <= 8)
    xor     a
scrollup_hires_1:
    ld      (de), a
    inc     de
    djnz    scrollup_hires_1
    jr      scrollup_return

ENDIF

ENDIF