;   sccz80 crt0 library - 8080 version
;
;   feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

EXTERN  l_hlneg
EXTERN  l_deneg
EXTERN  l_bcneg
EXTERN  l_div_u

PUBLIC  l_div


; HL = DE / HL, DE = DE % HL
l_div:
    ld      c,d             ;sign of dividend
    ld      b,h             ;sign of divisor
    push    bc              ;save signs

    ld      c,l             ;divisor to bc

    LD      a,d
    OR      a
    CALL    M,l_deneg

    LD      a,b
    OR      a
    CALL    M,l_bcneg

    ld      h,b             ;l_div_u takes the divisor in hl
    ld      l,c
    call    l_div_u

    ; C standard requires that the result of division satisfy
    ; a = (a/b)*b + a%b
    ; remainder takes sign of the dividend

    pop     bc                  ;restore sign info

    ld      a,b
    xor     c                   ;quotient, sign of dividend^divisor
    call    M,l_hlneg

    ld      a,c
    or      a,a                 ;remainder, sign of dividend
    ret     P

    jp      l_deneg
