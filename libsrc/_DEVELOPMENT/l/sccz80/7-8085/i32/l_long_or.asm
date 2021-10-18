;       Z88 Small C+ Run Time Library
;       Long functions
;       "8080" mode
;       Stefano - 29/4/2002
;
;       feilipu 10/2021
;       8085 optimisation stack 104 T -> 74 T

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_or


;Logical routines for long functions    dehl
;first opr on stack

; "or" deHL' and dehl into HLde'
.l_long_or
    ld      bc,de       ;get the upper 16 into bc
    ld      de,sp+2
    ex      de,hl       ;points to i32 on stack

    ld      a,e
    or      (hl)
    inc     hl
    ld      e,a

    ld      a,d
    or      (hl)
    inc     hl
    ld      d,a

    ld      a,c
    or      (hl)
    inc     hl
    ld      c,a

    ld      a,b
    or      (hl)
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
