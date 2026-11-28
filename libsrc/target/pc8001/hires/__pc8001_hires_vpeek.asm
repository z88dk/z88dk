
; Read back a bitmapped character. The cell is turned into an 8 byte glyph
; and matched against the font and the UDGs by the shared vpeek_screendollar,
; which also finds inverse characters. Characters printed bold or underlined
; are not found.
;
; Entry: c = x, b = y, e = raw
; Exit:  nc, a = character
;        c if no character matches

    INCLUDE "target/pc8001/hires/gvram.inc"
    INCLUDE "target/pc8001/hires/allram_only.inc"

    SECTION code_driver
    PUBLIC  __pc8001_hires_vpeek
    EXTERN  vpeek_screendollar
    EXTERN  __pc8001_gfxmode
    EXTERN  __pc8001_paper
    EXTERN  __pc8001_hires_addr
    EXTERN  l_push_di
    EXTERN  l_pop_ei

__pc8001_hires_vpeek:
    call    __pc8001_hires_addr         ;hl = cell
    ld      a, (__pc8001_gfxmode)
    ld      c, a                        ;1 or 2 bytes per row
    ld      a, (__pc8001_paper)
    ex      af, af'                     ;a' = paper
    ex      de, hl                      ;de = cell
    ld      hl, -24
    add     hl, sp
    ld      sp, hl                      ;[raw rows, 16 bytes] [glyph, 8 bytes]
    ex      de, hl                      ;hl = cell, de = raw rows
    ld      b, 8
    call    l_push_di
    out     ($5c), a                    ;Plane 0
read_loop:
    ld      a, (hl)
    ld      (de), a
    inc     de
    bit     1, c
    jr      z, read_next
    inc     hl
    ld      a, (hl)
    ld      (de), a
    inc     de
    dec     hl
read_next:
    ld      a, l
    add     a, 80
    ld      l, a
    jr      nc, read_nc
    inc     h
read_nc:
    djnz    read_loop
    out     ($5f), a                    ;Back to main memory
    call    l_pop_ei

    ld      hl, 0
    add     hl, sp                      ;hl = raw rows
    ld      de, 16
    ex      de, hl
    add     hl, sp
    ex      de, hl                      ;de = the glyph
    bit     1, c
    jr      nz, pack_colour
    ld      b, 8                        ;640x200 is already one bit per pixel
copy_loop:
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    djnz    copy_loop
    jr      call_screendollar

pack_colour:
    ; 4 colour: turn the two bytes of each row into one byte, with a bit set
    ; for each pixel that isn't the paper colour
    ex      af, af'
    ld      c, a                        ;c = paper
    ld      b, 8
pack_loop:
    push    bc
    exx
    ld      l, 0                        ;l' = the result
    exx
    ld      a, (hl)
    inc     hl
    call    pack_four
    ld      a, (hl)
    inc     hl
    call    pack_four
    exx
    ld      a, l
    exx
    ld      (de), a
    inc     de
    pop     bc
    djnz    pack_loop

call_screendollar:
    ld      hl, 16                      ;drop the raw rows
    add     hl, sp
    ld      sp, hl
    ; vpeek_screendollar wants [buffer address] [buffer] [return address]
    ld      hl, 0
    add     hl, sp
    push    hl
    jp      vpeek_screendollar

; a = four pixels in the top of the byte, c = paper, l' = result so far
; The result is shifted left once for each pixel
pack_four:
    push    bc
    push    de
    ld      e, c
    ld      b, 4
pack_pixel:
    ld      d, a
    rlca
    rlca
    and     3
    xor     e
    add     a, 255                      ;carry if it isn't the paper
    exx
    ld      a, l
    rla
    ld      l, a
    exx
    ld      a, d
    add     a, a
    add     a, a
    djnz    pack_pixel
    pop     de
    pop     bc
    ret
