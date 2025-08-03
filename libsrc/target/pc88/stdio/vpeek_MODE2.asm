	; In code_driver so we are low down in memory and hopefully
	; never paged out
    SECTION code_driver

    PUBLIC  vpeek_MODE2

    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32

    EXTERN  l_push_di
    EXTERN  l_pop_ei

    EXTERN  generic_console_xypos_graphics
    EXTERN  screendollar
    EXTERN  screendollar_with_count
    EXTERN  __pc88_paper

    INCLUDE "target/pc88/def/pc88.def"


;Entry: c = x,
;	b = y
;Exit:	nc = success
;	 a = character,
;	 c = failure
vpeek_MODE2:
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
    push    de

    out     (GVRAM_SEL_0), a            ;Switch to blue
    ld      d,(hl)
    out     (GVRAM_SEL_1), a            ;Switch to green
    ld      e,(hl)
    out     (GVRAM_SEL_2), a            ;Switch to red
    ld      a,(hl)
    out     (MAINRAM_SEL), a            ;Switch to main
    ld      bc, 80                      ;Move to next row
    add     hl, bc
    ld      c,a
    ; hl is now setup for the next row
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



