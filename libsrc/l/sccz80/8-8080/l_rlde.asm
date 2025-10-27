; sccz80 crt0 library - 8080 version

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_rlde

; {DE <r<r 1}
.l_rlde
    ld      a,e
    rla
    ld      e,a
    ld      a,d
    rla
    ld      d,a
    ret
