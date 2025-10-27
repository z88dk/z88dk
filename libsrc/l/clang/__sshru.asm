
SECTION code_l_clang

PUBLIC __sshru


__sshru:
    inc c
    dec c
    ret z
    push bc
    ld b,c
loop:
    srl h
    rr l
    djnz loop
    pop bc
    ret

