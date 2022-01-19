;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021


SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_div

EXTERN  l_long_div_0, l_long_neg_mhl

;quotient = primary / secondary
;enter with secondary (divisor) in dehl, primary (dividend | quotient) on stack
;exit with quotient in dehl

.l_long_div
    ld      a,d                 ;check for divide by zero
    or      e
    or      h
    or      l                   ;clear Carry to quotient
    jr      Z, divide_by_zero

    push    de                  ;put secondary (divisor) on stack
    push    hl

    ld      bc,0                ;establish remainder on stack
    push    bc
    push    bc

    ld      c,d                 ;sign of divisor

    ld      hl,sp+13            ;sign of dividend
    ld      b,(hl)

    push    bc                  ;save sign info

    ld      hl,sp+12            ;dividend
    ld      a,b                 ;sign of dividend
    add     a,a                 ;test sign of dividend
    call    C,l_long_neg_mhl    ;take absolute value of dividend

    ld      hl,sp+6             ;divisor
    ld      a,c                 ;sign of divisor
    add     a,a                 ;test sign of divisor
    call    C,l_long_neg_mhl    ;take absolute value of divisor

    call    l_long_div_0        ;division loop

    ;tidy up with quotient to dehl

    ; C standard requires that the result of division satisfy
    ; a = (a/b)*b + a%b
    ; remainder takes sign of the dividend

    pop     bc                  ;restore sign info

    ld      hl,sp+10            ;quotient
    ld      a,b
    xor     c                   ;test sign of dividend^divisor
    add     a,a
    call    C,l_long_neg_mhl    ;negate quotient if signs different

    ld      hl,sp+12            ;get quotient MSW
    ld      c,(hl)
    inc     hl
    ld      b,(hl)

    ld      hl,sp+8             ;get return from stack
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      hl,sp+12            ;place return on stack
    ld      (hl),e
    inc     hl
    ld      (hl),d

    ld      hl,sp+10            ;get quotient LSW
    ld      e,(hl)
    inc     hl
    ld      d,(hl)

;   ld      hl,sp+12
    inc     hl                  ;point to return again
    ld      sp,hl               ;remove stacked parameters

    ex      de,hl               ;quotient LSW
    ld      de,bc               ;quotient MSW

    ret

.divide_by_zero
    pop     bc                  ;pop return
    pop     hl                  ;pop dividend
    pop     de
    push    bc                  ;replace return

    ld      a,h

    ld      de,$7fff            ;return dehl = LONG_MAX
    ld      hl,$ffff

    or      a
    add     a,a
    ret     NC                  ;if dividend positive

    inc     de                  ;return dehl = LONG_MIN
    inc     hl
    ret
