
SECTION code_clib

PUBLIC scrollup_TEXT

EXTERN COLOUR_MAP
EXTERN CONSOLE_COLUMNS
EXTERN CONSOLE_ROWS
EXTERN DISPLAY
EXTERN __aquarius_attr

scrollup_TEXT:
    push    de
    push    bc
    ld      hl, DISPLAY + CONSOLE_COLUMNS
    ld      de, DISPLAY
    ld      bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
    ldir
    ex      de,hl
    ld      b,CONSOLE_COLUMNS
generic_console_scrollup_3:
    ld      (hl),32
    inc     hl
    djnz    generic_console_scrollup_3
    ld      hl, COLOUR_MAP + CONSOLE_COLUMNS
    ld      de, COLOUR_MAP
    ld      bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
    ldir
    ex      de,hl
    ld      b,CONSOLE_COLUMNS
    ld      a,(__aquarius_attr)
generic_console_scrollup_4:
    ld      (hl),a
    inc     hl
    djnz    generic_console_scrollup_4
    pop     bc
    pop     de
    ret
