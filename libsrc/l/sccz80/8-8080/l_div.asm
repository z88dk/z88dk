;   sccz80 crt0 library - 8080 version
;
;   feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

EXTERN  l_hlneg
EXTERN  l_deneg
EXTERN  l_bcneg
EXTERN  l_rlde
EXTERN  l_cmpbcde

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

    LD      a,16
    PUSH    AF
    EX      DE,HL
    LD      DE,0

ccdiv1:
    ADD     HL,HL
    call    l_rlde
    JP      Z,ccdiv2
    call    l_cmpbcde
    JP      M,ccdiv2

    LD      a,l
    OR      1
    LD      l,a
    LD      a,e
    sub     c
    LD      e,a
    LD      a,d
    SBC     b
    LD      d,a
ccdiv2:
    POP     AF
    DEC     a
    JP      Z,ccdiv3

    PUSH    AF
    JP      ccdiv1

ccdiv3:
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
