
SECTION code_l_clang

PUBLIC __sshrs


__sshrs:
    inc c
    dec c
    ret z
    push bc
    ld b,c
loop:
    sra h
    rr l
    djnz loop
    pop bc
    ret

