
SECTION code_l_clang

IF __CPU_Z80__ | __CPU_EZ80__
PUBLIC __lor


; dehl = dehl | iybc
__lor:
    push af
    ld a,d
    or iyh
    ld d,a
    ld a,e
    or iyl
    ld e,a
    ld a,h
    or b
    ld h,a
    ld a,l
    or c
    ld l,a
    pop af
    ret 
ENDIF
