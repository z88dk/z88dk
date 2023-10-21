
SECTION code_l_clang

PUBLIC __snot

; Seems to be inlined

__snot:
    push af	;TODO Necessary?
    ld a,h
    cpl
    ld h,a
    ld a,l
    cpl
    ld l,a
    pop af
    ret
