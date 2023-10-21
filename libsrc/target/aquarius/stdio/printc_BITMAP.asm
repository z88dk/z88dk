

SECTION code_clib

PUBLIC  printc_BITMAP


EXTERN  xypos_BITMAP
EXTERN  xypos_BITMAP_ATTR

EXTERN  generic_console_font32
EXTERN  generic_console_udg32
EXTERN  generic_console_flags
EXTERN  __aquarius_attr

EXTERN  __aquarius_video_pagein
EXTERN  __aquarius_video_pageout

; b = y
; c = x
; a=d = character to print
; e = raw mode (ignored)
printc_BITMAP:
    call    __aquarius_video_pagein
    push    bc
    ld      l,d
    ld      h,0
    ld      de,(generic_console_font32)
    bit     7,l
    jr      z,not_udg
    res     7,l     ;take off 128
    ld      de,(generic_console_udg32)
    inc     d       ;We decrement later
not_udg:
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,de
    dec     h       ; -32 characters
    ex      de,hl   ; de = font
    call    xypos_BITMAP
    ld      a,(generic_console_flags)
    rlca
    sbc     a,a
    ld      c,a		;x = 0 / 255
    ld      b,8
hires_printc_1:
    push    bc
    ld      a,(generic_console_flags)
    bit     4,a
    ld      a,(de)
    ld      b,a
    jr      z,no_32_bold
    rrca
    or      b
no_32_bold:
    xor     c
    ld      (hl),a
    inc     de
    ld      bc,40
    add     hl,bc
no_overflow:
    pop     bc
    djnz    hires_printc_1
    ; Consider underline
    ld      a,(generic_console_flags)
    bit     3,a
    jr      z,do_attribute
    ld      bc,-40
    add     hl,bc
    ld      (hl),255
    ; Now we need to handle the attribute
do_attribute:
    pop     bc
    call    xypos_BITMAP_ATTR
    ld      a,(__aquarius_attr)
    ld      (hl),a

    call    __aquarius_video_pageout
    ret



