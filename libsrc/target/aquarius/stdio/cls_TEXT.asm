
SECTION code_clib

PUBLIC cls_TEXT

EXTERN COLOUR_MAP
EXTERN CONSOLE_COLUMNS
EXTERN CONSOLE_ROWS
EXTERN DISPLAY
EXTERN __aquarius_attr

cls_TEXT:
    ld      hl, DISPLAY
    ld      de, DISPLAY +1
    ld      bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
    ld      (hl),32
    ldir
    ld      hl, COLOUR_MAP
    ld      de, COLOUR_MAP+1
    ld      bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
    ld      a,(__aquarius_attr)
    ld      (hl),a
    ldir
    ret
