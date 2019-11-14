
    SECTION code_clib

    PUBLIC  generic_console_scrollup

    EXTERN  __console_w
    EXTERN  __console_h
    EXTERN  __x1_attr

    defc    DISPLAY = $3000


generic_console_scrollup:
    push    de
    push    bc
    ld      hl, DISPLAY
    ld      de,(__console_w)
    ld      d,0
    add     hl,de
    ld      c,l
    ld      b,h
    ld      a,(__console_h)
    dec     a
    ld      h,a
scroll_loop:
    ld      a,(__console_w)
    ld      l,a
scroll_loop1:
    push    hl
    in      e,(c)
    res     4,b
    in      d,(c)
    set     4,b

    ld      h,b
    ld      l,c
    ld      bc,(__console_w)
    ld      b,0
    and     a
    sbc     hl,bc
    ld      c,l
    ld      b,h

    out     (c),e
    res     4,b
    out     (c),d
    set     4,b
    ld      hl,(__console_w)
    ld      h,0
    inc     hl
    add     hl,bc
    ld      c,l
    ld      b,h
    pop     hl
    dec     l
    jr      nz,scroll_loop1
    dec     h
    jr      nz,scroll_loop

    ld      h,b
    ld      l,c
    ld      bc,(__console_w)
    ld      b,0
    and     a	
    sbc     hl,bc
    ld      e,c	;width
    ld      c,l
    ld      b,h
    ld      d,' '
    ld      a,(__x1_attr)
scroll_loop_2:
    out     (c),d
    res     4,b
    out     (c),a
    set     4,b
    inc     bc
    dec     e
    jr      nz,scroll_loop_2
    pop     bc
    pop     de
    ret