SECTION code_clib
SECTION code_l

PUBLIC l_setix
EXTERN l_jpix_addr

l_setix:
    ld (l_jpix_addr),hl
    ret
