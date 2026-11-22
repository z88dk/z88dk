;
;   ANSI Video handling for the ZX81
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
    call    scrolluptxt
    jp      scrolluptxt


ansi_del_line:
    ld      hl, (16396)
    inc     hl
    and     a
    jr      z, isz
    ld      de, 66
    ld      b, a
gorow:
    add     hl, de
    djnz    gorow
isz:
    ld      b, 32
filler:
    ld      (hl), 0
    inc     hl
    djnz    filler
    inc     hl
    inc     de
    ld      b, 32
filler2:
    ld      (hl), 0
    inc     hl
    djnz    filler2
    ret
