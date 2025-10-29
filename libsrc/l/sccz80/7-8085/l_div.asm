;   sccz80 crt0 library - 8085 version
;
;   feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

EXTERN  l_hlneg
EXTERN  l_deneg
EXTERN  l_bcneg
EXTERN  l_div_0

PUBLIC  l_div

; HL = DE / HL, DE = DE % HL
.l_div
    ld      c,d             ;sign of dividend
    ld      b,h             ;sign of divisor
    push    bc              ;save signs

    ld      c,l             ;divisor to bc

    ld      a,d
    or      a
    call    M,l_deneg

    ld      a,b
    or      a
    call    M,l_bcneg

    call    l_div_0         ;unsigned HL = DE / BC, DE = DE % BC

    ; C standard requires that the result of division satisfy
    ; a = (a/b)*b + a%b
    ; remainder takes sign of the dividend

    pop     bc              ;restore sign info

    ld      a,b
    xor     c               ;quotient, sign of dividend^divisor
    call    M,l_hlneg

    ld      a,c
    or      a,a             ;remainder, sign of dividend
    ret     P

    jp      l_deneg
