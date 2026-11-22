
SECTION code_l_clang

PUBLIC __sxor

; Unused: ?
__sxor:
    push af
    ld a,h
    xor b
    ld h,a
    ld a,l
    xor c
    ld l,a
    pop af
    ret 
