; sccz80 crt0 library - 8080 version

SECTION code_crt0_sccz80

PUBLIC  l_long_mod_u
EXTERN  l_long_divide

.l_long_mod_u
    ld    a,0
    jp    l_long_divide
