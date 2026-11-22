
SECTION code_l_clang

PUBLIC __setflag


__setflag:
    ret po
    push af
    dec sp
    pop af
    xor $80
    push af
    inc sp
    pop af
    ret
