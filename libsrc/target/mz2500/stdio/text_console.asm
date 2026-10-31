;
; Console mode 0: the text screen, written directly (the IPL is not called, so it works with or without it).  The text VRAM is page $38, borrowed
; through the graphics window like the planes are: three 2 KB arrays, the low byte of the character code at +$0000, the attributes at +$0800 (bits 0-2
; colour: blue 1, red 2, green 4; bit 6 reverse) and the high byte of the code at +$1000.  The glyphs are the ROM's (no UDGs, no custom font), in the
; kanji ROM where the IPL has them: a character c is the code $8C00 + 4 * c (so a blank is $80 / $07 / $8C).
;
; A font and UDGs can be had too (ioctl IOCTL_GENCON_SET_FONT32, IOCTL_GENCON_SET_UDGS): __mz2500_textcon_load_pcg copies the font (characters 32-127)
; and the UDGs (128-255) into PCG0, the CPU-writable character generator (page $39: 256 glyphs of 8 bytes, the leftmost pixel in bit 7), sets 8 byte
; glyphs (port $F7 bit 0) and from then on the cells hold the plain code (high byte 0), blank is 0 / $07 / 0.  __mz2500_textcon_rom goes back to the
; ROM's glyphs (it assumes the IPL's setting is 16 line glyphs: port $F7 = 0).  Cells already on the screen keep the code they were written with.  The screen is __MZ2500_TEXT_COLUMNS (40 or 80, as the CRTC is set: -pragma-define:CRT_MZ2500_TEXT_COLUMNS) by 25 cells,
; the cell at the start of the arrays (the CRTC's start address is set to 0).  The width, 25 rows and screen 1 are the CRTC's and PIO's: the crt0 sets them with
; the IPL's _TWID unless the IPL is disabled, when the program has to.  The text has no background colour: it shows over the graphics.
;
    SECTION code_clib

    PUBLIC  __mz2500_textcon_init
    PUBLIC  __mz2500_textcon_load_pcg
    PUBLIC  __mz2500_textcon_rom
    PUBLIC  __mz2500_textcon_cls
    PUBLIC  __mz2500_textcon_scrollup
    PUBLIC  __mz2500_textcon_printc
    PUBLIC  __mz2500_textcon_vpeek
    PUBLIC  __mz2500_textcon_set_ink
    PUBLIC  __mz2500_textcon_set_paper
    PUBLIC  __mz2500_text_ink
    EXTERN  generic_console_flags
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  conio_map_colour
    EXTERN  __mz2500_gwin_save
    EXTERN  __mz2500_gwin_map
    EXTERN  __mz2500_gwin_restore
    EXTERN  l_push_di
    EXTERN  l_pop_ei
    EXTERN  __MZ2500_GFX_BASE
    EXTERN  __MZ2500_TEXT_COLUMNS

    defc    TEXT_PAGE = $38

; Each routine opens with this (inline: l_push_di keeps its status word on the stack, so it can't be called from a subroutine that returns):
;   call l_push_di / call __mz2500_gwin_save / ld a, TEXT_PAGE / call __mz2500_gwin_map
; and closes with call __mz2500_gwin_restore / call l_pop_ei.

; The CRTC's text registers to their unscrolled state: register 0 = $04 (screen No.1, 25 rows), 1 and 2 = the start address 0 (the IPL scrolls the
; text screen by changing it, and the cells are at the start of the arrays), 9 = the vertical offset 0.  Registers are selected through $F4 and written
; through $F5.  Uses af, bc, hl
__mz2500_textcon_init:
    ld      hl, init_table
    ld      b, 4
init_loop:
    ld      a, (hl)
    inc     hl
    out     ($f4), a
    ld      a, (hl)
    inc     hl
    out     ($f5), a
    djnz    init_loop
    ret

    SECTION rodata_clib
init_table:
    defb    0, $04, 1, 0, 2, 0, 9, 0
    SECTION code_clib

__mz2500_textcon_cls:
    call    l_push_di
    call    __mz2500_gwin_save
    ld      a, TEXT_PAGE
    call    __mz2500_gwin_map
    ld      hl, __MZ2500_GFX_BASE
    call    blank_low
    call    fill_array
    ld      hl, __MZ2500_GFX_BASE + $800
    ld      a, $07
    call    fill_array
    ld      hl, __MZ2500_GFX_BASE + $1000
    call    blank_high
    call    fill_array
    call    __mz2500_gwin_restore
    call    l_pop_ei
    ret

; a = the blank cell's low and high code bytes (the ROM's glyphs: $80, $8C; the PCG font: 0, 0).  Keep hl
blank_low:
    ld      a, (__mz2500_text_pcg)
    and     a
    ld      a, $80
    ret     z
    xor     a
    ret

blank_high:
    ld      a, (__mz2500_text_pcg)
    and     a
    ld      a, $8c
    ret     z
    xor     a
    ret

; hl = an array, a = the blank value
fill_array:
    ld      (hl), a
    ld      d, h
    ld      e, l
    inc     de
    ld      bc, $7ff
    ldir
    ret

__mz2500_textcon_scrollup:
    push    de
    push    bc
    call    l_push_di
    call    __mz2500_gwin_save
    ld      a, TEXT_PAGE
    call    __mz2500_gwin_map
    ld      hl, __MZ2500_GFX_BASE
    call    blank_low
    call    scroll_array
    ld      hl, __MZ2500_GFX_BASE + $800
    ld      a, $07
    call    scroll_array
    ld      hl, __MZ2500_GFX_BASE + $1000
    call    blank_high
    call    scroll_array
    call    __mz2500_gwin_restore
    call    l_pop_ei
    pop     bc
    pop     de
    ret

; hl = an array, a = the blank value: the lines move up and the bottom one is blank
scroll_array:
    push    hl
    ex      af, af'
    ld      d, h
    ld      e, l
    ld      bc, __MZ2500_TEXT_COLUMNS
    add     hl, bc
    ld      bc, 24 * __MZ2500_TEXT_COLUMNS
    ldir
    ld      h, d
    ld      l, e
    ex      af, af'
    ld      (hl), a
    inc     de
    ld      bc, __MZ2500_TEXT_COLUMNS - 1
    ldir
    pop     hl
    ret

; hl = the address of the cell: c = x, b = y.  Uses a, b, de
text_xy:
    ld      hl, __MZ2500_GFX_BASE
    ld      de, __MZ2500_TEXT_COLUMNS
    ld      a, b
    and     a
    jr      z, xy_column
xy_row:
    add     hl, de
    dec     a
    jr      nz, xy_row
xy_column:
    ld      b, 0
    add     hl, bc
    ret

; c = x, b = y, d = the character
__mz2500_textcon_printc:
    push    de
    call    text_xy
    pop     de
    push    hl
    ld      a, (__mz2500_text_pcg)
    and     a
    jr      z, rom_code
    ld      e, d                        ;the PCG font: the code is the character
    ld      d, 0
    jr      have_code
rom_code:
    ld      l, d
    ld      h, 0
    add     hl, hl
    add     hl, hl
    ld      de, $8c00
    add     hl, de
    ex      de, hl                      ;de = the code: e the low byte, d the high byte
have_code:
    pop     hl
    call    l_push_di
    call    __mz2500_gwin_save
    ld      a, TEXT_PAGE
    call    __mz2500_gwin_map
    ld      (hl), e
    ld      a, (generic_console_flags)
    rlca                                ;bit 7 = inverse
    ld      a, (__mz2500_text_ink)
    jr      nc, not_reverse
    or      $40
not_reverse:
    ld      bc, $800
    add     hl, bc
    ld      (hl), a
    add     hl, bc
    ld      (hl), d
    call    __mz2500_gwin_restore
    call    l_pop_ei
    ret

; Entry: c = x, b = y.  Exit: nc, a = the character; c if the cell does not have one of the codes above
__mz2500_textcon_vpeek:
    call    text_xy
    call    l_push_di
    call    __mz2500_gwin_save
    ld      a, TEXT_PAGE
    call    __mz2500_gwin_map
    ld      c, (hl)
    ld      de, $1000
    add     hl, de
    ld      b, (hl)
    call    __mz2500_gwin_restore
    call    l_pop_ei
    ld      a, (__mz2500_text_pcg)
    and     a
    jr      z, vpeek_rom
    ld      a, b
    and     a
    jr      nz, vpeek_fail
    ld      a, c
    and     a
    ret
vpeek_rom:
    ld      a, b
    sub     $8c
    jr      c, vpeek_fail
    cp      4
    jr      nc, vpeek_fail
    ld      b, a
    ld      a, c
    and     3
    jr      nz, vpeek_fail
    ld      a, c
    rrca
    rrca
    and     $3f
    ld      c, a
    ld      a, b
    rrca
    rrca
    and     $c0
    or      c
    and     a
    ret
vpeek_fail:
    scf
    ret

; Fill PCG0 from the font and the UDGs and switch to it
__mz2500_textcon_load_pcg:
    call    l_push_di
    call    __mz2500_gwin_save
    ld      a, $39
    call    __mz2500_gwin_map
    xor     a
    out     ($cf), a                    ;(the kanji ROM bank off: the first 2 KB of the page is PCG0, RAM)
    ld      hl, __MZ2500_GFX_BASE
    ld      de, __MZ2500_GFX_BASE + 1
    ld      (hl), a
    ld      bc, $7ff
    ldir
    ld      hl, (generic_console_font32)
    ld      a, h
    or      l
    jr      z, no_font
    ld      de, __MZ2500_GFX_BASE + 32 * 8
    ld      bc, 96 * 8
    ldir
no_font:
    ld      hl, (generic_console_udg32)
    ld      a, h
    or      l
    jr      z, no_udgs
    ld      de, __MZ2500_GFX_BASE + 128 * 8
    ld      bc, 128 * 8
    ldir
no_udgs:
    call    __mz2500_gwin_restore
    call    l_pop_ei
    ld      a, 1
    out     ($f7), a                    ;8 byte glyphs
    ld      (__mz2500_text_pcg), a
    ret

__mz2500_textcon_rom:
    xor     a
    out     ($f7), a
    ld      (__mz2500_text_pcg), a
    ret

; The colours are blue 1, red 2, green 4: the greys (8) become white
__mz2500_textcon_set_ink:
    call    conio_map_colour
    ld      c, a
    and     7
    jr      nz, ink_ok
    ld      a, c
    and     a
    jr      z, ink_ok
    ld      a, 7
ink_ok:
    ld      (__mz2500_text_ink), a
    ret

__mz2500_textcon_set_paper:
    ret

    SECTION data_clib
__mz2500_text_ink: defb    7
__mz2500_text_pcg: defb    0           ; 1: the cells hold plain codes for the PCG font
