; sccz80 crt0 library - 8080 version

SECTION code_crt0_sccz80

PUBLIC l_long_eq
EXTERN l_long_ucmp

.l_long_eq
    call    l_long_ucmp
    ld    hl,1
    scf
    ret    z

    dec    hl
    and    a
    ret
