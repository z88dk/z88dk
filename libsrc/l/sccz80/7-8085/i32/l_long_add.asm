;       Z88 Small C+ Run Time Library
;       Long functions
;       "8080" mode
;       Stefano - 29/4/2002
;
;       feilipu 10/2021
;       8085 optimisation

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_add


;result = primary + secondary
;enter with secondary in dehl, primary on stack
;exit with result in dehl

.l_long_add
    ld      bc,de       ;get the upper 16 into bc
    ld      de,sp+2     ;points to i32 on stack

    ld      a,(de)
    add     a,l
    ld      l,a

    inc     de

    ld      a,(de)
    adc     a,h
    ld      h,a

    inc     de

    ld      a,(de)
    adc     a,c
    ld      c,a

    inc     de

    ld      a,(de)
    adc     a,b
    ld      b,a

    ld      de,bc       ;get the upper 16 back into de

    pop     bc          ;get return
    inc     sp
    inc     sp
    inc     sp
    inc     sp
    push    bc          ;save return

    ret
