;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dswap.asm,v 1.3 2016-06-22 19:55:06 dom Exp $

        SECTION code_fp
        PUBLIC  dswap

        EXTERN  fa

; Swaps FA for that on top of stack

dswap:
        ld      hl, 2
        add     hl, sp
        ld      de, fa+0
        ld      b, 6
loop:
        ld      a, (de)
        ld      c, a
        ld      a, (hl)
        ld      (hl), c
        ld      (de), a
        inc     hl
        inc     de
        djnz    loop
        ret

