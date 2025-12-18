


    SECTION code_clib

    PUBLIC  plotpixel

    EXTERN  __x07_buffer

    INCLUDE "target/x07/def/x07.h"

; hl = xy
plotpixel:
    ex      de,hl
    ld      hl,__x07_buffer
    ld      (hl),d
    inc     hl
    ld      (hl),e
    dec     hl
    ld      a,SUB_LCD_PSET
    ld      b,2         ;arguments
    ld      c,0
    jp      SUB_EXECUTE

