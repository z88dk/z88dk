;       Z88 Small C+ Run Time Library
;       Long functions
;       "8080" mode
;       Stefano - 29/4/2002
;
;       feilipu 10/2021
;       8080 optimisation

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_and


;result = primary & secondary
;enter with secondary in dehl, primary on stack
;exit with result in dehl

.l_long_and
    ld      bc,hl       ;get the lower 16 into bc
    ld      hl,sp+2     ;points to i32 on stack

    ld      a,(hl)
    and     a,c
    ld      c,a

    inc     hl

    ld      a,(hl)
    and     a,b
    ld      b,a

    inc     hl

    ld      a,(hl)
    and     a,e
    ld      e,a

    inc     hl

    ld      a,(hl)
    and     a,d
    ld      d,a

    ld      hl,bc       ;get the lower 16 back into hl

    pop     bc          ;get return
    inc     sp
    inc     sp
    inc     sp
    inc     sp
    push    bc          ;save return

    ret
