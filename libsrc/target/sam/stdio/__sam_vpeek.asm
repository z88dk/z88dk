; vpeek() for the Sam Coupe
;
; As with other targets, this won't work if the background isn't palette 0

    MODULE  __zx_vpeek
    SECTION code_driver
    PUBLIC  __sam_vpeek
    EXTERN  __zx_vpeek

    EXTERN  screendollar
    EXTERN  screendollar_with_count
    EXTERN  __zx_32col_udgs
    EXTERN  __zx_32col_font
    EXTERN  __zx_screenmode
    EXTERN  __sam_xypos_MODE3
    EXTERN  __sam_xypos_MODE4
    EXTERN  __sam_graphics_pagein
    EXTERN  __sam_graphics_pageout
    EXTERN  __sam_MODE4_attr
    EXTERN  __sam_MODE3_attr
    


    EXTERN  SCREEN_BASE


__sam_vpeek:
    ld      a,255
    ld      (__vpeek_colour),a
    ld      a, (__zx_screenmode)
    and     a
    jp      z, __zx_vpeek               ; Just use the regular +zx code
    ld      hl, -8
    add     hl, sp                      ;de = screen, hl = buffer, bc = coords
    ld      sp, hl
    push    hl                          ;Save buffer
    ex      de, hl                      ;get it into de
    dec     a
    jp      z, vpeek_MODE2
    dec     a
    jr      z, vpeek_MODE3
    ; Lets handle mode 4 here
vpeek_MODE4:
    call    __sam_xypos_MODE4
    call    __sam_graphics_pagein
    ld      b, 8
@row_loop:
    push    bc
    push    de                          ;Save buffer
    ld      a,(__vpeek_colour)
    ld      d,a
    ld      c, 0                        ;Resultant byte
    ld      a, 4                        ;4 bytes to do
@nibble_loop:
    ex      af, af
    ;; See if paper has been set
    bit     0,d
    jr      z,@got_paper
    ld      a, (hl)
    and     @11110000
    ld      d,a
    ld      (__vpeek_colour),a
@got_paper:
    ld      a, (hl)
    and     @11110000
    cp      d
    scf
    jr      nz,@rotate_bit_in1
    ccf
@rotate_bit_in1:
    rl      c
    ld      a, (hl)
    rlca
    rlca
    rlca
    rlca
    and     @11110000
    cp      d
    scf
    jr      nz,@rotate_bit_in2
    ccf
@rotate_bit_in2:
    rl      c
    inc     hl
    ex      af, af
    dec     a
    jr      nz, @nibble_loop
    pop     de
    ld      a, c
    ld      (de), a
    inc     de
    ld      bc, 128-4
    add     hl, bc
    pop     bc
    djnz    @row_loop

do_screendollar:
    call    __sam_graphics_pageout
    pop     de                          ;the buffer on the stack
    ld      hl, (__zx_32col_font)
    call    screendollar
    jr      nc, gotit
    ld      hl, (__zx_32col_udgs)
    ld      b, 128
    call    screendollar_with_count
    jr      c, gotit
    add     128
gotit:
    ex      af, af                      ; Save those flags
    ld      hl, 8                       ; Dump our temporary buffer
    add     hl, sp
    ld      sp, hl
    ex      af, af                      ; Flags and parameter back
    ret

vpeek_MODE3:
    call    __sam_xypos_MODE3
    call    __sam_graphics_pagein
    ld      b, 8
@row_loop:
    push    bc
    push    de                          ;Save buffer
    ld      c, 0                        ;Resultant byte
    ld      a, 2                        ;We need to do this loop twice
@byte_loop:
    ex      af, af
    ld      a,(__vpeek_colour)
    ld      d,a
    ld      e, @11000000
    ld      b, 4                        ;4 interations
@bit_loop:
    ;; See if paper has been set
    ld      a,d
    inc     a
    jr      nz,@got_paper
    ld      a, (hl)
    and     e
    ld      d,a
    ld      (__vpeek_colour),a
@got_paper:
    ld      a, (hl)
    and     e
    cp      d
    scf
    jr      nz,@rotate_bit_in
    ccf
@rotate_bit_in:
    rl      c
    srl     d
    srl     d
    srl     e
    srl     e
    djnz    @bit_loop
    inc     hl
    ex      af, af
    dec     a
    jr      nz, @byte_loop
    pop     de                          ;Buffer
    ld      a, c
    ld      (de), a
    inc     de
    ld      bc, 128-2
    add     hl, bc
    pop     bc
    djnz    @row_loop
    jr      do_screendollar

vpeek_MODE2:
    ; Each character row is 8*32 = 256 bytes
    ld      a, +(SCREEN_BASE/256)
    add     b
    ld      h, a
    ld      l, c
    call    __sam_graphics_pagein
    ld      b, 8
@row_loop:
    ld      a, (hl)
    ld      (de), a
    inc     de
    ld      a, 32
    add     l
    ld      l, a
    ld      a, h
    adc     0
    ld      h, a
    djnz    @row_loop
    jr      do_screendollar

    SECTION bss_driver

__vpeek_colour: defb    0