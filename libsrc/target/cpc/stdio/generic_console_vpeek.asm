

    MODULE  generic_console_vpeek
    SECTION code_driver
    EXTERN  generic_console_calc_screen_address
    PUBLIC  generic_console_vpeek

    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  __cpc_mode
    EXTERN  screendollar
    EXTERN  screendollar_with_count
    EXTERN  __cpc_paper0
    EXTERN  __cpc_paper1
    

generic_console_vpeek:
    call    generic_console_calc_screen_address
	; hl = screen address
    ex      de, hl
    ld      hl, -8
    add     hl, sp
    ld      sp, hl
    push    hl                          ;save buffer
    ld      a,255
    ld      (__vpeek_colour),a
    ld      a, (__cpc_mode)
    cp      2
    jp      z, handle_mode_2
    and     a
    jp      z, handle_mode_0

handle_mode_1:
	 ; b7   b6   b5   b4   b3   b2   b1   b0
         ; p0-1 p1-1 p2-1 p3-1 p0-0 p1-0 p2-0 p3-0
    ld      b, 8
@row_loop:
    push    bc
    push    hl                          ;save buffer
    ld      c, 0                        ;resulting byte
    ld      a, 2                        ;we need to do this loop twice
@nibble_loop:
    push    af
    ld      a,(__vpeek_colour)
    ld      h,a
    ld      l, @10001000
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
;    jr      z, @rotate_bit
    cp      h
    scf
    jr      nz,@rotate_bit
    ccf
@rotate_bit:
    rl      c
    srl     h
    srl     l
    djnz    @bit_loop
    inc     de
    pop     af
    dec     a
    jr      nz, @nibble_loop
    pop     hl                          ;buffer
    ld      (hl), c
    inc     hl
    dec     de
    dec     de
    ld      a, d
    add     8
    ld      d, a
    pop     bc
    djnz    @row_loop
    jr      do_screendollar



        ; b7    b6    b5    b4    b3    b2    b1    b0
        ; p0-b0 p1-b0 p0-b2 p1-b2 p0-b1 p1-b1 p0-b3 p1-b3
handle_mode_0:
    ld      b, 8                        ;number of rows
@row_loop:
    push    bc
    ld      c, 0                        ;final byte
    push    hl                          ;save buffer
    ld      a, 4
@nibble_loop:
    push    af
	; 4 bytes in total
 	; 2x for each byte
    ld      a,(__vpeek_colour)
    ld      h,a
    ld      l, @10101010
    ld      b, 2
@bit_loop:
    ld      a,h
    cp      255
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
    srl     l
    srl     h
    djnz    @bit_loop
    inc     de
    pop     af
    dec     a
    jr      nz, @nibble_loop
    pop     hl
    ld      (hl), c
    inc     hl
    dec     de
    dec     de
    dec     de
    dec     de
    ld      a, d
    add     8
    ld      d, a
    pop     bc
    djnz    @row_loop
    jr      do_screendollar

handle_mode_2:
    ld      b, 8
@row_loop:
    ld      a, (de)
    ld      (hl), a
    inc     hl
    ld      a, d
    add     8
    ld      d, a
    djnz    @row_loop
do_screendollar:
    pop     de                          ;buffer
    ld      hl, (generic_console_font32)
    call    screendollar                ;exits with de = buffer
    jr      nc, @gotit
    ld      hl, (generic_console_udg32)
    ld      b, 128
    call    screendollar_with_count
    jr      c, @gotit
    add     128
@gotit:
    ex      af, af
    ld      hl, 8
    add     hl, sp
    ld      sp, hl
    ex      af, af
    ret

    SECTION bss_driver

__vpeek_colour: defb    0