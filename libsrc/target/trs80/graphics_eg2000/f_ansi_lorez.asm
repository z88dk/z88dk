;
;   ANSI Video handling for the Colour Genie EG2000
;   Wrapper for putc4x6
;   By Stefano Bodrato - 2025
;
;    Display a char in location (__console_x),(__console_y)
;    A=char to display
;
;
;   $Id: f_ansi_lorez.asm $
;

    SECTION code_clib

    PUBLIC  ansi_CHAR
    PUBLIC  ansi_attr
    PUBLIC  ansi_cls
    PUBLIC  ansi_SCROLLUP
    PUBLIC  ansi_del_line
    PUBLIC  ansi_BEL

    EXTERN putc4x6
    EXTERN __console_x
    EXTERN x_4x6
    EXTERN __console_y
    EXTERN y_4x6
    EXTERN  clg
    EXTERN  scrolluptxt


ansi_CHAR:

    ld h,0
    ld l,a
;   sub     32
;    ld      (chr), a
    
    ld      a, (__console_x)
    add     a
    add     a
    ld      (x_4x6),a
    ld      a, (__console_y)
    add     a
    ld      b,a
    add     a
    add     b
    ld      (y_4x6),a

    push hl
    call  putc4x6
    pop hl
    ret


ansi_attr:
    ret


ansi_cls:
    jp      clg


ansi_SCROLLUP:
    ld      de, $4800
    ld      hl, $4800+40*6
    ld      bc, $FF0-40*6
    ldir
    ret


ansi_del_line:
    ld      hl, $4800
    and     a
    jr      z, isz
    ld      de, 40*6
    ld      b, a
gorow:
    add     hl, de
    djnz    gorow
isz:
    ld      b, 40*6
filler:
    ld      (hl), 0
    inc     hl
    djnz    filler
    ret


ansi_BEL:
    ld      a,(431ch)
    ld      b, 70
    ld      c, 255
BEL_loop:
    dec     h
    jr      nz, BEL_jump
    xor     3
    out     (c), a
BEL_FREQ_1:
    ld      h, 165
BEL_jump:
    dec     l
    jr      nz, BEL_loop
    xor     3
    out     (c), a
BEL_FR_2:
    ld      l, 180
    djnz    BEL_loop
    ret
