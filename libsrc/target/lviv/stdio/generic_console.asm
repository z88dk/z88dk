

    SECTION   code_himem

    PUBLIC    generic_console_cls
    PUBLIC    generic_console_printc
    PUBLIC    generic_console_scrollup
    PUBLIC    generic_console_set_ink
    PUBLIC    generic_console_set_paper
    PUBLIC    generic_console_set_attribute
    PUBLIC    generic_console_xypos

    EXTERN    CONSOLE_COLUMNS
    EXTERN    CONSOLE_ROWS
    EXTERN    generic_console_font32
    EXTERN    generic_console_udg32
    EXTERN    generic_console_flags
    EXTERN    conio_map_colour
    EXTERN    __lviv_ink
    EXTERN    __lviv_paper


generic_console_set_paper:
    and     3
    call    convert_to_mode
    ld      (__lviv_paper),a
    ret

generic_console_set_attribute:
    ret


generic_console_set_ink:
    and     3
    call    convert_to_mode
    ld      (__lviv_ink),a
    ret


generic_console_scrollup:
    push    bc
    push    de
    ld      a,$fd	;Page VRAM in
    out     ($c2),a
    ld      hl,16384 + 512
    ld      de,16384
    ld      bc,16384 - 512
scroll1:
    ld      a,(hl)
    ld      (de),a
    inc     hl
    inc     de
    dec     bc
    ld      a,b
    or      c
    jp      nz,scroll1
    ld      a,$ff	;Page VRAM out
    out     ($c2),a
    ld      bc,$1f00
scroll2:
    push    bc
    ld      d,' '
    call    generic_console_printc
    pop     bc
    inc     c
    ld      a,c
    cp      32
    jp      nz,scroll2
    pop     de
    pop     bc
    ret

generic_console_cls:
    ld      hl,16384
    ld      b,4
    ld      a,(__lviv_paper)
    ld      d,a
    rlca
    or      d
    rlca
    or      d
    rlca
    or      d
    ; Page in
    ld      e,a
    ld      a,$fd
    out     ($c2),a
    
    ld      bc,16384
cls1:
    ld      (hl),e
    inc     hl
    dec     bc
    ld      a,b
    or      c
    jp      nz,cls1
    ;Page out
    ld      a,$ff
    out     ($c2),a
    ret

generic_console_printc:
    ld      e,d
    ld      d,0
    ld      a,e
    ld      hl,(generic_console_font32)
    rlca
    jr      nc,not_udg
    ld      a,e
    and     127
    ld      e,a
    ld      hl,(generic_console_udg32)
    inc     h               ;We decrement later
not_udg:
    ex      de,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,de
    dec     h               ; -32 characters
    ex      de,hl           ; de = font
    call    generic_console_xypos    ;hl = screen
    ex      de,hl

    ;hl = font, de = screen

    ; Setup inverse flag
    ld      a,(generic_console_flags)
    rlca
    sbc     a
    ld      c,a
    ld      b,8
printc_1:
    push    bc
    ld      a,b
    cp      1
    jr      nz,no_need_for_underline
    ld      a,(generic_console_flags)
    and     @00001000
    jr      z,no_need_for_underline
    ld      a,255
    jr      not_bold
no_need_for_underline:
    ld      a,(generic_console_flags)
    and     @00010000
    ld      a,(hl)
    jr      z,not_bold
    rrca
    or      (hl)
not_bold:
    xor     c        ;Add in inverse
    ld      c,a      ;Holds character to print
    push    hl
    push    de       ;Screen address
    ld      hl,(__lviv_ink)    ;l = ink, h = paper
    ld      b,4
    ld      d,0    ;final attribute
loop1:
    ld      a,c
    rla
    ld      c,a
    ld      a,h    ;paper
    jr      nc,is_paper_1
    ld      a,l
is_paper_1:
    or      d
    ld      d,a

    ; Rotate the colours
    ld      a,l
    rra
    ld      l,a
    and     a
    ld      a,h
    rra
    ld      h,a
    dec     b
    jp      nz,loop1
    ld      a,$fd	;Page VRAM in
    out     ($c2),a
    ld      a,d
    pop     de
    ld      (de),a
    ld      a,$ff	;Page VRAM out
    out     ($c2),a
    inc     de
    push    de
; And now second half of the character
    ld      hl,(__lviv_ink)    ;l = ink, h = paper
    ld      b,4
    ld      d,0    ;final attribute
loop2:
    ld      a,c
    rla
    ld      c,a
    ld      a,h    ;paper
    jr      nc,is_paper_2
    ld      a,l
is_paper_2:
    or      d
    ld      d,a

    ; Rotate the colours
    ld      a,l
    rra
    ld      l,a
    and     a
    ld      a,h
    rra
    ld      h,a
    dec     b
    jp      nz,loop2
    ld      a,$fd	;Page VRAM in
    out     ($c2),a
    ld      a,d
    pop     de
    ld      (de),a
    ld      a,$ff	;Page VRAM out
    out     ($c2),a
    ld      hl,63
    add     hl,de
    ex      de,hl
    pop     hl    ;font
    inc     hl
    pop     bc    ;loop + inverse
    dec     b
    jp      nz,printc_1
    ret




    
    



; Entry: b = row
;     c = column
; Exit:    hl = address
generic_console_xypos:
    ; Each row is 64 bytes long (32x32 chars)
    ld      l,0
    ld      h,b      ;x256
    add     hl,hl    ;x512 (8 x 64)
    ld      b,0
    add     hl,bc
    ld      b,$40
    add     hl,bc
    ret

convert_to_mode:
    ld      hl,mode_table
    ld      c,a
    ld      b,0
    add     hl,bc
    ld      a,(hl)
    ret

; p0-1 p1-1 p2-1 p3-1 p0-0 p1-0 p2-0 p3-0
mode_table:
    defb    @00000000
    defb    @00001000
    defb    @10000000
    defb    @10001000

