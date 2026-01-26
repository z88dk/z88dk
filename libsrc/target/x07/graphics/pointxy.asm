


    SECTION code_clib

    PUBLIC  pointxy

    EXTERN  __x07_buffer

    INCLUDE "target/x07/def/x07.h"
    EXTERN  __x07_SUB_EXECUTE

; hl = xy
; Always use the firmware 
pointxy:
    ex      de,hl
    ld      hl,__x07_buffer
    ld      (hl),d
    inc     hl
    ld      (hl),e
    dec     hl
    ld      a,SUB_LCD_POINT
    ld      b,2         ;arguments
    ld      c,1
    ld      de,hl
    call    __x07_SUB_EXECUTE
    ld      a,(__x07_buffer)
    and     a
    ret


