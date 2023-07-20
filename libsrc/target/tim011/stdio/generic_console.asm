;
; TM011
;
; Screen resolution 512x256x2bpp
;
; VRAM is accessed via the IO bus from port $8000 onwards
;
; There is a scroll register which affects the top row position
;
; Display bits are reversed with the left hand pixel being bits 0-1 
; in display.
;

    SECTION code_clib

    MODULE tim011_generic_console

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_xypos


    EXTERN  __console_w
    EXTERN  __console_h

    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  generic_console_flags


    EXTERN  __tim011_ink
    EXTERN  __tim011_paper
    EXTERN  __tim011_scroll

    defc    SCROLL_REG = $d0


generic_console_set_paper:
    rrca
    rrca
    and     @11000000
    ld      (__tim011_paper),a
    ret

generic_console_set_attribute:
    ret


generic_console_set_ink:
    rrca
    rrca
    and     @11000000
    ld      (__tim011_ink),a
    ret

generic_console_cls:
    ld      de,+(512 / 4) * 256
    ; This will actually clear from left to right
    ld      bc,$8000
    ld      l,0     ;May want to clear with bg colour?
loop:
    out     (c),l
    inc     bc
    dec     de
    ld      a,d
    or      e
    jr      nz,loop
    ; Reset scroll register
reset_scroll:
    xor     a
    out0    (SCROLL_REG),a
    ld      (__tim011_scroll),a
    ret

generic_console_scrollup:
    push    bc
    push    de
    ld      a,(__tim011_scroll)
    add     8
    ld      (__tim011_scroll),a
    out0    (SCROLL_REG),a
    ld      b,31
    ld      c,0
scrollup_1:
    push    bc
    ld      a,' '
    call    generic_console_printc
    pop     bc
    inc     c
    ld      a,c
    cp      64
    jr      nz,scrollup_1
    pop     de
    pop     bc
    ret

; b = row
; c = column
; a = d = character
generic_console_printc:
    exx
    ld      bc,(generic_console_font32)
    dec     b
    bit     7,a
    jr      z,handle_characters
    ld      bc,(generic_console_udg32)
    res     7,a
handle_characters:
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,bc
    ld      a,(generic_console_flags)
    ld      b,a
    rlca
    sbc     a,a             ; ; c = 0/ c = 255
    ld      c,a
    exx    
    ; bc = b = y, c = x, coordinates to print at
    ; hl' = font
    ; c' = inverse flag
    ; b' = flags
    call    generic_console_xypos
    ; So now hl = VRAM port
    ld      bc,hl


    ld      l,8         ;8 rows
row_loop:
    push    hl
    ld      a,l
    exx
    bit     3,b
    jr      z,printc_no_underline
    cp      1       ;bottom row
    jr      nz,printc_no_underline
    ld      a,255
    jr      printc_not_bold
printc_no_underline:
    ld      a,(hl)
    bit     4,b
    ld      a,(hl)
    jr      z,printc_not_bold
    rrca
    or      (hl)
printc_not_bold:
    xor     c
    inc     hl
    exx
; The byte needs to be reversed now
    ; ld      h,a
    ; rlca
    ; rlca
    ; xor     h
    ; and     0xaa
    ; xor     h
    ; ld      h,a
    ; rlca
    ; rlca
    ; rlca
    ; rrc     h
    ; xor     h
    ; and     0x66
    ; xor     h


    ld      h,2
printc_2:
    ld      de,(__tim011_ink)    ;e = ink, b = paper
    push    hl
    push    bc
    ld      l,a
    ld      b,4    ;4 iterations
    ld      h,0    ;final byte
printc_3:
    rr      l
    ld      a,d
    jr      nc,is_paper
    ld      a,e
is_paper:
    or      h
    ld      h,a
    srl     d
    srl     d
    srl     e
    srl     e
    djnz    printc_3
    ld      a,l    ;Save the character for a moment
    pop     bc
    out     (c),h
    dec     b
    pop     hl
    dec     h
    jr      nz,printc_2
    ; Move to next row of screen
    inc     b
    inc     b
    inc     c
    pop     hl
    dec     l
    jr      nz,row_loop
    ret

; Entry: b = row
;        c = column
; Exit:	hl = address
generic_console_xypos:
    ld      h,c
    sla     h
    inc     h
    set     7,h
    ld      l,b
    sla     l
    sla     l
    sla     l
    ld      a,(__tim011_scroll)
    add     l
    ld      l,a
    ret

    SECTION code_crt_init

    ld      a,64
    ld      (__console_w),a
    ld      a,32
    ld      (__console_h),a
    call    reset_scroll
    ; Disable cursor - this is on a 100ms tick
    ld      a,$c9
    ld      ($e806),a

    SECTION code_crt_exit
    ; Re-enable cursor
    ld      a,$c3
    ld      ($e806),a


