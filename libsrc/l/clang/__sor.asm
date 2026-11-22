
SECTION code_l_clang

PUBLIC __sor

; Unused: ?
__sor:
    push af
    ld a,h
    or b
    ld h,a
    ld a,l
    or c
    ld l,a
    pop af
    ret 
