;
; The offset of a character cell in a plane: the cell is 8 lines of 40 bytes a
; character row, so y * 40 + x; its first line is at $4000 + the offset in the
; blue plane (and
; $8000 red, $C000 green, each line $800 on from the one before).
;
; Entry: b = row, c = column
; Exit:  hl = the offset.  Uses a, de
;
    SECTION code_clib
    PUBLIC  generic_console_xypos

generic_console_xypos:
    ld      l, b
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl                      ;y * 8
    ld      d, h
    ld      e, l
    add     hl, hl
    add     hl, hl                      ;y * 32
    add     hl, de                      ;y * 40
    ld      e, c
    ld      d, 0
    add     hl, de
    ret
