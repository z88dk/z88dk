; sccz80 crt0 library - 8080 version

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_ne

EXTERN l_long_ucmp

l_long_ne:
    call    l_long_ucmp
    ld      hl,1
    scf
    ret     NZ

    dec     hl
    and     a
    ret

