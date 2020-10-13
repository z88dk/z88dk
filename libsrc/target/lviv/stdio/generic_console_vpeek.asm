    MODULE  generic_console_vpeek
    SECTION code_himem
    PUBLIC  generic_console_vpeek

    EXTERN  generic_console_xypos
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  screendollar
    EXTERN  screendollar_with_count

generic_console_vpeek:
    ld      hl,-8
    add     hl,sp
    ld      sp,hl
    push    hl                ;save buffer

    ex      de,hl
    ld      l,0
    ld      h,b      ;x256
    add     hl,hl    ;x512 (8 x 64)
    ld      b,0
    add     hl,bc
    ld      b,$40
    add     hl,bc
    ex      de,hl
    ; de = screen address, hl = buffer
    ; b7   b6   b5   b4   b3   b2   b1   b0
    ; p3-1 p2-1 p1-1 p0-1 p3-0 p2-0 p1-0 p0-0
    ld      a,$fd             ;page vram in
    out     ($c2),a
    ld      b,8
per_line:
    push    bc
    push    hl      ;save buffer
    ld      h,@10000000
    ld      c,0     ;resulting byte
    ld      a,2     ;we need to do this loop twice
per_nibble:
    push    af
    ld      l,@10001000
    ld      b,4     ;4 pixels in a byte
per_byte:
    ld      a,(de)
    and     l
    jp      z,not_set
    ld      a,c
    or      h
    ld      c,a
not_set:
    and     a
    ld      a,h
    rra
    ld      h,a
    and     a
    ld      a,l
    rra
    ld      l,a
    dec     b
    jp      nz,per_byte
    inc     de
    pop     af
    dec     a
    jp      nz,per_nibble
    ld      hl,62           ;Step to next row
    add     hl,de
    ex      de,hl
    pop     hl              ;buffer
    ld      (hl),c
    inc     hl
    pop     bc
    dec     b
    jp      nz,per_line

    ld      a,$ff             ;page vram out
    out     ($c2),a

    pop     de                ;buffer
    ld      hl,(generic_console_font32)
    call    screendollar
    jp      nc,gotit
    ld      hl,(generic_console_udg32)
    ld      b,128
    call    screendollar_with_count
    jp      c,gotit
    add     128
gotit:
    pop     bc
    pop     bc
    pop     bc
    pop     bc
    ret
