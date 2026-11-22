
SECTION code_l_clang

PUBLIC __sand

; Unused: ?
__sand:
    push af
    ld a,h
    and b
    ld h,a
    ld a,l
    and c
    ld l,a
    pop af
    ret 
