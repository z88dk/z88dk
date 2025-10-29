;       Z88 Small C+ Run Time Library 
;       Long support functions
;       "8080" mode
;       Stefano - 30/4/2002
;
;       feilipu 10/2021
;       8080 optimisation

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_ucmp

; Unsigned compare of primary dehl (stack) and secondary dehl (registers)
;
; Entry:    primary  = (under two return addresses on stack)
;           secondary= dehl
;
; Exit:     Z = numbers the same
;           NZ = numbers different
;           C/NC = sign of difference [set if secondary > primary]
;           hl = 1
;
; Code takes secondary from primary

.l_long_ucmp
    ld      bc,hl       ;get the lower 16 into bc
    ld      hl,sp+4     ;points to u32 on stack

    ld      a,(hl)
    sub     a,c
    ld      c,a

    inc     hl

    ld      a,(hl)
    sbc     a,b
    ld      b,a

    inc     hl

    ld      a,(hl)
    sbc     a,e
    ld      e,a

    inc     hl

    ld      a,(hl)
    sbc     a,d
;   ld      d,a

; ATP we have done the comparision and are left with debc = result of
; primary - secondary, if we have a carry then secondary > primary

    jp      C,l_long_ucmp1

; Primary was larger, return NC
;   ld      a,d
    or      e
    or      b
    or      c
    scf
    ccf
    jp      l_long_ucmp2

; Secondary was larger, return C
.l_long_ucmp1
;   ld      a,d
    or      e
    or      b
    or      c
    scf

; We need to preserve flags in af
.l_long_ucmp2
    pop     bc          ;get returns
    pop     de
    pop     hl          ;pop u32
    pop     hl
    push    de          ;save returns
    push    bc

    ld      hl,1        ;saves some mem in comparision functions
    ret
