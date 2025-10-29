;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021


SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_div_m

EXTERN  l_long_div_0

;for __printf_number where LSB of modulus is required in a

;quotient = primary / secondary
;enter with secondary (divisor) in dehl, primary (dividend | quotient) on stack
;exit with quotient in dehl

.l_long_div_m
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

    ld      hl,sp+14            ;get quotient MSW
    ld      c,(hl)
    inc     hl
    ld      b,(hl)

    ld      hl,sp+10            ;get return from stack
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      hl,sp+14            ;place return on stack
    ld      (hl),e
    inc     hl
    ld      (hl),d

    ld      hl,sp+2             ;get remainder LSB (for __printf_number)
    ld      a,(hl)

    ld      hl,sp+12            ;get quotient LSW
    ld      e,(hl)
    inc     hl
    ld      d,(hl)

;   ld      hl,sp+14
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

    ld      de,$ffff            ;return ULONG_MAX
    ld      hl,de

    ret
