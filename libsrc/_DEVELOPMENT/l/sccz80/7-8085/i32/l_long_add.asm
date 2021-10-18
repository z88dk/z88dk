;       Z88 Small C+ Run Time Library
;       Long functions
;       "8080" mode
;       Stefano - 29/4/2002
;
;       feilipu 10/2021
;       8085 optimisation stack 104 T -> 74 T

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_add


;primary = secondary + primary
;enter with secondary, primary on stack

.l_long_add
    ld      bc,de       ;get the upper 16 into bc
    ld      de,sp+2
    ex      de,hl       ;points to i32 on stack

    ld      a,(hl)
    add     e
    inc     hl
    ld      e,a

    ld      a,(hl)
    adc     a,d
    inc     hl
    ld      d,a

    ld      a,(hl)
    adc     a,c
    inc     hl
    ld      c,a

    ld      a,(hl)
    adc     a,b
    ld      b,a

    pop     hl          ;get return
    inc     sp
    inc     sp
    inc     sp
    inc     sp
    push    hl          ;save return

    ex      de,hl       ;get the lower 16 back into hl
    ld      de,bc       ;get the upper 16 back into de
    ret
