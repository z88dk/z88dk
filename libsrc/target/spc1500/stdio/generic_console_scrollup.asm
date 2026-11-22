;
; Scroll the console up a line (8 lines of pixels): in each plane each of the 8
; pixel lines of the 25 character rows has the 24 rows below the first moved up
; (960 bytes from
; 40 on), through the I/O ports one byte at a time; then the bottom character
; row is cleared to the paper pen (a plane of all ones or all zeros).
;
    SECTION code_clib
    PUBLIC  generic_console_scrollup
    EXTERN  __spc1500_con_paper

generic_console_scrollup:
    push    de
    push    bc
    ld      hl, $4000 + 40              ;the source of the first block: a plane's first pixel line, from the second character row
    ld      de, $4000
    ld      a, 24                       ;3 planes of 8 lines
    ex      af, af'                     ;a' = the blocks left
block:
    exx
    ld      bc, 960                     ;bc' = the bytes left in the block
    exx
copy:
    ld      b, h
    ld      c, l
    in      a, (c)
    ld      b, d
    ld      c, e
    out     (c), a
    inc     hl
    inc     de
    exx
    dec     bc
    ld      a, b
    or      c
    exx
    jr      nz, copy
    ld      bc, $800 - 960              ;(each line is $800 on: eight lines on is the next plane)
    add     hl, bc
    ex      de, hl
    add     hl, bc
    ex      de, hl
    ex      af, af'
    dec     a
    jr      z, scrolled
    ex      af, af'
    jr      block
scrolled:
    ld      a, (__spc1500_con_paper)
    ld      d, a
    ld      b, $40 + 3                  ;the last character row (960 = $3C0 on): high byte, the planes $40 apart
    ld      e, 3
clear_plane:
    ld      a, d
    rra
    ld      d, a
    sbc     a, a                        ;the plane's value: $FF if the paper has its bit
    ld      h, 8
clear_line:
    ld      c, $c0                      ;(the 40 bytes are within the page: $C0 to $E7)
    ld      l, 40
clear_col:
    out     (c), a
    inc     c
    dec     l
    jr      nz, clear_col
    REPT 8
    inc     b                           ;(the next line, $800 on)
    ENDR
    dec     h
    jr      nz, clear_line
    dec     e
    jr      nz, clear_plane
    pop     bc
    pop     de
    ret
