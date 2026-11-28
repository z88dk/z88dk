
; Address of a character cell on the graphics screen
;
; Entry: c = x, b = y
; Exit:  hl = address of the cell (the 4 colour mode uses two bytes per cell)
; Uses:  a, de

    INCLUDE "target/pc8001/hires/gvram.inc"

    SECTION code_driver
    PUBLIC  __pc8001_hires_addr
    EXTERN  __pc8001_gfxmode

__pc8001_hires_addr:
    ld      h, 0
    ld      l, b
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl                      ;y * 128
    ld      d, h
    ld      e, l
    add     hl, hl
    add     hl, hl                      ;y * 512
    add     hl, de                      ;y * 640, 8 rows of 80 bytes
    ld      de, GVRAM
    add     hl, de
    ld      d, 0
    ld      e, c
    add     hl, de
    ld      a, (__pc8001_gfxmode)
    cp      2
    ret     nz
    add     hl, de
    ret
