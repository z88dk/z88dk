; sccz80 crt0 library - 8080 version

SECTION code_clib
SECTION code_l_sccz80
PUBLIC  l_long_mod
EXTERN  l_long_divide

.l_long_mod
    ld    a,128
    jp    l_long_divide
