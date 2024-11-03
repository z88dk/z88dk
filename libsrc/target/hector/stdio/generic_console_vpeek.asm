    SECTION code_clib
    PUBLIC  generic_console_vpeek

    EXTERN  screendollar
    EXTERN  screendollar_with_count
    EXTERN  generic_console_font32
    EXTERN  generic_console_font64
    EXTERN  generic_console_udg32

    INCLUDE "target/hector/def/hector1.def"



;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    ld      hl, -8
    add     hl, sp
    ld      sp, hl
    push    hl                          ;Save buffer
    ex      de, hl                      ;get it into de
    ld      h, b                        ; 32 * 8
    ld      l, c
    ld      bc, HEC_SCREEN
        ; b7   b6   b5   b4   b3   b2   b1   b0
         ; p0-1 p1-1 p2-1 p3-1 p0-0 p1-0 p2-0 p3-0
    ld      c, l
    add     hl, bc                      ;hl = screen
    ex      de, hl
    ld      b, 8
handle_MODE2_per_line:
    push    bc
    push    hl                          ;save buffer
    ld      h, @00000001
    ld      c, 0                        ;resulting byte
    ld      a, 2                        ;we need to do this loop twice
handle_mode1_nibble:
    push    af
    ld      l, @11000000
    ld      b, 4                        ;4 pixels in a byte
handle_MODE2_0:
    ld      a, (de)
    and     l
    jr      z, not_set
    ld      a, c
    or      h
    ld      c, a
not_set:
    sla     h
    srl     l
    srl     l
    djnz    handle_MODE2_0
    inc     de
    pop     af
    dec     a
    jr      nz, handle_mode1_nibble
    pop     hl                          ;buffer
    ld      (hl), c
    inc     hl
    ld      a, e
    add     HEC_STRIDE - 2 
    ld      e, a
    jr      nc, no_overflow_MODE2
    inc     d
no_overflow_MODE2:
    pop     bc
    djnz    handle_MODE2_per_line


    ld      hl,(generic_console_font32)
    pop     de              ;the buffer on the stack
    call    screendollar
    jr      nc,gotit
    ld      hl,(generic_console_udg32)
    ld      b,128
    call    screendollar_with_count
    jr      c,try_64col
    add     128
    jr      gotit

try_64col:
    ld      hl,(generic_console_font64)
    push    de
    ex      de,hl
    ; Copy the top nibble to lower nibble
    ; 64 column fonts are stored doubled up
    ld      b,8
copy64:
    ld      a,(hl)
    and     @00001111
    ld      c,a
    rlca
    rlca
    rlca
    rlca
    or      c
    ld      (hl),a
    inc     hl
    djnz    copy64
    ex      de,hl
    pop     de          ;buffer back
    call    screendollar
    jr      nc,gotit
    ;; Try UDGs again - this time only half the character
    ld      hl,(generic_console_udg32)
    ld      b,128
    call    screendollar_with_count
    jr      nc,gotit
    add     128
gotit:
    ex      af,af           ; Save those flags
    ld      hl,8            ; Dump our temporary buffer
    add     hl,sp
    ld      sp,hl
    ex      af,af           ; Flags and parameter back
    ret

