    ; In code_driver so we are low down in memory and hopefully
    ; never paged out
    SECTION code_driver

    PUBLIC  generic_console_vpeek

    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32

    EXTERN  l_push_di
    EXTERN  l_pop_ei

    EXTERN  __vram_in
    EXTERN  __vram_out
    EXTERN  __port29_copy
    EXTERN  __multi8_mode
    EXTERN  __multi8_paper

    EXTERN  generic_console_xypos_graphics
    EXTERN  generic_console_xypos
    EXTERN  generic_console_scale
    EXTERN  screendollar
    EXTERN  screendollar_with_count


    defc    DISPLAY=0x8000

;Entry: c = x,
;	b = y
;Exit:	nc = success
;	 a = character,
;	 c = failure
generic_console_vpeek:
    ld      a, (__multi8_mode)
    cp      2
    jr      z, vpeek_graphics
    call    generic_console_scale
    call    generic_console_xypos
    call    l_push_di
    ld      a, (__vram_in)
    out     ($2a), a
    ld      b, (hl)
    ld      a, (__vram_out)
    out     ($2a), a
    call    l_pop_ei
    ld      a, b
    and     a
    ret

vpeek_graphics:
    ld      hl, -8
    add     hl, sp                      ;hl = buffer, bc = coords
    ld      sp, hl
    push    hl                          ;Save buffer
    call    l_push_di

    push    hl
    call    generic_console_xypos_graphics
                                        ; hl = screen
    pop     de                          ; de = buffer

    ld      a,255
    ld      (__vpeek_colour),a
    ld      a, 8
@row_loop:
    push    af
    push    de                          ;push buffer
    ld      a, (__vram_in)
    ld      b, a
    or      @00000110                   ;blue
    out     ($2a), a
    ld      d,(hl)
    ld      a, b
    or      @00000101                   ;green
    out     ($2a), a
    ld      e,(hl)
    ld      a,b

    or      @00000011                   ;red
    out     ($2a), a
    ld      a,(hl)

    ld      bc,80
    add     hl,bc                       ;Move to next row
    ld      c,a                         ;red value
    ex      (sp),hl                     ;(sp) = next row, hl = buffer
    push    hl


    ld      a,(__vpeek_colour)
    ld      h,a
    ld      l,0                         ;resulting row

    ; Now create a colour byte for each pixel
    ld      b,8
@create_bytes:
    xor     a
    rl      c
    rla
    rl      e
    rla
    rl      d
    rla
    push    bc
    ld      b,a
    ld      a,h
    inc     a
    jr      nz,@paper_set
    ld      a,b
    ld      (__vpeek_colour),a
    ld      h,a
@paper_set:
    ld      a,b
    pop     bc
    cp      h                           ;current background?
    scf
    jr      nz,@rotate_bit
    ccf
@rotate_bit:
    rl      l
    djnz    @create_bytes
    pop     de                          ;de=buffer
    ld      a,l
    ld      (de),a
    inc     de
    pop     hl                          ;screen



    pop     af
    dec     a
    jr      nz, @row_loop
    ld      a, (__vram_out)
    out     ($2a), a
    call    l_pop_ei

    pop     de                          ;de = buffer of stack
    ld      hl, (generic_console_font32)
    call    screendollar
    jr      nc, gotit
    ld      hl, (generic_console_udg32)
    ld      b, 128
    call    screendollar_with_count
    jr      c, gotit
    add     128
gotit:
    ex      af, af
    ld      hl, 8
    add     hl, sp
    ld      sp, hl
    ex      af, af
    ret

    SECTION bss_driver

__vpeek_colour: defb    0





