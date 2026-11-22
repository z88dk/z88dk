;
; Print a character in a cell: the 8x8 glyph from the font (32-127) or the UDGs
; (128-255) in the ink and paper pens.  Flags (generic_console_flags): bit 7
; inverse (pens
; swapped), bit 4 bold (each line ORed with itself a pixel to the right), bit 3
; underline (last line solid).  The planes are behind I/O ports (see
; spc1500_gfx.asm): the cell's
; first line in the blue plane is $4000 + y * 40 + x, each line is $800 on, and
; eight lines on is the next plane's first line.  Per plane the byte is (glyph &
; a) ^ x, a = $FF if
; ink and paper differ in that plane's bit, x = $FF if paper's bit is set.  The
; font's bit 7 is the leftmost pixel, as the planes'.
;
    SECTION code_clib
    PUBLIC  generic_console_printc
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  generic_console_flags
    EXTERN  generic_console_xypos
    EXTERN  __spc1500_con_ink

; c = x
; b = y
; d = the character
; e = raw
generic_console_printc:
    ld      l, d
    ld      h, 0
    ld      de, (generic_console_font32)
    bit     7, l
    jr      z, not_udg
    res     7, l
    ld      de, (generic_console_udg32)
    inc     d
not_udg:
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, de
    dec     h                           ;(the font starts at character 32)
    ld      (pc_glyph), hl
    call    generic_console_xypos       ;hl = the cell's offset
    ld      a, h
    add     a, $40
    ld      h, a
    ld      (pc_cell), hl               ;the first line of the cell in the blue plane
    ld      a, (generic_console_flags)
    ld      (pc_flags), a
    ld      hl, (__spc1500_con_ink)     ;l = ink, h = paper
    rlca                                ;bit 7 = inverse
    jr      nc, not_inverse
    ld      a, l
    ld      l, h
    ld      h, a
not_inverse:
    ld      (pc_ink), hl                ;(pc_ink, then pc_paper)
    ld      a, 1                        ;the plane's mask: 1 blue, 2 red, 4 green
plane:
    ld      (pc_mask), a
    ld      c, a
    ld      hl, (pc_ink)
    ld      a, l
    xor     h
    and     c
    add     a, $ff
    sbc     a, a                        ;$FF if the pens differ in this plane
    ld      (pc_a), a
    ld      a, h
    and     c
    add     a, $ff
    sbc     a, a                        ;$FF if the paper has the plane's bit
    ld      (pc_x), a
    ld      hl, (pc_glyph)
    ld      de, (pc_cell)
    ld      a, 8
    ld      (pc_lines), a
line:
    ld      c, (hl)
    inc     hl
    ld      a, (pc_flags)
    bit     4, a                        ;bold
    jr      z, not_bold
    ld      a, c
    srl     a
    or      c
    ld      c, a
not_bold:
    ld      a, (pc_lines)
    dec     a
    jr      nz, not_last
    ld      a, (pc_flags)
    bit     3, a                        ;underline: the last line
    jr      z, not_last
    ld      c, $ff
not_last:
    ld      a, (pc_a)
    and     c
    ld      c, a
    ld      a, (pc_x)
    xor     c                           ;the byte for this plane
    ld      b, d
    ld      c, e
    out     (c), a
    ld      a, d
    add     a, 8                        ;the next line
    ld      d, a
    ld      a, (pc_lines)
    dec     a
    ld      (pc_lines), a
    jr      nz, line
    ld      (pc_cell), de               ;(eight lines on: the next plane's first line)
    ld      a, (pc_mask)
    add     a, a
    cp      8
    jr      nz, plane
    ret

    SECTION bss_clib
pc_glyph:   defw    0
pc_cell:    defw    0
pc_ink:     defb    0                   ; (read together as a word with pc_paper)
pc_paper:   defb    0
pc_flags:   defb    0
pc_mask:    defb    0
pc_a:       defb    0
pc_x:       defb    0
pc_lines:   defb    0
