;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021


SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_div_u

EXTERN  l_long_div_0

;quotient = primary / secondary
;enter with secondary (divisor) in dehl, primary (dividend | quotient) on stack
;exit with quotient in dehl

.l_long_div_u
    ld      a,d                 ;check for divide by zero
    or      e
    or      h
    or      l                   ;clear Carry to quotient
    jp      Z, divide_by_zero

    push    de                  ;put secondary (divisor) on stack
    push    hl

    ld      bc,0                ;establish remainder on stack
    push    bc
    push    bc

    push    bc                  ;save null sign info

    call    l_long_div_0        ;division loop

    ;tidy up with quotient to dehl

    ld      de,sp+14            ;get quotient MSW
    ld      hl,(de)
    ld      bc,hl               ;quotient MSW

    ld      de,sp+10            ;get return from stack
    ld      hl,(de)
    ld      de,sp+14            ;place return on stack
    ld      (de),hl

    ld      de,sp+12            ;get quotient LSW
    ld      hl,(de)

    ld      de,sp+14            ;point to return again
    ex      de,hl               ;quotient LSW <> return sp
    ld      sp,hl               ;remove stacked parameters

    ex      de,hl               ;quotient LSW
    ld      de,bc               ;quotient MSW

    ret

.divide_by_zero
    pop     bc                  ;pop return
    pop     hl                  ;pop dividend
    pop     de
    push    bc                  ;replace return

    ld      de,$ffff            ;return ULONG_MAX
    ld      hl,de

    ret
