

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
    ld      b,a
    rlca
    sbc     a,a
    ld      c,a     ; c = 0 / 255: the xor mask, for inverse
    bit     4,b
    ld      b,8     ; (not affecting the flag)
    jr      z,row

    ; bold: each row is ORed with itself shifted right
bold_row:
    push    bc
    ld      a,(de)
    ld      b,a
    rrca
    or      b
    xor     c
    ld      (hl),a
    inc     de
    ld      bc,40
    add     hl,bc
    pop     bc
    djnz    bold_row
    jr      underline

    ; plain and inverse, the usual case: one loop, the mask is 0 or 255
row:
    ld      a,(de)
    xor     c
    ld      (hl),a
    inc     de
    ld      a,l
    add     a,40
    ld      l,a
    jr      nc,no_carry
    inc     h
no_carry:
    djnz    row

underline:
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
