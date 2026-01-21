


    SECTION code_clib

    PUBLIC  xorpixel

    EXTERN  __x07_buffer

    INCLUDE "target/x07/def/x07.h"
    EXTERN  __x07_SUB_EXECUTE

; hl = xy
xorpixel:
    ex      de,hl
    ld      hl,__x07_buffer
    ld      (hl),d
    inc     hl
    ld      (hl),e
    dec     hl
    ld      a,SUB_LCD_PEOR
    ld      b,2         ;arguments
    ld      c,0
    jp      __x07_SUB_EXECUTE

