    SECTION code_clib
    PUBLIC  generic_console_vpeek

    EXTERN  screendollar
    EXTERN  screendollar_with_count
    EXTERN  generic_console_xypos_hector1
    EXTERN  generic_console_font32
    EXTERN  generic_console_font64
    EXTERN  generic_console_udg32
    EXTERN  __MODE1_attr
    EXTERN  __console_font_h

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
    call    generic_console_xypos_hector1
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
    ld      a,255
    ld      (__vpeek_colour),a
    ld      a,(__console_font_h)
    ld      b, a
@line_loop:
    push    bc
    push    hl                          ;save buffer
    ld      c, 0                        ;resulting byte
    ld      a, 2                        ;we need to do this loop twice
@byte_loop:
    push    af
    ld      l, @00000011
    ld      a,(__vpeek_colour)
    ld      h,a
    ld      b, 4                        ;4 pixels in a byte
@bit_loop:
    ld      a,h
    inc     a
    jr      nz,@got_paper
    ld      a, (de)
    and     l
    ld      h,a
    ld      (__vpeek_colour),a
@got_paper:
    ld      a, (de)
    and     l
    cp      h
    scf
    jr      nz, @rotate_bit
    ccf
@rotate_bit:
    rl      c
    sla     l
    sla     l
    sla     h
    sla     h
    djnz    @bit_loop
    inc     de
    pop     af
    dec     a
    jr      nz, @byte_loop
    pop     hl                          ;buffer
    ld      (hl), c
    inc     hl
    ld      a, e
    add     HEC_STRIDE - 2 
    ld      e, a
    jr      nc, @next_row_no_overflow
    inc     d
@next_row_no_overflow:
    pop     bc
    djnz    @line_loop


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
@populate_64col:
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
    djnz    @populate_64col
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

    SECTION bss_clib

__vpeek_colour: defb    0