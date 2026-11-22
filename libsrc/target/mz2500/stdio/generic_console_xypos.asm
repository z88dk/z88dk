;
; The address of a character cell in the graphics window: the cell is 8 lines of 40 bytes, so (y * 320 + x) + the window's base.
; The same offset is in each of the four planes.
;
; Entry: b = row, c = column
; Exit:  hl = the address of the cell's first line.  Uses a, b
;
    SECTION code_clib
    PUBLIC  generic_console_xypos
    EXTERN  __MZ2500_GFX_BASE

generic_console_xypos:
    ld      l, b
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl                      ;y * 64
    ld      a, h
    add     a, b                        ;+ y * 256
    add     a, +(__MZ2500_GFX_BASE / 256)
    ld      h, a
    ld      b, 0
    add     hl, bc
    ret
