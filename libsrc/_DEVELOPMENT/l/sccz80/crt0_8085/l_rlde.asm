; sccz80 crt0 library - 8085 version

SECTION code_crt0_sccz80

PUBLIC l_rlde

; {DE <r<r 1}
.l_rlde: 
    rl de
    ret
