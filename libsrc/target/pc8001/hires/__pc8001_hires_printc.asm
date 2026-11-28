
; Print a bitmapped character on the graphics screen. The generic console
; calls this in a hires mode when a font has been set (-pragma-redirect:CRT_FONT=
; or IOCTL_GENCON_SET_FONT32), otherwise the text layer is used.
;
; Mode 1 is 640x200: one byte per character row, 80 columns.
; Mode 2 is 320x200: two bytes per character row, 40 columns, with the ink and
; paper being pixel values 0 - 3.
;
; The GVRAM is paged in over the font, so the glyph is turned into a buffer
; on the stack (with the attributes applied) before the plane is selected.
;
; Entry: c = x, b = y, d = character, e = raw

    INCLUDE "target/pc8001/hires/gvram.inc"
    INCLUDE "target/pc8001/hires/allram_only.inc"

    SECTION code_driver
    PUBLIC  __pc8001_hires_printc
    PUBLIC  __pc8001_hires_mask55
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  generic_console_flags
    EXTERN  __pc8001_gfxmode
    EXTERN  __pc8001_ink
    EXTERN  __pc8001_paper
    EXTERN  l_push_di
    EXTERN  l_pop_ei
    EXTERN  __pc8001_hires_addr

__pc8001_hires_printc:
    ld      a, d
    ex      af, af'                     ;keep the character
    call    __pc8001_hires_addr         ;hl = address of the cell
    push    hl
    exx
    pop     hl                          ;hl' = destination
    exx

    ex      af, af'
    ld      bc, (generic_console_font32)
    ld      l, a
    ld      h, 0
    bit     7, l
    jr      z, not_udg
    res     7, l
    ld      bc, (generic_console_udg32)
    inc     b
not_udg:
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, bc
    dec     h                           ;-32 characters
    ex      de, hl                      ;de = glyph

    ld      hl, -8
    add     hl, sp
    ld      sp, hl                      ;hl = 8 byte buffer
    ld      b, 8
attr_loop:
    ld      a, (generic_console_flags)
    ld      c, a
    ld      a, b
    cp      1
    jr      nz, not_last_row
    bit     3, c                        ;Underline
    jr      z, not_last_row
    inc     de
    ld      a, 255
    jr      have_row
not_last_row:
    ld      a, (de)
    inc     de
    bit     4, c                        ;Bold
    jr      z, have_row
    ld      c, a
    srl     a
    or      c
have_row:
    ld      c, a
    ld      a, (generic_console_flags)
    rlca                                ;Inverse
    ld      a, c
    jr      nc, store_row
    cpl
store_row:
    ld      (hl), a
    inc     hl
    djnz    attr_loop

    ld      a, (__pc8001_gfxmode)
    cp      2
    jr      nz, draw
    ; 320x200: turn each row into two bytes of 2 bit pixels
    ld      a, (__pc8001_ink)
    call    __pc8001_hires_mask55
    ld      (inkm+1), a
    ld      a, (__pc8001_paper)
    call    __pc8001_hires_mask55
    ld      (papm+1), a
    ld      hl, 0
    add     hl, sp                      ;hl = the 8 byte buffer
    ld      de, -16
    ex      de, hl
    add     hl, sp
    ld      sp, hl
    ex      de, hl                      ;hl = source, de = 16 byte buffer
    ld      b, 8
expand_loop:
    push    bc
    push    hl
    ld      a, (hl)
    call    expand_byte
    pop     hl
    inc     hl
    pop     bc
    djnz    expand_loop
draw:
    ld      hl, 0
    add     hl, sp
    ex      de, hl                      ;de = rows to draw
    exx
    push    hl
    exx
    pop     hl                          ;hl = destination
    ld      a, (__pc8001_gfxmode)
    ld      c, a                        ;c = 1 or 2 bytes per row
    ld      b, 8
    call    l_push_di
    out     ($5c), a                    ;Plane 0
row_loop:
    ld      a, (de)
    ld      (hl), a
    inc     de
    bit     1, c
    jr      z, next_row
    inc     hl
    ld      a, (de)
    ld      (hl), a
    inc     de
    dec     hl
next_row:
    ld      a, l
    add     a, 80
    ld      l, a
    jr      nc, no_carry
    inc     h
no_carry:
    djnz    row_loop
    out     ($5f), a                    ;Back to main memory
    call    l_pop_ei
    ld      hl, 8
    bit     1, c
    jr      z, free_buffer
    ld      hl, 24
free_buffer:
    add     hl, sp
    ld      sp, hl
    ret

; a = glyph row, de = destination (two bytes are written)
expand_byte:
    ld      c, a
    rrca
    rrca
    rrca
    rrca
    and     15
    call    expand_nibble
    ld      (de), a
    inc     de
    ld      a, c
    and     15
    call    expand_nibble
    ld      (de), a
    inc     de
    ret

; a = four pixels, leftmost in bit 3. Returns two bits per pixel.
expand_nibble:
    ld      hl, nibble_table
    add     a, l
    ld      l, a
    jr      nc, no_carry_nibble
    inc     h
no_carry_nibble:
    ld      a, (hl)                     ;3 for each pixel that is set
    ld      b, a
inkm:
    and     0                           ;patched with the ink
    ld      l, a
    ld      a, b
    cpl
papm:
    and     0                           ;patched with the paper
    or      l
    ret

; a = pixel value 0 - 3, returns it repeated in all four pixels of a byte
__pc8001_hires_mask55:
    ld      c, a
    add     a
    add     a
    or      c
    ld      c, a
    add     a
    add     a
    add     a
    add     a
    or      c
    ret

nibble_table:
    defb    $00, $03, $0c, $0f, $30, $33, $3c, $3f
    defb    $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
