
SECTION code_l_clang

PUBLIC __lcmpzero

__lcmpzero:
    push bc
    ld c,a
    ld a,l
    or h
    or e
    or d
    jr z,zero
    ld a,d
    or 1
zero:
    cp 0
    ld a,c
    pop bc
    ret
