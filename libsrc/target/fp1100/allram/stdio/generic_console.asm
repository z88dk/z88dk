; The all-RAM console: 40x25 cells of 8x8 pixels, three colour planes (eight colours), drawn by the sub-CPU (../sub/sub.s.in).  Each character is
; its own address and Text command: the sub program keeps no cursor.  The font is in the sub-CPU's video RAM (takeover.asm), 32 bytes a glyph.

    MODULE  fp1100_allram_generic_console
    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_plotc
    PUBLIC  generic_console_pointxy
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper

    EXTERN  __fp1100_attr
    EXTERN  __fp1100_lores_graphics
    EXTERN  conio_map_colour
    EXTERN  generic_console_udg32
    EXTERN  fp1100_sub_send
    EXTERN  fp1100_sub_addr
    EXTERN  fp1100_sub_glyph
    EXTERN  fp1100_sub_cls

    INCLUDE "../sub/sub.inc"

; The colours in __fp1100_attr: ink in bits 0 to 2, paper in bits 4 to 6 (blue, red, green).  The sub program wants paper in bits 3 to 5.

generic_console_set_attribute:
    ld      a, (__inverse)
    ld      b, a
    xor     a
    bit     7, (hl)
    jr      z, inverse_off
    inc     a
inverse_off:
    cp      b
    ret     z                           ;No change to inverse
    ld      (__inverse), a
    ld      a, (__fp1100_attr)
    rrca
    rrca
    rrca
    rrca
    ld      (__fp1100_attr), a
    ret

generic_console_set_ink:
    call    conio_map_colour
    and     7
    ld      b, a
    ld      a, (__fp1100_attr)
    and     @01110000
    or      b
    ld      (__fp1100_attr), a
    ret

generic_console_set_paper:
    call    conio_map_colour
    rlca
    rlca
    rlca
    rlca
    and     @01110000
    ld      b, a
    ld      a, (__fp1100_attr)
    and     @00000111
    or      b
    ld      (__fp1100_attr), a
    ret

generic_console_cls:
    jp      fp1100_sub_cls

; The screen up a row: the sub program copies rows 1 to 24 up, then the last row is cleared to the paper colour.
generic_console_scrollup:
    push    de
    push    bc
    ld      hl, __fp1100_text + 40
    ld      de, __fp1100_text
    ld      bc, 24 * 40
    ldir
    ld      hl, __fp1100_text + 24 * 40
    ld      b, 40
sc_b:
    ld      (hl), 32
    inc     hl
    djnz    sc_b
    ld      a, SUB_SCROLL & $FF
    call    fp1100_sub_send
    ld      de, $2000 + 24 * 320
    call    fp1100_sub_addr
    ld      a, SUB_FILL & $FF
    call    fp1100_sub_send
    ld      a, 39
    call    fp1100_sub_send
    ld      a, (__fp1100_attr)
    rrca
    rrca
    rrca
    rrca
    and     7
    call    fp1100_sub_send
    pop     bc
    pop     de
    ret

; c = x, b = y, a = d = the character, e = raw.  The graphics characters come from the table at __fp1100_lores_graphics (8 bytes each), if it is set.
generic_console_plotc:
    ld      hl, (__fp1100_lores_graphics)
    ld      a, h
    or      l
    ret     z
    ld      e, d
    ld      d, 0
    ex      de, hl                      ; hl = the character, de = the table
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, de                      ; hl = its 8 bytes
    ld      a, 255                      ; (the slot kept for these)
    call    fp1100_sub_glyph
    ld      a, 255
    jr      printc_go

; c = x, b = y, a = d = the character, e = raw.  A character from 128 on is a UDG if the table is set (generic_console_udg32, 8 bytes each from 128), and
; is sent to the sub program's glyph slot of its own code each time.
generic_console_printc:
    cp      128
    jr      c, printc_go
    ld      hl, (generic_console_udg32)
    ld      a, h
    or      l
    ld      a, d
    jr      z, printc_go                ; (no UDGs: the character as it is)
    push    af
    and     $7F
    ld      e, a
    ld      d, 0
    ex      de, hl                      ; hl = the index, de = the table
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, de                      ; hl = the UDG
    pop     af
    push    af
    call    fp1100_sub_glyph
    pop     af
    jr      printc_go

; a = the glyph code, c = x, b = y.  The code is also kept in the text copy.
printc_go:
    call    cell_index
    push    hl
    ld      de, __fp1100_text
    add     hl, de
    ld      (hl), a
    pop     hl
    push    af
    add     hl, hl
    add     hl, hl
    add     hl, hl                      ; (y * 40 + x) * 8
    ld      de, $2000
    add     hl, de
    ex      de, hl
    call    fp1100_sub_addr
    ld      a, SUB_TEXT & $FF
    call    fp1100_sub_send
    xor     a                           ; one character
    call    fp1100_sub_send
    ld      a, (__fp1100_attr)
    ld      b, a
    and     7
    ld      c, a
    ld      a, b
    rrca
    and     $38
    or      c
    call    fp1100_sub_send
    pop     af
    jp      fp1100_sub_send

; hl = y * 40 + x for c = x, b = y.  Keeps A, BC.
cell_index:
    ld      l, b
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    ld      d, h
    ld      e, l
    add     hl, hl
    add     hl, hl                      ; y * 32
    add     hl, de                      ; y * 40
    ld      e, c
    ld      d, 0
    add     hl, de
    ret

; c = x, b = y, e = raw.  The character in the text copy (the graphics character for a plotc), nc.  pointxy is the same read.
generic_console_pointxy:
generic_console_vpeek:
    call    cell_index
    ld      de, __fp1100_text
    add     hl, de
    ld      a, (hl)
    and     a
    ret

    SECTION bss_clib
    PUBLIC  __fp1100_text
__fp1100_text:
    defs    40 * 25                 ; the character in each cell
__inverse:
    defb    0
