


    SECTION code_clib

    PUBLIC  plotpixel

    EXTERN  __x07_buffer

    INCLUDE "target/x07/def/x07.h"
    EXTERN  __x07_SUB_EXECUTE
    EXTERN  __CLIB_X07_USE_FIRMWARE
    EXTERN  __gfx_coords

; hl = xy
plotpixel:
    ld      a,__CLIB_X07_USE_FIRMWARE
    and     a
    jr      nz,use_rom
    defc    NEEDplot=1
    INCLUDE "target/x07/graphics/pixel_MODE1.inc"

use_rom:
    ld      (__gfx_coords),hl
    push    bc
    ex      de,hl
    ld      hl,__x07_buffer
    ld      (hl),d
    inc     hl
    ld      (hl),e
    dec     hl
    ld      a,SUB_LCD_PSET
    ld      b,2         ;arguments
    ld      c,0
    call    __x07_SUB_EXECUTE
    pop     bc
    ret

