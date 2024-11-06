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
IF FORhector1
    ; 64 column font
    ld      h, b                        ; 32 * 8
    ld      l, c
    ld      bc, HEC_SCREEN
    ld      c, l
    add     hl, bc                      ;hl = screen
ELSE
    ; 32 column font
    ld      h,b                         ;*256
    ld      l,0
    add     hl,hl                       ;*512
    ld      b,0                         ;+x
    add     hl,bc
    ld      b,+(HEC_SCREEN /256)
    add     hl,bc                       ;+x
ENDIF
    ex      de, hl
    ld      b, 8
handle_per_line:
    push    bc
    push    hl                          ;save buffer
    ld      h, @0000000
    ld      c, 0                        ;resulting byte
    ld      a, 2                        ;we need to do this loop twice
handle_nibble:
    push    af
    ld      l, @00000011
    ld      b, 4                        ;4 pixels in a byte
handle_0:
    ld      a, (de)
    and     l
    jr      z, not_set
    scf
not_set:
    rl      c
    sla     l
    sla     l
    djnz    handle_0
    inc     de
    pop     af
    dec     a
    jr      nz, handle_nibble
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
    djnz    handle_per_line


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
    and     @11110000
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

