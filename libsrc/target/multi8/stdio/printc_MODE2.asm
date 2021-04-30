    SECTION    code_clib
    PUBLIC    printc_MODE2
    PUBLIC    generic_console_xypos_graphics

    EXTERN    __multi8_ink
    EXTERN    __multi8_paper
    EXTERN    generic_console_font32
    EXTERN    generic_console_udg32
    EXTERN    generic_console_flags
    EXTERN    __vram_in

    EXTERN    l_push_di
    EXTERN    l_pop_ei

    defc    DISPLAY = 0x8000



    INCLUDE "target/pc88/def/pc88.def"

printc_MODE2:
    ld      a,d
    call    generic_console_xypos_graphics
    ex      de,hl
    ld      bc,(generic_console_font32)
    ld      l,a
    ld      h,0
    bit     7,l
    jr      z,not_udg
    res     7,l
    ld      bc,(generic_console_udg32)
    inc     b
not_udg:
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,bc
    dec     h               ;-32 characters


    ld      a,(generic_console_flags)
    ld      b,a
    rlca            ;get bit 7 out
    sbc     a
    ld      c,a     ; c = 0/ c = 255
    exx

    ;de' = screen
    ;hl' = font
    ;b' = flags
    ;c' = inverse xor

    call    l_push_di

printc_skip_v2_setup:
    ld      b,8
loop:
    push    bc
    ld      a,b
    exx
    cp      1
    jr      nz,not_last_row
    ; It's not the last row, check for bold
    bit     3,b
    jr      z,not_last_row
    ld      a,255        ;Underline
    jr      no_bold
not_last_row:
    bit     4,b
    ld      a,(hl)        ;pick up font form main memory
    jr      z,no_bold
    rrca
    or      (hl)
no_bold:
    xor     c
    inc     hl      ;Move to next row in font
    exx

    ld      h,a        ;save ink version
    cpl
    ld      l,a        ;save paper version

    ld      de,(__multi8_ink)
    ld      a,(__vram_in)
    ld      b,a
 
    ;Consider the blue plane
    rrc     e    ;Ink
    ld      a,e
    sbc     a,a    ;= 255 if it was set
    and     h
    ld      c,a    ;Contains ink blue to be set
    rrc     d    ;paper
    ld      a,d
    sbc     a,a    ;255 if set, 0 = if not set
    and     l
    or      c    ;So now we have the blue byte

    ex      af,af
    ld      a,b
    or      @00000110
    out     ($2a),a
    ex      af,af
    exx
    ld      (de),a    ;And write it
    exx

    ;Consider the green plane
    rrc     e    ;Ink
    ld      a,e
    sbc     a,a    ;= 255 if it was set
    and     h
    ld      c,a    ;Contains ink blue to be set
    rrc     d    ;paper
    ld      a,d
    sbc     a,a    ;255 if set, 0 = if not set
    and     l
    or      c    ;So now we have the blue byte

    ex      af,af
    ld      a,b
    or      @00000011
    out     ($2a),a
    ex      af,af
    exx
    ld      (de),a    ;And write it
    exx

    ;Consider the red plane
    rrc     e    ;Ink
    ld      a,e
    sbc     a,a    ;= 255 if it was set
    and     h
    ld      c,a    ;Contains ink blue to be set
    rrc     d    ;paper
    ld      a,d
    sbc     a,a    ;255 if set, 0 = if not set
    and     l
    or      c    ;So now we have the blue byte

    ex      af,af
    ld      a,b
    or      @00000101
    out     ($2a),a
    ex      af,af
    exx
    ld      (de),a    ;And write it
    exx

    ; Back to main memory
    ex      af,af
    ld      a,b
    out     ($2a),a
    ex      af,af

printc_next_row:
    exx
    ex      de,hl
    push    bc
    ld      bc,80    ;Next row
    add     hl,bc
    ex      de,hl
    pop     bc
    exx
    pop     bc
    djnz    loop
    call    l_pop_ei
    ret


generic_console_xypos_graphics:
    ld      hl, DISPLAY - 80 * 8
    ld      de, 80 * 8
    inc     b
generic_console_xypos_graphics_1:
    add     hl,de
    djnz    generic_console_xypos_graphics_1
    add     hl,bc
    ret

