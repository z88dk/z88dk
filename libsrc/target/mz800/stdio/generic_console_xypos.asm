;
; The address of a character cell in the video RAM: the cell is 8 lines of 40 bytes, so $8000 + y * 320 + x.  The same offset is in each plane.
;
; Entry: b = row, c = column
; Exit:  hl = the address of the cell's first line.  Uses a, b
;
    SECTION code_driver
    PUBLIC  generic_console_xypos

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
    add     a, $80
    ld      h, a
    ld      b, 0
    add     hl, bc
    ret
