
SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_div

EXTERN l_deneg
EXTERN l_bcneg
EXTERN l_rlde
EXTERN l_cmpbcde


; HL = DE / HL, DE = DE % HL
l_div:
ccdiv:
    ld      bc,hl
    ld      a,d
    xor     b
    push    af
    ld      a,d
    or      a
    call    M,l_deneg
    ld      a,b
    or      a
    call    M,l_bcneg
    ld      a,16
    push    af
    ex      de,hl
    ld      de,0
ccdiv1:
    add     hl,hl
    rl      de
    jp      Z,ccdiv2
    call    l_cmpbcde
    jp      M,ccdiv2

    ld      a,l
    or      1
    ld      l,a
    ex      de,hl
    sub     hl,bc
    ex      de,hl
ccdiv2:
    pop     af
    dec     a
    jp      Z,ccdiv3

    push    af
    jp      ccdiv1

ccdiv3:
    pop     af
    ret     P
    call    l_deneg
    ex      de,hl
    call    l_deneg
    ex      de,hl
    ret

