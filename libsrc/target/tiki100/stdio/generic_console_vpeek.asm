

    MODULE  generic_console_vpeek
    SECTION code_graphics

    PUBLIC  generic_console_vpeek

    EXTERN  generic_console_xypos
    EXTERN  generic_console_get_mode
    EXTERN  screendollar
    EXTERN  screendollar_with_count
    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out

    EXTERN  __MODE2_attr
    EXTERN  __MODE3_attr
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32



generic_console_vpeek:
    ld      hl, -8
    add     hl, sp                      ;de = screen, hl = buffer, bc = coords
    ld      sp, hl
    push    hl                          ;Save buffer
    ex      de, hl                      ;get it into de
    ld      a,255
    ld      (__vpeek_colour),a
    call    __gfx_vram_page_in
    call    generic_console_xypos
    call    generic_console_get_mode
    ex      af, af
    ld      b, 8
vpeek_1:
    push    bc
    ex      af, af
    cp      1
    call    z, vpeek_MODE1
    cp      2
    call    z, vpeek_MODE2
    cp      3
    call    z, vpeek_MODE3
    ex      af, af
	; And mirror it
    ld      c, a
    rlca
    rlca
    xor     c
    and     0xaa
    xor     c
    ld      c, a
    rlca
    rlca
    rlca
    rrc     c
    xor     c
    and     0x66
    xor     c
    ld      (de), a
    inc     de
    pop     bc
    djnz    vpeek_1
    call    __gfx_vram_page_out
    pop     de                          ;the buffer on the stack
    ld      hl, (generic_console_font32)
do_screendollar:
    call    screendollar
    jr      nc, gotit
    ld      hl, (generic_console_udg32)
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

vpeek_MODE1:
    ex      af, af
    ld      a, (hl)
    ld      bc, 128
    add     hl, bc
    ex      af, af
    ret

vpeek_MODE2:
    ex      af, af
    push    de
    ld      c, 0                        ;resulting byte
    ld      a, 2                        ;Loop twice
@nibble_loop:
    push    af
    ld      a,(__vpeek_colour)          ;bits 0,1 occupied
    ld      d,a
    ld      e, @00000011
    ld      b, 4                        ;4 pixels in a byte
@bit_loop:
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
    jr      nz,@rotate_bit              ;it's ink
    ccf
@rotate_bit:
    rr      c
    sla     d
    sla     d
    sla     e
    sla     e
    djnz    @bit_loop
    inc     hl
    pop     af
    dec     a
    jr      nz, @nibble_loop
    ld      a, c                        ;Byte to return
    ld      bc, 126
    add     hl, bc
    pop     de
    ex      af, af
    ret

vpeek_MODE3:
    ex      af, af
    push    de
    ld      c, 0                        ;resulting byte
    ld      a,(__vpeek_colour)          ;bits 0-3
    ld      d,a
    ld      b, 4
@byte_loop:
    ld      a,d
    inc     a
    jr      nz,@got_paper
    ld      a, (hl)
    and     15
    ld      d,a
    ld      (__vpeek_colour),a
@got_paper:
    ld      a, (hl)
    and     15
    cp      d
    scf
    jr      nz, @bit_rotate_in1
    ccf
@bit_rotate_in1:
    rr      c
    ld      a, (hl)
    rrca
    rrca
    rrca
    rrca
    and     15
    cp      d
    scf
    jr      nz, @bit_rotate_in2
    ccf
@bit_rotate_in2:
    rr      c
    inc     hl
    djnz    @byte_loop
    ld      a, c
    ld      bc, 124
    add     hl, bc
    pop     de
    ex      af, af
    ret

    SECTION bss_graphics

__vpeek_colour: defb    0
