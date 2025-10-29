
SECTION code_l_clang

IF __CPU_Z80__ | __CPU_EZ80__
PUBLIC __lxor


; defhl = dehl ^ iybc
__lxor:
    push af
    ld a,d
    xor iyh
    ld d,a
    ld a,e
    xor iyl
    ld e,a
    ld a,h
    xor b
    ld h,a
    ld a,l
    xor c
    ld l,a
    pop af
    ret 

ENDIF
