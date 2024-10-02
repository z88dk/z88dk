        #include    "target/aquarius/def/plus.inc"
        SECTION code_clib

        PUBLIC  scrollup_TEXT

        EXTERN  CONSOLE_COLUMNS
        EXTERN  CONSOLE_ROWS
        EXTERN  DISPLAY
        EXTERN  COLOUR_MAP
        EXTERN  __aquarius_attr

scrollup_TEXT:
        push    de
        push    bc

        in      a, (IO_VCTRL)
        bit     6, a
        jr      nz, col80

        ld      hl, DISPLAY+CONSOLE_COLUMNS
        ld      de, DISPLAY
        ld      bc, +((CONSOLE_COLUMNS)*(CONSOLE_ROWS-1))
        ldir

        ex      de, hl
        ld      b, CONSOLE_COLUMNS
generic_console_scrollup_3:
        ld      (hl), 32
        inc     hl
        djnz    generic_console_scrollup_3

        ld      hl, COLOUR_MAP+CONSOLE_COLUMNS
        ld      de, COLOUR_MAP
        ld      bc, +((CONSOLE_COLUMNS)*(CONSOLE_ROWS-1))
        ldir

        ex      de, hl
        ld      b, CONSOLE_COLUMNS
        ld      a, (__aquarius_attr)
generic_console_scrollup_4:
        ld      (hl), a
        inc     hl
        djnz    generic_console_scrollup_4

textScrollUpDone:
        pop     bc
        pop     de
        ret

col80:
        ld      hl, DISPLAY+80
        ld      de, DISPLAY
        ld      bc, +(80*(CONSOLE_ROWS-1))
        ldir

        ex      de, hl
        ld      b, 80
col80LastRow:
        ld      (hl), 32
        inc     hl
        djnz    col80LastRow

        ld      hl, DISPLAY+80
        ld      de, DISPLAY
        ld      b, a
        or      VCTRL_TEXT_PAGE
        out     (IO_VCTRL), a
        ld      a, b
        ld      bc, +(80*(CONSOLE_ROWS-1))
        ldir

        ex      de, hl
        ld      d, a
        ld      b, 80
        ld      a, (__aquarius_attr)
col80LastColorRow:
        ld      (hl), a
        inc     hl
        djnz    col80LastColorRow

        ld      a, d
        out     (IO_VCTRL), a

        jr      textScrollUpDone

