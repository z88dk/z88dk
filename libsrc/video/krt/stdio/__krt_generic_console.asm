;
; KRT graphics mode
;
; Reusable for z1013 and z9001

    SECTION code_driver

    PUBLIC  __krt_cls
    PUBLIC  __krt_printc
    PUBLIC  __krt_scrollup
    PUBLIC  __krt_vpeek

    EXTERN  KRT_PORT
    EXTERN  KRT_ADDRESS
    EXTERN  KRT_COLUMNS
    EXTERN  KRT_ROWS
    EXTERN  KRT_ENABLE
    EXTERN  KRT_BANK_SELECTOR
    EXTERN  KRT_BANK_SELECTOR
    EXTERN  KRT_CLS_FILL

    EXTERN  vpeek_screendollar
    EXTERN  __krt_hook_set_colour
    EXTERN  __krt_hook_cls_colour
    EXTERN  __krt_hook_scrollup_colour


    EXTERN  generic_console_flags
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32

__krt_cls:
    ld      a,KRT_ENABLE
    out     (KRT_PORT),a
    ld      b,8
cls1:
    push    bc
    ld      a,8
    sub     b
    or      KRT_BANK_SELECTOR
    out     (KRT_PORT),a
    ld      hl,KRT_ADDRESS
    ld      de,KRT_ADDRESS + 1
    ld      bc,+(KRT_COLUMNS * KRT_ROWS)
    ld      (hl),KRT_CLS_FILL
    ldir    
    pop     bc
    djnz    cls1
    ld      a,KRT_BANK_SELECTOR
    out     (KRT_PORT),a
    call    __krt_hook_cls_colour
    ret


__krt_printc:
    call    xypos
    ex      de,hl           ;de = destination
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
    ex      de,hl           ;hl = screen, de = font
    ld      a,(generic_console_flags)
    rlca
    sbc     a
    xor     KRT_CLS_FILL    ;take into account how we're filling initially
    ld      c,a             ;c = 0/c = 255 = inverse
    ld      b,8
loop:
    push    bc
    ld      a,8
    sub     b
    or      KRT_BANK_SELECTOR
    out     (KRT_PORT),a

    ld      a,(generic_console_flags)
    bit     4,a
    ld      a,(de)
    jr      z,not_bold
    ld      b,a
    rrca
    or      b
not_bold:
    xor     c
    ld      (hl),a
    inc     de
    pop     bc
    djnz    loop
    ld      a,KRT_BANK_SELECTOR
    out     (KRT_PORT),a
    ld      a,(generic_console_flags)
    bit     3,a
    jp      z,__krt_hook_set_colour
    ld      (hl),255
    call    __krt_hook_set_colour
    ret




;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;      [c] = failure
__krt_vpeek:
    ld      hl,-8
    add     hl,sp           ;de = screen, hl = buffer, bc = coords
    ld      sp,hl
    push    hl              ;Save buffer
    push    hl
    call    xypos
    pop     de

    ld      b,8
vpeek_1:
    ld      a,8
    sub     b
    or      KRT_BANK_SELECTOR
    out     (KRT_PORT),a
    ld      a,(hl)
    ld      (de),a
    inc     de
    djnz    vpeek_1
    ld      a,KRT_BANK_SELECTOR
    out     (KRT_PORT),a
    jp      vpeek_screendollar
 

__krt_scrollup:
    push    bc
    push    de
    ld      b,8
scroll1:
    push    bc
    ld      a,8
    sub     b
    or      KRT_BANK_SELECTOR
    out     (KRT_PORT),a

    ld      hl,KRT_ADDRESS + KRT_COLUMNS
    ld      de,KRT_ADDRESS
    ld      bc,+(KRT_COLUMNS * KRT_ROWS) - KRT_COLUMNS
    ldir
    xor     a
    ld      b,KRT_COLUMNS
scroll2:
    ld      (de),a
    inc     de
    djnz    scroll2
    pop     bc
    djnz    scroll1
    ld      a,KRT_BANK_SELECTOR
    out     (KRT_PORT),a
    call    __krt_hook_scrollup_colour

    pop     de
    pop     bc
    ret


xypos:
    ld      hl,KRT_ADDRESS - KRT_COLUMNS
    ld      de,KRT_COLUMNS
    inc     b
xypos_1:
    add     hl,de
    djnz    xypos_1
    add     hl,bc           ;hl now points to address in display
    ret
 

