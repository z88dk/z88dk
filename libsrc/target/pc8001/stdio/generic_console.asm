;
;	NEC PC8001 generic console
;
;	Text VRAM is at $F300: 25 rows of 120 bytes. Each row is 80
;	characters followed by 20 attribute pairs (start column, attribute).
;	The attribute applies from its start column up to the start of the
;	next pair. A start column of $80 terminates the list.
;
;	Attribute bits (monochrome):
;		7 = semigraphic cell (character byte is a 2x4 pixel mask)
;		5 = lower line, 4 = upper line, 2 = reverse, 1 = blink, 0 = secret
;
;	Derived from the PC8801 console, minus colour, GVRAM and the ALU
;

    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_plotc
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_pointxy

    EXTERN  __pc8001_mode
    EXTERN  __pc8001_attr
    EXTERN  generic_console_flags

    defc    DISPLAY = 0xf300
    defc    ATTR_SEMIGFX = 0x80


; Monochrome machine, colour is ignored
generic_console_set_paper:
generic_console_set_ink:
    ret

generic_console_set_attribute:
    ld      hl, __pc8001_attr
    ld      (hl), 0
    ld      a, (generic_console_flags)
    bit     7, a
    jr      z, not_inverse
    set     2, (hl)
not_inverse:
    bit     3, a                        ;underline
    jr      z, not_underline
    set     5, (hl)
not_underline:
    bit     2, a
    jr      z, no_blink
    set     1, (hl)
no_blink:
    bit     4, a
    ret     z
    set     4, (hl)
    set     5, (hl)
    ret


; Set the attribute of a single screen cell
;
; Entry: b = y
;        c = x (scaled to 80 columns)
;        a = attribute
; Exit:  bc preserved
set_cell_attr:
    push    bc
    push    ix
    call    xypos_attr_row              ;ix = attribute pairs, a untouched
    ld      b, a                        ;b = attribute wanted, c = x
    call    get_attr
    cp      b
    jr      z, set_cell_attr_done       ;already correct, nothing to do
    call    expand
    ld      hl, expand_buf
    ld      e, c
    ld      d, 0
    add     hl, de
    ld      (hl), b
    call    compress
set_cell_attr_done:
    pop     ix
    pop     bc
    ret

; As set_cell_attr, but also covers the second cell in 40 column mode
set_text_attr:
    push    af
    call    set_cell_attr
    ld      a, (__pc8001_mode)
    and     a
    jr      z, set_text_attr_done
    pop     af
    inc     c
    call    set_cell_attr
    dec     c
    ret
set_text_attr_done:
    pop     af
    ret


; Find the attribute in force at a column
;
; Entry: ix = attribute pairs
;        c = x
; Exit:  a = attribute
get_attr:
    push    ix
    ld      e, 0
    ld      d, 20
get_attr_loop:
    ld      a, (ix+0)
    cp      c
    jr      z, get_attr_take
    jr      nc, get_attr_done           ;start column is beyond x
get_attr_take:
    ld      e, (ix+1)
    inc     ix
    inc     ix
    dec     d
    jr      nz, get_attr_loop
get_attr_done:
    ld      a, e
    pop     ix
    ret


; Expand the attribute pairs into one attribute per column
;
; Entry: ix = attribute pairs
; Exit:  expand_buf filled, bc and ix preserved
expand:
    push    ix
    push    bc
    ld      hl, expand_buf
    ld      b, 0                        ;column
    ld      c, 20                       ;pairs left
    ld      d, 0                        ;attribute in force
expand_col:
expand_pair:
    ld      a, c
    and     a
    jr      z, expand_store
    ld      a, (ix+0)
    cp      b
    jr      z, expand_take
    jr      nc, expand_store            ;starts after this column
expand_take:
    ld      d, (ix+1)
    inc     ix
    inc     ix
    dec     c
    jr      expand_pair
expand_store:
    ld      (hl), d
    inc     hl
    inc     b
    ld      a, b
    cp      80
    jr      nz, expand_col
    pop     bc
    pop     ix
    ret


; Rebuild the attribute pairs from expand_buf. If more than 20
; attribute changes are needed on a row then the later ones are lost.
;
; Entry: ix = attribute pairs
; Exit:  ix corrupted
compress:
    ld      hl, expand_buf
    ld      c, 20                       ;pairs left
    ld      a, (hl)
    inc     hl
    ld      (ix+0), 0
    ld      (ix+1), a
    inc     ix
    inc     ix
    dec     c
    ld      d, a                        ;attribute in force
    ld      b, 1                        ;column
compress_loop:
    ld      a, (hl)
    inc     hl
    cp      d
    jr      z, compress_next
    ld      e, a
    ld      a, c
    and     a
    jr      z, compress_pad             ;no pairs left
    ld      (ix+0), b
    ld      (ix+1), e
    inc     ix
    inc     ix
    dec     c
    ld      d, e
compress_next:
    inc     b
    ld      a, b
    cp      80
    jr      nz, compress_loop
compress_pad:
    ld      a, c
    and     a
    ret     z
    ld      (ix+0), 0x80
    ld      (ix+1), 0
    inc     ix
    inc     ix
    dec     c
    jr      compress_pad


generic_console_cls:
    ld      hl, DISPLAY
    ld      c, 25
cls_1:
    ld      b, 80
cls_2:
    ld      (hl), 0
    inc     hl
    djnz    cls_2
    call    clear_row_attribute
    dec     c
    jr      nz, cls_1
    ret


; Entry: hl = attribute pairs of the row
clear_row_attribute:
    ld      (hl), 0                     ;column 0, no attribute
    inc     hl
    ld      (hl), 0
    inc     hl
    ld      b, 19
clear_row_attribute_1:
    ld      (hl), 0x80                  ;terminator
    inc     hl
    ld      (hl), 0
    inc     hl
    djnz    clear_row_attribute_1
    ret


; c = x
; b = y
; a = d = character to print
generic_console_plotc:
    ld      a, d                        ;xypos corrupts de
    call    generic_console_scale
    push    bc
    call    xypos
    pop     bc
    ld      (hl), a
    ld      a, ATTR_SEMIGFX
    jp      set_text_attr


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
    push    de
    call    generic_console_scale
    push    bc
    call    xypos
    pop     bc                          ;coordinates back
    pop     de                          ;d = character to write
    ld      (hl), d                     ;place character
    ld      a, (__pc8001_attr)
    jp      set_text_attr


generic_console_pointxy:
    call    generic_console_vpeek
    and     a
    ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    call    generic_console_scale
    call    xypos
    ld      a, (hl)
    and     a
    ret


generic_console_scale:
    push    af
    ld      a, (__pc8001_mode)
    and     a
    jr      z, no_scale
    sla     c                           ;40 -> 80 column
no_scale:
    pop     af
    ret

; b = y
; Exit: ix = attribute pairs of the row
xypos_attr_row:
    ld      ix, DISPLAY-40
    ld      de, 120
    inc     b
xypos_attr_1:
    add     ix, de
    djnz    xypos_attr_1
    ret


; b = y
; c = x (scaled to 80 columns)
; Exit: hl = address in display
xypos:
    ld      hl, DISPLAY-120
    ld      de, 120
    inc     b
xypos_1:
    add     hl, de
    djnz    xypos_1
    add     hl, bc                      ;b = 0 here
    ret


generic_console_scrollup:
    push    de
    push    bc
    ld      hl, DISPLAY+120
    ld      de, DISPLAY
    ld      bc, 120*24
    ldir
    ex      de, hl                      ;hl = start of last row
    ld      b, 80
generic_console_scrollup_1:
    ld      (hl), 0
    inc     hl
    djnz    generic_console_scrollup_1
    call    clear_row_attribute
    pop     bc
    pop     de
    ret

    SECTION bss_driver

expand_buf:
    defs    80

    SECTION code_crt_init

; N-BASIC normally runs a 20 line screen. Program the CRTC and the DMA
; controller for 25 lines of 80 columns with 20 attribute pairs per row,
; the same sequence as the N-BASIC screen setup (ROM 1.10 $09f9).
; The text VRAM is at $F300, 25 * 120 = 3000 bytes.
    di
    ld      a, ($ea67)                  ;N-BASIC's copy of port $40
    or      $08
    ld      ($ea67), a
    out     ($40), a
vrtc_wait:
    in      a, ($40)
    and     $20
    jr      nz, vrtc_wait
    xor     a
    out     ($51), a                    ;CRTC reset
    ld      a, $80
    out     ($68), a                    ;DMA: no channels enabled
    xor     a
    out     ($64), a                    ;channel 2 address = $F300
    ld      a, $f3
    out     ($64), a
    ld      a, $b7                      ;count = 2999, read transfer
    out     ($65), a
    ld      a, $8b
    out     ($65), a
    ld      a, $ce                      ;CRTC parameters
    out     ($50), a
    ld      a, $98                      ;25 rows
    out     ($50), a
    ld      a, $67
    out     ($50), a
    ld      a, $de
    out     ($50), a
    ld      a, ($ea61)
    and     $40
    or      $13                         ;20 attribute pairs
    out     ($50), a
    ld      a, $43
    out     ($51), a
    ld      a, $c4                      ;DMA: enable channel 2
    out     ($68), a
    ld      a, $20
    out     ($51), a                    ;CRTC start display
    ld      a, ($ea67)
    and     $f7
    ld      ($ea67), a
    out     ($40), a
    ld      a, $80                      ;CRTC: cursor off
    out     ($51), a
    xor     a
    out     ($50), a
    out     ($50), a
    ld      hl, $ea66                   ;N-BASIC's copy of port $30
    set     0, (hl)                     ;80 columns
    ld      a, (hl)
    out     ($30), a
    ei
