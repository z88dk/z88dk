;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021


SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_mod_u

EXTERN l_long_div_0

;remainder = primary % secondary
;enter with secondary (divisor) in dehl, primary (dividend | quotient) on stack
;exit with remainder in dehl

.l_long_mod_u
    ld a,d                      ;check for divide by zero
    or e
    or h
    or l                        ;clear Carry to quotient
    jr Z, divide_by_zero
   
    push    de                  ;put secondary (divisor) on stack
    push    hl

    ld      bc,0                ;establish remainder on stack
    push    bc
    push    bc

    push    bc                  ;save null sign info

    call    l_long_div_0        ;division loop

    ;tidy up with remainder to dehl

    ld      hl,sp+10            ;get return from stack
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      hl,sp+14            ;place return on stack
    ld      (hl),e
    inc     hl
    ld      (hl),d

    ld      hl,sp+2             ;get remainder LSW
    ld      c,(hl)
    inc     hl
    ld      b,(hl)

;   ld      hl,sp+4
    inc     hl                  ;get remainder MSW
    ld      e,(hl)
    inc     hl
    ld      d,(hl)

    ld      hl,sp+14            ;point to return again
    ld      sp,hl               ;remove stacked parameters

    ld      hl,bc               ;remainder LSW

    ret

.divide_by_zero
    pop     bc                  ;pop return
    pop     hl                  ;pop dividend
    pop     de
    push    bc                  ;replace return

    ld      de,0                ;return ZERO
    ld      hl,de

    ret
