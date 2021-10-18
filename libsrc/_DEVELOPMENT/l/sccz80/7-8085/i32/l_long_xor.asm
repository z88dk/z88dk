;       Z88 Small C+ Run Time Library
;       Long functions
;       "8080" mode
;       Stefano - 29/4/2002
;
;       feilipu 10/2021
;       8085 optimisation stack 104 T -> 66 T

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_xor


;primary = secondary ^ primary
;enter with secondary in dehl, primary on stack

.l_long_xor
    ld      bc,de       ;get the upper 16 into bc
    ld      de,sp+2     ;points to i32 on stack

    ld      a,(de)
    xor     a,l
    ld      l,a

    inc     de

    ld      a,(de)
    xor     a,h
    ld      h,a

    inc     de

    ld      a,(de)
    xor     a,c
    ld      c,a

    inc     de

    ld      a,(de)
    xor     a,b
    ld      b,a

    pop     de          ;get return
    inc     sp
    inc     sp
    inc     sp
    inc     sp
    push    de          ;save return

    ld      de,bc       ;get the upper 16 back into de
    ret
