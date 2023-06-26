
SECTION code_crt_clang

PUBLIC __lxor


; xor dehl with iybc
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
