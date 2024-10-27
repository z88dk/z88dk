

    MODULE  generic_console

    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    EXTERN  vpeek_screendollar
    EXTERN  generic_console_printc32
    EXTERN  generic_console_printc64

    defc    generic_console_printc = generic_console_printc64

    EXTERN __cpc_mode
    EXTERN __cpc_ink0
    EXTERN __cpc_paper0
    EXTERN __cpc_ink1
    EXTERN __cpc_paper1
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32

    EXTERN  generic_console_flags
    EXTERN  CRT_FONT

    EXTERN  __MODE1_attr

    defc    SCREEN = 0x4000
    defc    STRIDE = 32
    defc    YMAX = 77
    ;defc    MAXYC = (MAXY / 8)

generic_console_set_attribute:
	ret

generic_console_set_ink:
    and     3
    ld      (__MODE1_attr), a
    ret

generic_console_set_paper:
    and     3
    ld      (__MODE1_attr+1), a
    ret



generic_console_cls:
    ld      hl,SCREEN
    ld      de,SCREEN+1
    ld      bc,+(STRIDE * YMAX) - 1
    ld      (hl),0
    ldir
    ret

generic_console_scrollup:
    push    bc
    push    de
    ld      hl,SCREEN+(STRIDE*8)
    ld      de,SCREEN
    ld      bc,+(STRIDE * (YMAX-8-1))
    ldir
    ld      d,h
    ld      e,l
    inc     de
    xor     a
    ld      bc,STRIDE*8 - 1
    ldir
    pop     de
    pop     bc
    ret








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
    ld      bc, SCREEN
        ; b7   b6   b5   b4   b3   b2   b1   b0
         ; p0-1 p1-1 p2-1 p3-1 p0-0 p1-0 p2-0 p3-0
    ld      c, l
    add     hl, bc                      ;hl = screen
    ex      de, hl
    ld      b, 8
handle_MODE2_per_line:
    push    bc
    push    hl                          ;save buffer
    ld      h, @10000000
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
    srl     h
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
    dec     de
    dec     de
    ld      a, e
    add     32
    ld      e, a
    jr      nc, no_overflow_MODE2
    inc     d
no_overflow_MODE2:
    pop     bc
    djnz    handle_MODE2_per_line
    ;; Think about how to handle 4x8 fonts
    jp      vpeek_screendollar



; 5e8, convert colour to byte
conv_to_byte:
    and       $03                           ;[05e8] e6 03
    push      bc                            ;[05ea] c5
    ld        c,a                           ;[05eb] 4f
    add       a                             ;[05ec] 87
    add       a                             ;[05ed] 87
    add       c                             ;[05ee] 81
    add       a                             ;[05ef] 87
    add       a                             ;[05f0] 87
    add       c                             ;[05f1] 81
    add       a                             ;[05f2] 87
    add       a                             ;[05f3] 87
    add       c                             ;[05f4] 81
    pop       bc                            ;[05f5] c1
    ret